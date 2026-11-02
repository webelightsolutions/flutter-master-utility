# Telemetry

`master_utility` tracks operations (API calls or any app action) and reports them in two ways:

| Output | Where it goes | Who decides |
|---|---|---|
| **Metrics** (counts, durations) | Sentry `Sentry.metrics`, **release builds only** | Package |
| **Analytics events** | The sink function the app registers | App (Firebase, Mixpanel, your backend, anything) |

The package has no dependency on Firebase or Mixpanel. You plug in your provider with one function.

```
App tags an operation ──▶ Package tracks it (timer, outcome)
                              ├─▶ Sentry metrics
                              └─▶ your sink(eventName, properties) ─▶ Firebase / Mixpanel / backend
```

---

## 1. Setup: register a sink (once, at app start)

The sink receives every analytics event. If you don't register one, events are dropped and metrics still go to Sentry.

```dart
TelemetryReporter.registerAnalyticsSink((String name, Map<String, Object> props) {
  // send it anywhere
});
```

Call it in `main()` or in your analytics `init()`, before the first tracked operation. Errors thrown synchronously inside the sink are caught by the package. A failed `Future` is not caught, so end async calls with `.ignore()` (or `.catchError`).

### Firebase

```dart
final firebase = FirebaseAnalytics.instance;

TelemetryReporter.registerAnalyticsSink((name, props) {
  firebase
      .logEvent(
        name: name,
        // Firebase accepts only String/num values
        parameters: props.map((k, v) => MapEntry(k, v is num ? v : v.toString())),
      )
      .ignore();
});
```

Firebase limits: event and parameter names can be at most 40 characters, letters, digits and `_` only. The package's own event names already meet this.

### Mixpanel

```dart
final mixpanel = await Mixpanel.init(token, trackAutomaticEvents: false);

TelemetryReporter.registerAnalyticsSink((name, props) {
  mixpanel.track(name, properties: props);
});
```

### Custom backend

```dart
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

TelemetryReporter.registerAnalyticsSink((name, props) {
  dio.post('/events', data: {
    'name': name,
    'properties': props,
    'timestamp': DateTime.now().toUtc().toIso8601String(),
  }).ignore(); // drop network errors
});
```

### Several providers at once

Only one sink is registered at a time, and a later call replaces the earlier one. To send to several providers, fan out inside one sink:

```dart
TelemetryReporter.registerAnalyticsSink((name, props) {
  mixpanel.track(name, properties: props);
  firebase.logEvent(name: name, parameters: props.map((k, v) => MapEntry(k, v is num ? v : v.toString())));
});
```

---

## 2. Tracking API calls

Set `operation` on an `APIRequest`. `APIService` tracks the request automatically. If `operation` is `null`, nothing is tracked.

```dart
final request = APIRequest(
  url: '/orders',
  methodType: MethodType.POST,
  params: body,
  operation: const TelemetryOperation('create_order'),
  operationAttributes: {'source': 'checkout', 'phase': TelemetryPhase.forPage(page)},
);
```

Outcome mapping:

| Result | Outcome | Extra attributes |
|---|---|---|
| Request succeeded | `success` | |
| Dio cancel | `cancelled` | `reason: cancel` |
| Other `DioException` | `failure` | `reason: <dio type>`, `status_code` |
| Any other error (e.g. mapping) | `failure` | `reason: unexpected` |

---

## 3. Tracking any action (not just API calls)

### Simple event: tap, screen view

```dart
OperationTelemetry.trackEvent('checkout_tapped', properties: {'cart_items': 3});
```

Properties are **not** filtered, so they reach your sink as-is.

### Timed async action: upload, payment, DB save

```dart
final result = await OperationTelemetry.measure(
  const TelemetryOperation('upload_photo'),
  () => uploader.upload(photo),
  attributes: {'source': 'camera'},
);
```

When the action returns, the outcome is `success`. When it throws, the outcome is `failure` with `reason: unexpected`, and the error is rethrown.

### Manual: multi-step flows, screens, user cancellation

```dart
final tracker = OperationTelemetry.startTracking(const TelemetryOperation('onboarding'));

tracker.addAttributes({'stage': 'profile'});   // optional, any time

tracker.markSuccess();
// or tracker.markFailure(reason: 'validation');
// or tracker.markCancelled(reason: 'back_pressed');
// or tracker.complete(TelemetryOutcome.permissionDenied);
```

Only the first `mark*`/`complete` call counts. Later calls are ignored.

### Helpers

```dart
OperationTelemetry.reportActionBlocked(reason: 'no_internet', target: 'checkout');
OperationTelemetry.reportRetryRequested(const TelemetryOperation('upload_photo'));
OperationTelemetry.recordCount('cache.hit', attributes: {'target': 'feed'});
OperationTelemetry.recordDistribution('image.size', bytes, TelemetryUnit.byte);
```

`recordCount` and `recordDistribution` go to Sentry metrics only. They are not sent to the sink.

Pass `sendAnalyticsEvents: false` to `startTracking`/`measure` to send only metrics, for example on hot paths where you don't want analytics noise.

---

## 4. Attribute rules (important)

Operation attributes (`operationAttributes`, `attributes:`, `addAttributes`) are filtered **before** they reach both Sentry and your sink. A key is kept only if:

- **The key is allowed:** `source`, `phase`, `mode`, `media_type`, `target`, `stage`, `result`, `reason`, `retry`, `destination`, `permission`, `action`, `is_stale`, `status_code`.
- **The value is** a `bool`, a `num`, or a `String` matching `^[a-zA-Z0-9_.-]{1,80}$` (no spaces, no PII-looking text).

Anything else is **silently dropped**. For example, `{'screen': 'checkout'}` is dropped, so use `{'source': 'checkout'}` instead. To allow a new key, add it to `TelemetryAttributes._allowedKeys`.

Every payload also includes `schema_version: 1`.

---

## 5. What your sink receives

| Event | When | Properties |
|---|---|---|
| `operation_started` | Tracker created | `operation`, `operation_id`, `schema_version`, attributes |
| `operation_completed` | Tracker completed | the above plus `outcome`, `duration_ms` |
| `action_blocked` | `reportActionBlocked` | `reason`, `target?`, `schema_version` |
| `retry_requested` | `reportRetryRequested` | `operation`, `schema_version` |
| *your name* | `trackEvent` | your properties plus `schema_version` |

`outcome` is one of: `success`, `failure`, `rejected`, `cancelled`, `permissionDenied`, `unavailable`.

`operation_id` is the same in the `started` and `completed` events of one operation, so you can join them in your backend.

## Sentry metrics (release builds only)

`operation.started`, `operation.completed`, `operation.duration` (ms), `action.blocked`, `action.retried`.
