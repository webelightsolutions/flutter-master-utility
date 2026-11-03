# api_helper refactor plan

Scope: `lib/src/api_helper/` (~1.1k lines, 22 files).
Goal: easier to read and split into clear parts, **with zero code changes needed in any app that already uses this package.**

---

## Final change list

**The refactor has no breaking changes and no behaviour changes.** Apps' code compiles and behaves exactly as before,
bugs included. The known bugs (D) are listed here but **not fixed in the refactor**. Each one gets its own separate
commit afterwards (§8).

### A. Internal cleanup (apps see nothing)
1. Drop the `part` files and split into `client/`, `request/`, `response/`, `error/`, `service/`, `interceptors/`.
2. Point `lib/master_utility.dart` at the new file paths. It exports exactly the same public names as before.
3. Replace the 5-branch method `switch` with one `dio.request` call. The body and progress rules per method live in a **private** extension in `api_service.dart` (`_bodyFor`, `_sendProgressCallback`, `_receiveProgressCallback`), so `APIRequest`'s public API doesn't grow.
4. Move inline error mapping into the `ApiExceptionMapper` class. Same messages and **same behaviour**, including bug D3.
5. Rename short local names (`e`, `v`, `err`, `config`, `data`, …) and fix the `refreshToke` typo.
6. Delete the dead branch in `JwtHeroInterceptor.onError` (it can never run, so behaviour is unchanged).
7. Keep new classes (`ApiExceptionMapper`, …) out of the barrel, so they can't clash with app class names.

### B. New members (additive)
8. `dioClient.dio`: the configured `Dio`.
9. `APIRequest`: `body`, `bodyList`, `headers`, `requiresAuth`.
10. `MethodType.get / post / patch / put / delete` (aliases of the uppercase values).
11. `APIConstError`: `somethingWentWrong`, `noInternetConnection`, `connectionFailed`, `internalServerError`,
    `sendTimeout`, `receiveTimeout`, `connectionTimeout`, `requestCancelled`, `loginFailed`, `invalidStatusCode()`.
12. `ErrorHandler.messageFor(dioException)`.
13. `APIService.joinValidationMessages(errorDetails)`.
14. `APIService({DioClient? client})`: an optional param, for tests.
15. `lib/fix_data.yaml`, so `dart fix --apply` migrates apps to the new names.

### C. Deprecated (still work, apps see a hint)
16. `APIRequest.params`, `paramList`, `header`, `isAuthorization` (constructor params and fields) → item 9.
17. `APIRequest.file` (never used).
18. `APIConstError.kSomethingWentWrong`, `kNoInternetConnection`, `kNoInternetConnection2`, `kInternalServerError`,
    `kSendTimeOUT`, `kReceiveTimeOut`, `kTimeOut`, `kCancelled`, `errorLoginFailed`, `kInvalidStatusCode()` → item 11.
19. `ErrorHandler.getDioError()` → item 12.
20. `APIService.setErrorData()` → item 13.

`DioClient.getDioClient()` is **not** deprecated in the refactor: `APIService` still uses it. It becomes deprecated in
fix commit D1+D2, which stops using it.

### D. Known bugs: listed, NOT fixed in the refactor (one separate commit each, §8)
| # | Bug | Fix (described in) |
|---|---|---|
| D1 | Concurrent 401s trigger one token refresh **per request** instead of one in total | Build interceptors once (§4) |
| D2 | Requests running at the same time can pick up each other's auth, logging or `onError` settings | Same change as D1 (§4) |
| D3 | An error response with an unexpected body makes `getResponseWithMapper` **throw** instead of returning `left(...)` | Guards in `ApiExceptionMapper` (§5) |
| D4 | API logs are on in release builds unless the app turns them off. Refresh and retry clients always log | §7 |
| D5 | Tokens and cookies are printed in curl logs | §7 |
| D6 | An empty `Authorization: Bearer ` header is sent when there's no token | §7 |
| D7 | Retrying a request changes the original request's headers | §6 |
| D8 | Calling the API before `setConfiguration` gives a bare null-check crash | `dio` getter throws a clear `StateError` (§4) |
| D9 | After a 401 → refresh → retry, the retried response is **lost**: the retry runs on the server, but the app gets `left(somethingWentWrong)`. Cause: `JwtHeroInterceptor` mixes in `RequestRetryMixin<Response<dynamic>>`, so the retry calls `request<Response<dynamic>>()` and Dio fails to cast the JSON body. Found by the Phase 0 tests. | Mix in `RequestRetryMixin<dynamic>` (one line) |

D1 and D2 have one root cause, so they share one commit. D8 rides along, because that commit is where `APIService` switches to the `dio` getter. Every other bug gets its own commit.

### E. What app developers do
- Required: `flutter pub upgrade --major-versions master_utility`.
- Optional: `dart fix --apply` to clear the deprecation hints.

---

## 0. Compatibility contract (read this first)

`master_utility` is published and used by many apps. **This refactor has no breaking changes.** Every PR in this plan
must pass this contract. A change that can't pass it is not part of this plan.

### 0.1 What an app must NOT have to do
- Change any import, class name, method name, parameter, field or return type. Everything existing still compiles.
- Handle a different error message for the same server response.

What apps **will** see: `@Deprecated` hints on the old names that have a better replacement (§3.3). The old names
keep working. The hint just points to the new name, and `dart fix --apply` makes the switch automatically (§3.4).
Apps can migrate whenever they like.
> One heads-up for the CHANGELOG: apps whose CI runs `flutter analyze --fatal-infos` will see `deprecated_member_use`
> infos fail CI until they run `dart fix --apply` or loosen that flag. Their code still builds and runs.

To upgrade, apps run `flutter pub upgrade --major-versions master_utility`. Plain `pub upgrade` won't do it, because
`^0.0.21` only allows exactly `0.0.21`. See §8 for the version choice.

### 0.2 Public surface that must stay identical
Everything reachable from `package:master_utility/master_utility.dart` today:

| Type | Must keep |
|---|---|
| `APIService` | `APIService()` constructor, `getResponseWithMapper<T>(request, {formData, jsonMapper, listJsonMapper})` returning `Future<Either<ApiException, T>>`, `setErrorData(List<ErrorDetails>?)` |
| `APIRequest` | Constructor and **every field, still mutable** (including the unused `file`) |
| `MethodType` | `GET, POST, PATCH, PUT, DELETE` |
| `APIResponse<T>` | `APIResponse(...)`, `.fromJson(response, {create})`, `.custom(message:)`, all fields |
| `ApiException` | Constructor and **mutable** fields |
| `APIConstError` | Every field, **still `static String` (not `const`/`final`)**. Apps may reassign them for localization, so they're read at call time. |
| `ErrorHandler` | `ErrorHandler.instance.getDioError(DioException)` |
| `dioClient` / `DioClient` | `setConfiguration(...)` (same params), `setRefreshTokenConfiguration(...)`, `getDioClient({isAuth, showHttpLogging, showCurlLogging, callback})`, static `setIsApiLogVisible`, **public mutable fields `customErrorMapper` and `globalOnErrorHandler`** (setting them *after* configure must still work) |
| JWT | `JwtHeroInterceptor` (constructor and `shouldRefresh`), `JwtToken`, `SessionManager`, `SessionStatus`, `TokenStorage`, `RefreshTokenConfiguration`, `ResponseMapper`, `BodyDataCallback`, `HeadersCallback` |
| typedefs | `JsonMapper`, `ListJsonMapper`, `CustomErrorMapper` |
| re-export | `package:dio/dio.dart` |

### 0.3 Only the barrel import is supported
Apps use `import 'package:master_utility/master_utility.dart';` only. Files under `lib/src/` are private to the package
(Dart convention, and `implementation_imports` lint), so they can be moved and renamed freely. No compatibility files
are left at the old paths.
> Rare risk: Dart doesn't *block* `src/` imports, it only lints them. An app that imported e.g.
> `src/api_helper/api_error_model.dart` would need to change that import. CHANGELOG line: "Internal files moved; import
> `package:master_utility/master_utility.dart` only".

### 0.4 New code stays private
New classes (`RequestFlags`, `ApiExceptionMapper`, `PerRequestErrorInterceptor`, …) are **not** added to the barrel.
A new exported name can clash with a class of the same name in an app, which is a compile error ("ambiguous import").
New *members* on existing classes (`DioClient.dio`, the optional `APIService({DioClient? client})`) are safe.

### 0.5 Behaviour changes
**None in the refactor.** Every test in §8 that records today's behaviour (bugs included) stays green through all refactor
PRs. The bug fixes (D1–D8) come afterwards, one commit each. Each fix commit changes exactly the tests for its own bug,
and its CHANGELOG line describes that one change.

---|---|---|---|
| Concurrent 401s (B1) | N refresh calls | 1 refresh, others wait | Same result, fewer calls |
| Weird error bodies (B4) | `getResponseWithMapper` **throws** | returns `left(ApiException)` | It already promised `Either` |
| Release-build logs (B3) | On by default, tokens printed | Off in release, tokens masked in debug | Logarte (opt-in) untouched; `setIsApiLogVisible` same rules |
| Empty token (B6) | Sends `Authorization: Bearer ` | Sends no header | Server sees "no auth" either way |

Anything else that changes observable behaviour is a bug in the refactor.

---

## 1. What's actually wrong (from reading the code)

### Structural (readability)
| # | Where | Problem |
|---|---|---|
| S1 | `api_service.dart` + 5 `part` files | Everything is one library. `MethodType` lives in a file called `api_helper.dart`, and you can't tell what depends on what. |
| S2 | `api_service.dart:16-80` | A 5-branch `switch` that all does nearly the same `dio` call. |
| S3 | `api_service.dart:129-198` | 70 lines of error mapping inline. Builds **fake `Response` objects** only so it can reuse `APIResponse.fromJson` to pull out a message. |
| S4 | `dio_client.dart:23-66` | `getDioClient` **tears down and rebuilds the interceptor chain on every request**. |
| S5 | `interceptor/jwt/refresh_token_configuration_mode_class.dart` | Odd name; config sits next to the interceptor internals. |
| S6 | `jwt_hero_interceptor.dart:145` | `jwtToken.isValid && !shouldRefresh(...)` is always false (we already returned when `!shouldRefresh`), so that branch is dead. |

### Bugs
Mapping to the final list: B1→D1, B2→D2, B3→D4+D5, B4→D3, B6→D6, B7→D7, B8→D8. None are fixed in the refactor.

| # | Where | Bug |
|---|---|---|
| B1 | `dio_client.dart:32,60,77` | A **new `JwtHeroInterceptor` (plus 2 Dio clients) per request**. `QueuedInterceptor` only queues inside one instance, so concurrent 401s fire **multiple refresh calls**. |
| B2 | `dio_client.dart:32` | One shared `Dio` gets its interceptors cleared and re-added per call. Requests in flight with different `isAuthorization` / `onError` **race**. |
| B3 | `dio_client.dart:137`, `jwt_hero_interceptor.dart:45-46` | Logging is on in release unless the app calls `setIsApiLogVisible`. Refresh and retry clients always log. Curl output prints `Authorization: Bearer …`. |
| B4 | `api_service.dart:141` | `e.response?.data['detail']` runs inside the `on DioException` block. A String/List body, or `detail` items with no `loc`, throws, and that escapes to the caller. |
| B6 | `authorization.dart:16` | Sends `Bearer ` (empty) when no token is stored. |
| B7 | `request_retry_mixin.dart:35` | `requestOptions.headers..addAll(...)` mutates the original request's headers. |
| B8 | `dio_client.dart:65` | `_dio!` crashes with a bare null-check error if `setConfiguration` was never called. |

---

## 2. Target layout

```
lib/src/api_helper/
├── client/
│   └── dio_client.dart                    # DioClient: owns the one Dio, configured once
├── request/
│   ├── api_request.dart                   # APIRequest: knows how to turn itself into Dio Options
│   ├── request_flags.dart                 # RequestFlags (private to package)
│   └── method_type.dart
├── response/
│   ├── api_response.dart
│   └── api_exception.dart
├── error/
│   ├── api_error_messages.dart            # APIConstError + ErrorHandler
│   ├── api_error_model.dart               # ApiErrorModel / ErrorDetails (422 "detail")
│   └── api_exception_mapper.dart          # ApiExceptionMapper (private to package)
├── service/
│   └── api_service.dart                   # APIService
├── interceptors/
│   ├── auth_token_interceptor.dart
│   ├── curl_logger_interceptor.dart
│   ├── default_request_flags_interceptor.dart
│   ├── per_request_error_interceptor.dart
│   └── jwt/
│       ├── refresh_token_configuration.dart
│       └── … (jwt_hero_interceptor, token_storage, session_manager, jwt_token, mixins)
└── type_defs.dart                          # JsonMapper, ListJsonMapper, CustomErrorMapper
```

Old files (`api_service.dart` + its 5 `part` files, `api_helper.dart`, `dio_client.dart`, `api_error_model.dart`,
`type_def/`, `interceptor/`, `interceptor/jwt/jwt_hero.dart`) are **deleted**, not kept as stubs.

`lib/master_utility.dart` replaces its 5 api_helper exports with the new paths. It exports the **same public names** as
before (§0.2), and none of the private ones (§0.4):
```dart
export 'package:master_utility/src/api_helper/client/dio_client.dart';
export 'package:master_utility/src/api_helper/error/api_error_messages.dart';
export 'package:master_utility/src/api_helper/interceptors/jwt/jwt_hero_interceptor.dart';
export 'package:master_utility/src/api_helper/interceptors/jwt/jwt_token.dart';
export 'package:master_utility/src/api_helper/interceptors/jwt/refresh_token_configuration.dart';
export 'package:master_utility/src/api_helper/interceptors/jwt/session_manager.dart';
export 'package:master_utility/src/api_helper/interceptors/jwt/token_storage.dart';
export 'package:master_utility/src/api_helper/request/api_request.dart';
export 'package:master_utility/src/api_helper/request/method_type.dart';
export 'package:master_utility/src/api_helper/response/api_exception.dart';
export 'package:master_utility/src/api_helper/response/api_response.dart';
export 'package:master_utility/src/api_helper/service/api_service.dart';
export 'package:master_utility/src/api_helper/type_defs.dart';
```

The flow is one direction only: `service → client → interceptors`, and `service → error`.

---

## 3. Coding conventions for this refactor

### 3.1 General rules
| Instead of | Write |
|---|---|
| `r`, `res`, `e`, `err`, `st`, `cb`, `m`, `d`, `o`, `v` | `request`, `response`, `dioException`, `stackTrace`, `onErrorCallback`, `message`, `errorDetails`, `requestOptions`, `detailJson` |
| `catch (_)`, `_`, `__` for params | a real name, even if unused: `catch (parseError)`, `requestStream`, `cancelFuture` |
| `data` for everything | what it is: `responseBody`, `requestBody`, `json` |
| bools | yes/no questions: `requiresAuth`, `skipAuth`, `shouldLog`, `hasValidationDetails` |
| `kSomething` constants | lowerCamelCase without the `k` (Effective Dart style) |
| `UPPERCASE` enum values | lowerCamelCase |
| magic numbers | `HttpStatus.unprocessableEntity`, `HttpStatus.internalServerError` (from `dart:io`) |

Also: one class per file, the file named after its class, and private helpers below the public method that uses them.

### 3.2 Local and private names in existing files (free to rename, apps can't see them)
| File | Today | Rename to |
|---|---|---|
| `api_service.dart` | `catch (e)`, `final data = await compute(...)`, `errorModel`, `responseData` | `dioException`, `mappedResponse`, (gone, see §5) |
| `api_response.dart` | `catch (e)` ×2 | `catch (messageParseError)`, `catch (cookieParseError)` |
| `api_error_model.dart` | `forEach((v) …)`, `final data = Map()` | `for (final detailJson in json['detail'])`, `final json = <String, dynamic>{}` |
| `dio_client.dart` | `config`, `headers`, `body`, `token`, `options` | `refreshConfiguration`, `refreshHeaders`, `refreshBody`, `refreshedToken`, `baseOptions` |
| `curl_logger.dart` | `err` ×2, `data`, `buffer` | `dioException`, `curlBuildError`, `requestBody`, `curlCommand` |
| `jwt_hero_interceptor.dart` | `err` ×12, `previousRequest` | `dioException`, `retriedResponse` |
| `jwt_refresher_mixin.dart` | `error` | `refreshError` |
| `token_validator_ext.dart` | `catch (e)` | `catch (decodeError)` |
| `refresh_typedef.dart` | `refreshToke` (typo) | `refreshToken` |

Positional parameter names of public methods (e.g. `getDioError(DioException error)`) are also safe to rename.
Callers never write them.

### 3.3 Public names: add the proper name, keep the old one working
A public name can't just be renamed, because every app using it would stop compiling. So:

1. The **proper name becomes the real member**, and the docs and README use it.
2. The **old name stays as a one-line forwarder** (getter/setter or method) to the new one, marked
   `@Deprecated('Use <newName> instead.')`. It keeps working; apps just see a hint.
3. Old and new names share **one storage**, so setting either one changes both.
4. Old names are **not removed** as part of this plan.

| Where | Old name (works, `@Deprecated`) | Proper name (new) | Why |
|---|---|---|---|
| `APIRequest` | `params` | `body` | It's the request body, not query params |
| `APIRequest` | `paramList` | `bodyList` | Same |
| `APIRequest` | `header` | `headers` | It's a map of many headers |
| `APIRequest` | `isAuthorization` | `requiresAuth` | Reads as a question |
| `APIRequest` | `file` | none (it was never used) | Deprecated as "has no effect" |
| `APIConstError` | `kSomethingWentWrong`, `kNoInternetConnection`, `kNoInternetConnection2`, `kInternalServerError`, `kSendTimeOUT`, `kReceiveTimeOut`, `kTimeOut`, `kCancelled`, `errorLoginFailed`, `kInvalidStatusCode()` | `somethingWentWrong`, `noInternetConnection`, `connectionFailed`, `internalServerError`, `sendTimeout`, `receiveTimeout`, `connectionTimeout`, `requestCancelled`, `loginFailed`, `invalidStatusCode()` | No `k` prefix, no `2`, consistent casing |
| `ErrorHandler` | `getDioError(error)` | `messageFor(dioException)` | Says what it returns |
| `APIService` | `setErrorData(details)` | `joinValidationMessages(errorDetails)` | It joins, it doesn't "set" |
| `DioClient` | `getDioClient(...)` | `dioClient.dio`, or `APIService` + `APIRequest(requiresAuth: …)` for per-request options | Deprecated in **Fix 1**, not in the refactor. It still works exactly as today (§4) |

**Added but not deprecated:** `MethodType.get/post/patch/put/delete` as aliases of `GET/POST/...`. The uppercase values
are the real enum values: the package's own exhaustive `switch` uses them, and `.name` is sent as the HTTP method.
So both spellings stay valid.

### 3.4 `dart fix` support: apps migrate with one command

> **Done.** `lib/fix_data.yaml` and `test_fixes/` exist. `cd test_fixes && dart fix --compare-to-golden` passes.
> `test_fixes/analysis_options.yaml` enables `deprecated_member_use_from_same_package`, because without it the analyzer
> doesn't report same-package deprecations and no fix is applied. The root `analysis_options.yaml` excludes `test_fixes/**`.
Ship `lib/fix_data.yaml`. After upgrading, apps run `dart fix --apply` and every deprecated name in their code is
rewritten to the new one. Sample:

```yaml
version: 1
transforms:
  - title: "Rename 'params' to 'body'"
    date: 2026-11-02
    element:
      uris: ['package:master_utility/master_utility.dart']
      constructor: ''
      inClass: 'APIRequest'
    changes:
      - kind: 'renameParameter'
        oldName: 'params'
        newName: 'body'
  - title: "Rename 'params' to 'body'"
    date: 2026-11-02
    element:
      uris: ['package:master_utility/master_utility.dart']
      getter: 'params'
      inClass: 'APIRequest'
    changes:
      - kind: 'rename'
        newName: 'body'
  - title: "Rename 'kTimeOut' to 'connectionTimeout'"
    date: 2026-11-02
    element:
      uris: ['package:master_utility/master_utility.dart']
      getter: 'kTimeOut'
      inClass: 'APIConstError'
    changes:
      - kind: 'rename'
        newName: 'connectionTimeout'
  # ...one entry per row in the §3.3 table (setters use `setter:`, methods use `method:`)
```
Check it with Dart's golden-file test: add `test_fixes/api_request.dart` (old names) and
`test_fixes/api_request.dart.expect` (new names), then run `dart fix --compare-to-golden test_fixes`.

**Not renamed:** class names (`APIService`, `APIRequest`, `APIResponse`, `APIConstError`). Adding `ApiService` etc. as new
top-level names would clash with classes many apps already define themselves (§0.4). Same for `getResponseWithMapper`,
which is clear enough as it is.

How the forwarding looks:

```dart
// error/api_error_messages.dart
class APIConstError {
  static String somethingWentWrong = 'Something went wrong.';
  static String connectionFailed = 'Connection to API server failed due to internet connection';
  static String connectionTimeout = 'Connection timeout with API server';
  // ...the rest, same text as today...

  static String invalidStatusCode({required int statusCode}) => 'Received invalid status code: $statusCode';

  @Deprecated('Use somethingWentWrong instead.')
  static String get kSomethingWentWrong => somethingWentWrong;
  @Deprecated('Use somethingWentWrong instead.')
  static set kSomethingWentWrong(String message) => somethingWentWrong = message;

  @Deprecated('Use connectionFailed instead.')
  static String get kNoInternetConnection2 => connectionFailed;
  @Deprecated('Use connectionFailed instead.')
  static set kNoInternetConnection2(String message) => connectionFailed = message;

  @Deprecated('Use invalidStatusCode instead.')
  static String kInvalidStatusCode({required int statusCode}) => invalidStatusCode(statusCode: statusCode);
  // ...one getter/setter pair per old name...
}
```

```dart
// request/method_type.dart (enhanced enum statics need Dart 2.17, our minimum)
enum MethodType {
  GET,
  POST,
  PATCH,
  PUT,
  DELETE;

  static const MethodType get = GET;
  static const MethodType post = POST;
  static const MethodType patch = PATCH;
  static const MethodType put = PUT;
  static const MethodType delete = DELETE;
}
```
> The real values stay uppercase. Renaming them would break apps that `switch` on `MethodType.GET`, and would change
> `.name`, which we send as the HTTP method. The lowercase names are aliases of the same values, so
> `MethodType.get == MethodType.GET`.

```dart
// request/api_request.dart
class APIRequest {
  APIRequest({
    required this.url,
    required this.methodType,
    Map<String, dynamic>? body,
    List<dynamic>? bodyList,
    Map<String, dynamic>? headers,
    bool? requiresAuth,
    this.queryParams,
    this.cancelToken,
    this.onReceiveProgress,
    this.onSendProgress,
    this.onError,
    this.showHttpLogging = true,
    this.showCurlLogging = true,
    @Deprecated('Has no effect; it was never used.') this.file,

    // Old parameter names: still work, apps see a hint pointing to the new name.
    @Deprecated('Use body instead.') Map<String, dynamic>? params,
    @Deprecated('Use bodyList instead.') List<dynamic>? paramList,
    @Deprecated('Use headers instead.') Map<String, dynamic>? header,
    @Deprecated('Use requiresAuth instead.') bool isAuthorization = true,
  })  : assert(body == null || params == null, 'Pass body or params, not both.'),
        assert(headers == null || header == null, 'Pass headers or header, not both.'),
        body = body ?? params,
        bodyList = bodyList ?? paramList,
        headers = headers ?? header,
        requiresAuth = requiresAuth ?? isAuthorization;

  String url;
  MethodType methodType;
  Map<String, dynamic>? body;
  List<dynamic>? bodyList;
  Map<String, dynamic>? headers;

  /// Adds `Authorization: Bearer <token>` when true.
  bool requiresAuth;
  // ...other fields unchanged...

  @Deprecated('Use body instead.')
  Map<String, dynamic>? get params => body;
  @Deprecated('Use body instead.')
  set params(Map<String, dynamic>? requestBody) => body = requestBody;

  @Deprecated('Use bodyList instead.')
  List<dynamic>? get paramList => bodyList;
  @Deprecated('Use bodyList instead.')
  set paramList(List<dynamic>? requestBodyList) => bodyList = requestBodyList;

  @Deprecated('Use headers instead.')
  Map<String, dynamic>? get header => headers;
  @Deprecated('Use headers instead.')
  set header(Map<String, dynamic>? requestHeaders) => headers = requestHeaders;

  @Deprecated('Use requiresAuth instead.')
  bool get isAuthorization => requiresAuth;
  @Deprecated('Use requiresAuth instead.')
  set isAuthorization(bool value) => requiresAuth = value;
}
```
> These asserts only fire when an app passes **both** the old and the new name, which no existing app can do yet.
> So they can't break anyone.

### Where OOP is used (and where it isn't)
| Class | OOP idea | Why it helps |
|---|---|---|
| `APIRequest.toDioOptions()` / `bodyWith()` | Encapsulation | The request knows how it maps to Dio, so the service has no `switch` |
| `RequestFlags` | Value object | Typed per-request switches instead of raw string keys in `extra` |
| `ApiExceptionMapper` | Single responsibility + constructor injection | Testable without the global `dioClient` |
| `APIService` | Composition | Holds a `DioClient`, delegates sending and error mapping |
| `*Interceptor extends Interceptor` | Polymorphism (Dio's design) | One concern per subclass |
| `TokenStorage` | Abstraction | The only abstract class, because apps really do implement it |

**Not** added: `IApiService`, `IDioClient`, base repositories, factories. Each would have one implementation.

---

## 4. Fix commit D1 + D2 (+ D8): build the pipeline once, pass flags per request

> **Not part of the refactor.** During the refactor, `APIService` keeps calling `getDioClient(...)` per request exactly as
> today, and `APIRequest.toDioOptions()` only sets `method` and `headers`. This section is the separate fix commit that
> follows. The `AuthTokenInterceptor` snippet below also includes D6, which belongs in D6's own commit. Leave that line
> as it is today here.

Today every call rebuilds the interceptor chain (S4, B1, B2). Instead:

1. `setConfiguration` / `setRefreshTokenConfiguration` build the interceptors. The `JwtHeroInterceptor` is created
   **once per configuration** (fixes B1).
2. `APIService` attaches per-request switches to each request via `Options.extra` (fixes B2: no shared mutable state).
3. Interceptors read those switches, plus the *current* values of `globalOnErrorHandler` and `_isApiLogVisible`, at call time.
   So apps that set them after configuring still work.

Dio reads the interceptor list once when a request starts (verified in dio 5.11.1, `dio_mixin.dart:534-582`).
So rebuilding the list never affects a request that is already in flight.

```dart
// request/request_flags.dart
typedef OnErrorCallback = void Function(DioException dioException, ErrorInterceptorHandler handler);

/// Per-request switches that interceptors read from [RequestOptions.extra].
class RequestFlags {
  const RequestFlags({
    this.skipAuth = false,
    this.showHttpLogging = true,
    this.showCurlLogging = true,
    this.onError,
  });

  static const String extraKey = 'master_utility.request_flags';

  final bool skipAuth;
  final bool showHttpLogging;
  final bool showCurlLogging;
  final OnErrorCallback? onError;

  /// Always present: [DefaultRequestFlagsInterceptor] fills it in for requests sent without flags.
  static RequestFlags of(RequestOptions requestOptions) {
    final dynamic storedFlags = requestOptions.extra[extraKey];
    return storedFlags is RequestFlags ? storedFlags : const RequestFlags();
  }

  Map<String, dynamic> toExtra() => {extraKey: this};
}
```

```dart
// request/api_request.dart: new members only. Constructor and fields are untouched.
class APIRequest {
  // ...existing constructor and mutable fields...

  /// Body per method, exactly as today:
  /// POST prefers bodyList, PATCH/PUT ignore bodyList, DELETE prefers body, GET sends none.
  Object? bodyWith(FormData? formData) {
    switch (methodType) { // cases use the real (uppercase) values so the switch stays exhaustive
      case MethodType.GET:
        return null;
      case MethodType.POST:
        return formData ?? bodyList ?? body;
      case MethodType.PATCH:
      case MethodType.PUT:
        return formData ?? body;
      case MethodType.DELETE:
        return formData ?? body ?? bodyList;
    }
  }

  /// Progress callbacks per method, exactly as today (GET: receive only; DELETE: none).
  bool get _sendsProgress => methodType != MethodType.get && methodType != MethodType.delete;

  ProgressCallback? get sendProgressCallback => _sendsProgress ? onSendProgress : null;
  ProgressCallback? get receiveProgressCallback => methodType == MethodType.delete ? null : onReceiveProgress;

  Options toDioOptions() {
    final RequestFlags requestFlags = RequestFlags(
      skipAuth: !requiresAuth,
      showHttpLogging: showHttpLogging,
      showCurlLogging: showCurlLogging,
      onError: onError,
    );
    return Options(
      method: methodType.name, // enum values are already 'GET', 'POST', ...
      headers: headers,
      extra: requestFlags.toExtra(),
    );
  }
}
```

```dart
// interceptors/default_request_flags_interceptor.dart
/// First in the chain. Requests sent straight through `getDioClient(...)` carry no flags,
/// so they get the flags from the most recent getDioClient call, which is today's behaviour.
class DefaultRequestFlagsInterceptor extends Interceptor {
  DefaultRequestFlagsInterceptor(this._readDefaultFlags);

  final RequestFlags Function() _readDefaultFlags;

  @override
  void onRequest(RequestOptions requestOptions, RequestInterceptorHandler handler) {
    requestOptions.extra.putIfAbsent(RequestFlags.extraKey, _readDefaultFlags);
    handler.next(requestOptions);
  }
}
```

```dart
// interceptors/per_request_error_interceptor.dart
class PerRequestErrorInterceptor extends Interceptor {
  @override
  void onError(DioException dioException, ErrorInterceptorHandler handler) {
    final OnErrorCallback? onErrorCallback = RequestFlags.of(dioException.requestOptions).onError;
    if (onErrorCallback == null) return handler.next(dioException);
    onErrorCallback(dioException, handler);
  }
}
```

```dart
// interceptors/auth_token_interceptor.dart
class AuthTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions requestOptions, RequestInterceptorHandler handler) {
    final bool skipAuth = RequestFlags.of(requestOptions).skipAuth;
    final String accessToken = PreferenceHelper.getStringPrefValue(key: HttpHeaders.authorizationHeader);

    if (!skipAuth && accessToken.isNotEmpty) {
      requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    }
    handler.next(requestOptions);
  }
}
```

```dart
// client/dio_client.dart (shape only; public members identical to today)
class DioClient {
  Dio? _dio;
  Logarte? _logarteClient;
  RefreshTokenConfiguration? _refreshTokenConfiguration;
  JwtHeroInterceptor? _jwtInterceptor;
  RequestFlags _legacyDefaultFlags = const RequestFlags();

  // Public and mutable, as today. Read at call time, so setting them later still works.
  CustomErrorMapper<dynamic>? customErrorMapper;
  void Function(DioException, ErrorInterceptorHandler)? globalOnErrorHandler;

  /// The configured client. Throws a clear error instead of a null-check crash (B8).
  Dio get dio => _dio ?? (throw StateError('Call dioClient.setConfiguration() before making requests.'));

  DioClient setConfiguration(String baseUrl, { /* identical params */ }) {
    // ...identical BaseOptions / kIsWeb setup...
    _rebuildInterceptors(recreateJwtInterceptor: true); // new Dio → new baseUrl for refresh/retry clients
    return this;
  }

  DioClient setRefreshTokenConfiguration({required RefreshTokenConfiguration refreshTokenConfiguration}) {
    _refreshTokenConfiguration = refreshTokenConfiguration;
    if (_dio != null) _rebuildInterceptors(recreateJwtInterceptor: true);
    return this;
  }

  /// Same signature and same instance as before. APIService no longer calls this.
  @Deprecated('Use dioClient.dio, and APIService for per-request options.')
  Dio getDioClient({
    bool isAuth = true,
    bool showHttpLogging = true,
    bool showCurlLogging = true,
    void Function(DioException dioException, ErrorInterceptorHandler errorInterceptorHandler)? callback,
  }) {
    _legacyDefaultFlags = RequestFlags(
      skipAuth: !isAuth,
      showHttpLogging: showHttpLogging,
      showCurlLogging: showCurlLogging,
      onError: callback,
    );
    _rebuildInterceptors(); // as before, so apps that add interceptors to the returned Dio see the same reset
    return dio;
  }

  /// Order is the same as today: Logarte → auth → http log → curl log → per-request error → global error.
  void _rebuildInterceptors({bool recreateJwtInterceptor = false}) {
    if (recreateJwtInterceptor) {
      _jwtInterceptor = _refreshTokenConfiguration == null ? null : _createJwtInterceptor(_refreshTokenConfiguration!);
    }
    dio.interceptors
      ..clear()
      ..addAll([
        DefaultRequestFlagsInterceptor(() => _legacyDefaultFlags),
        if (_logarteClient != null) LogarteDioInterceptor(_logarteClient!),
        _jwtInterceptor ?? AuthTokenInterceptor(),
        HttpFormatter(loggingFilter: _shouldLogHttp),
        CurlLoggerDioInterceptor(printOnSuccess: true, shouldLog: _shouldLogCurl),
        PerRequestErrorInterceptor(),
        InterceptorsWrapper(onError: _onGlobalError),
      ]);
  }

  bool _shouldLogHttp(RequestOptions requestOptions, Response? response, DioException? dioException) =>
      _isApiLogVisible && RequestFlags.of(requestOptions).showHttpLogging;

  bool _shouldLogCurl(RequestOptions requestOptions) =>
      _isApiLogVisible && RequestFlags.of(requestOptions).showCurlLogging;

  void _onGlobalError(DioException dioException, ErrorInterceptorHandler handler) {
    final globalErrorHandler = globalOnErrorHandler;
    if (globalErrorHandler == null) return handler.next(dioException);
    globalErrorHandler(dioException, handler);
  }
}
```
- `CurlLoggerDioInterceptor` gets an **optional** `shouldLog` param. The existing constructor still works.
- `JwtHeroInterceptor.onRequest` / `onError`: return early with `handler.next(...)` when `RequestFlags.of(...).skipAuth`.
  This matches today, where `isAuth: false` meant "no JWT interceptor at all".

---

## 5. Error mapping: one class, same messages

> **Refactor version (item 4):** the class below **without** the D3 guards. For the 422 check, use today's exact
> expression `responseBody['detail']?.isNotEmpty ?? false`, call `ApiErrorModel.fromJson` directly (no `try`), and
> don't add `_hasValidationDetails`. That keeps today's throw for unexpected bodies.
> **Fix commit D3:** add `_hasValidationDetails` and `_tryJoinValidationMessages` exactly as shown.

`ApiExceptionMapper` replaces `api_service.dart:129-198`. The messages it produces are **identical** to today's for every
response that worked before. The only difference is that inputs which used to crash (B4) now return a message.

```dart
// error/api_exception_mapper.dart
class ApiExceptionMapper {
  const ApiExceptionMapper({this.customErrorMapper});

  final CustomErrorMapper<dynamic>? customErrorMapper;

  ApiException map(DioException dioException) {
    final Response<dynamic>? errorResponse = dioException.response;
    final String message = errorResponse == null
        ? ErrorHandler.instance.messageFor(dioException) // reads APIConstError at call time
        : _messageFromResponse(errorResponse);

    return ApiException(
      message: message,
      exception: dioException,
      statusCode: errorResponse?.statusCode,
      stackTrace: dioException.stackTrace,
    );
  }

  String _messageFromResponse(Response<dynamic> errorResponse) {
    if (customErrorMapper != null) {
      return customErrorMapper!(errorResponse).message ?? '';
    }

    final dynamic responseBody = errorResponse.data;
    final String statusMessage = errorResponse.statusMessage ?? ''; // today: `errorModel.message ?? ''`

    if (errorResponse.statusCode == HttpStatus.unprocessableEntity && _hasValidationDetails(responseBody)) {
      final String? validationMessage = _tryJoinValidationMessages(responseBody);
      if (validationMessage != null) return validationMessage;
    }
    if (errorResponse.statusCode == HttpStatus.internalServerError) {
      return statusMessage;
    }
    if (responseBody is Map) {
      // Today: message ?? error ?? statusMessage, and a non-String value falls back to statusMessage.
      final dynamic serverMessage = responseBody['message'] ?? responseBody['error'];
      if (serverMessage is String) return serverMessage;
    }
    return statusMessage;
  }

  bool _hasValidationDetails(dynamic responseBody) =>
      responseBody is Map && responseBody['detail'] is List && (responseBody['detail'] as List).isNotEmpty;

  /// Null when the body doesn't match ApiErrorModel (e.g. missing `loc`). Today that case crashed.
  String? _tryJoinValidationMessages(Map<dynamic, dynamic> responseBody) {
    try {
      final ApiErrorModel validationError = ApiErrorModel.fromJson(Map<String, dynamic>.from(responseBody));
      return joinValidationMessages(validationError.detail);
    } catch (parseError) {
      return null;
    }
  }

  /// Unique messages joined by ", ". Same output as today's `setErrorData`.
  static String joinValidationMessages(List<ErrorDetails>? errorDetails) {
    final Iterable<String> messages = (errorDetails ?? []).map((detail) => detail.msg).whereType<String>();
    return messages.toSet().join(', ');
  }
}
```
`APIService.joinValidationMessages(errorDetails)` is the new name. `setErrorData` stays as a forwarder (§3.3).
`ErrorHandler` stays as it is.

```dart
// service/api_service.dart
class APIService {
  /// `APIService()` keeps working. [client] is only for tests.
  APIService({DioClient? client}) : _client = client ?? dioClient;

  final DioClient _client;

  Future<Either<ApiException, T>> getResponseWithMapper<T>(
    APIRequest request, {
    FormData? formData,

    /// Use this for if response is JsonObject
    final JsonMapper<T>? jsonMapper,

    /// Use this for if response is JsonArray
    final ListJsonMapper<T>? listJsonMapper,
  }) async {
    assert(jsonMapper == null || listJsonMapper == null, 'Can not provide both json mapper!'); // same assert as today
    try {
      final Response<dynamic> response = await _send(request, formData);
      return right(await _mapSuccess<T>(response.data, jsonMapper, listJsonMapper));
    } on DioException catch (dioException) {
      final ApiExceptionMapper exceptionMapper = ApiExceptionMapper(customErrorMapper: _client.customErrorMapper);
      return left(exceptionMapper.map(dioException));
    } catch (error, stackTrace) {
      return left(ApiException(message: APIConstError.somethingWentWrong, exception: error, stackTrace: stackTrace));
    }
  }

  String joinValidationMessages(List<ErrorDetails>? errorDetails) => ApiExceptionMapper.joinValidationMessages(errorDetails);

  @Deprecated('Use joinValidationMessages instead.')
  String setErrorData(List<ErrorDetails>? errorDetails) => joinValidationMessages(errorDetails);

  Future<Response<dynamic>> _send(APIRequest request, FormData? formData) {
    return _client.dio.request<dynamic>(
      request.url,
      data: request.bodyWith(formData),
      queryParameters: request.queryParams,
      cancelToken: request.cancelToken,
      onSendProgress: request.sendProgressCallback,
      onReceiveProgress: request.receiveProgressCallback,
      options: request.toDioOptions(),
    );
  }

  /// Same branches as today. A wrong `T` still ends up as `left(somethingWentWrong)`, as before.
  Future<T> _mapSuccess<T>(dynamic responseBody, JsonMapper<T>? jsonMapper, ListJsonMapper<T>? listJsonMapper) async {
    if (responseBody is Map<String, dynamic> && jsonMapper != null) return compute(jsonMapper, responseBody);
    if (responseBody is List<dynamic> && listJsonMapper != null) return compute(listJsonMapper, responseBody);
    return responseBody as T;
  }
}
```

---

## 6. JWT interceptor cleanup

> The dead-branch removal and the typo fix are part of the refactor. The `RequestRetryMixin` change is fix commit D7.
> The logger guard is part of fix commit D4.

- Delete the dead branch (S6). `onError` becomes: skip-auth? `next` → not 401? `next` → no token? `reject` → refresh → retry.
- `Refresh` typedef: rename param `refreshToke` → `refreshToken`. Parameter names in a function type aren't part of the API.
- `RequestRetryMixin.retry`: same signature, build headers as `{...requestOptions.headers, ...await buildHeaders()}` (B7).
- `_attachHttpLoggers` → `_attachDebugLoggers`, which returns early in `kReleaseMode` (B3).

---

## 7. Fix commits D4, D5, D6 (not part of the refactor)

- `static bool _isApiLogVisible = !kReleaseMode;`. `setIsApiLogVisible` keeps exactly the same rule (forced off in release).
- `CurlLoggerDioInterceptor`: prints `Authorization` and `Cookie` header values as `***`.
- `AuthTokenInterceptor`: sets the header only when the token is non-empty.

---

## 8. Rollout: small PRs, each green and shippable

Every PR has the same gate: **the `example/` app compiles with zero edits, `flutter analyze` shows no new warnings,
and the compatibility tests pass.**

**Refactor PRs (no behaviour change):**

| Phase | PR | Change | Risk |
|---|---|---|---|
| 0 | Safety net | Add `test/api_service_test.dart` (below) **against today's code**, recording today's behaviour, bugs included. Bug tests (D1, D3, …) are added with `skip: 'Fixed in commit Dn'`. | none |
| 1 | Move files | Drop `part` files. Move to §2 layout, delete old files, update `master_utility.dart` exports. Rename locals (§3.2). Delete the dead JWT branch. | low |
| 1b | Proper names | Add the new public names. Old names become `@Deprecated` forwarders (§3.3). Add `dio` getter, `fix_data.yaml` and `test_fixes/` (§3.4). Switch README and example to the new names. | low |
| 2 | Error mapper | `ApiExceptionMapper`, refactor version (§5 note). `bodyWith()` / `toDioOptions()` for the method switch. | low |
| 3 | Release refactor | CHANGELOG: new names, their deprecated old names, and "run `dart fix --apply` to migrate". | none |

**Bug-fix commits (after the refactor, one per bug).** Each one removes the `skip:` from its own test and adds one
CHANGELOG line:

| Commit | Fixes | Change | Risk |
|---|---|---|---|
| Fix 1 | D1 + D2 + D8 | §4: interceptors built once, `RequestFlags`, `getDioClient` deprecated | **medium**: test login and refresh in the example app by hand |
| Fix 2 | D3 | §5 guards | low |
| Fix 3 | D4 | §6 / §7 logging off in release | low |
| Fix 4 | D5 | §7 mask headers in curl log | low |
| Fix 5 | D6 | §7 no empty Bearer header | low |
| Fix 6 | D7 | §6 retry doesn't change the original headers | low |
| Fix 7 | D9 | `RequestRetryMixin<dynamic>` so the retried response reaches the app | low, **high value**: today every 401 refresh shows the user an error, and a POST may get submitted twice when the user retries |

Ship the fixes as patch releases (`1.0.1`, `1.0.2`, …) or batch them. Either way, if something goes wrong, `git revert`
on a single commit undoes exactly one fix.

**Version: release this as `1.0.0`.** It's non-breaking, so any version number is allowed. Today every `0.0.x` release
forces users to run `--major-versions`. After `1.0.0`, `^1.0.0` accepts every `1.x.y`, so later fixes arrive with plain
`flutter pub upgrade`.

### Compatibility tests (Phase 0, one file)
Written **before** the refactor, so they record today's behaviour. The file starts with
`// ignore_for_file: deprecated_member_use_from_same_package`, because it deliberately uses the old names.

| Test | Expects |
|---|---|
| GET with `jsonMapper` / POST with `listJsonMapper` / no mapper | `right(mapped)` / `right(rawBody)` |
| POST with both `params` and `paramList` (old names) | body == `paramList` (and PUT/PATCH → `params`, DELETE → `params`) |
| Same requests written with `body` / `bodyList` / `headers` / `requiresAuth` | identical request on the wire |
| `request.params = x`, then read `request.body` (and the other way round) | same value |
| `MethodType.get == MethodType.GET`, `MethodType.get.name == 'GET'` | true |
| 422 with FastAPI `detail` (duplicate msgs) | message == unique msgs joined by `", "` |
| 422 / 400 with `{"message": "x"}`, `{"error": "y"}`, `{"message": 123}` | `"x"`, `"y"`, statusMessage |
| 500 | message == statusMessage |
| connection timeout / cancel | `APIConstError.kTimeOut` / `kCancelled` |
| App reassigns `APIConstError.kTimeOut = 'custom'` | message == `'custom'`, and `APIConstError.connectionTimeout == 'custom'` |
| `ErrorHandler.instance.getDioError(dioException) == messageFor(dioException)`, `setErrorData(errorDetails) == joinValidationMessages(errorDetails)` | true |
| `customErrorMapper` set **after** `setConfiguration` | its message is used |
| `globalOnErrorHandler` set **after** `setConfiguration` | it's called |
| `APIRequest(onError: callback)` | callback called, global handler also called if callback calls `handler.next` |
| `dioClient.getDioClient(isAuth: false).get(...)` | no `Authorization` header |
| `isAuthorization: false` with JWT config | no `Authorization` header, no refresh |
| 401 → refresh once → retry | one refresh call, retried request succeeds |
| 2 parallel 401s | **1** refresh call (`skip:` until Fix 1) |
| 422 with string body | `left(...)`, no throw (`skip:` until Fix 2) |
| Test file imports **only** `package:master_utility/master_utility.dart` and references every name in §0.2 | compiles (proves the barrel still exports everything) |

Fake adapter (no mocking library needed):
```dart
/// Answers every request with [respond] and counts calls, without touching the network.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.respond);

  final ResponseBody Function(RequestOptions requestOptions) respond;
  int requestCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions requestOptions,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    return respond(requestOptions);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(String jsonBody, int statusCode) => ResponseBody.fromString(
      jsonBody,
      statusCode,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );

// Usage:
// dioClient.setConfiguration('https://example.test');
// final fakeAdapter = FakeHttpAdapter((requestOptions) => jsonResponse('{"id": 1}', 200));
// dioClient.dio.httpClientAdapter = fakeAdapter;
```

---

## 9. Not doing (each would break apps)

- Removing any old name, `getDioClient` or `APIRequest.file`. They stay `@Deprecated` and keep working.
- Renaming classes (`APIService` → `ApiService`, …). This clashes with apps' own classes of the same name.
- Replacing `dartz` / `Either` with a `sealed` `Result`. Every call site would change, and it needs Dart 3.
- Replacing the global `dioClient` with an injected `ApiClient`. App setup code would change.
- Changing the `CustomErrorMapper` signature or making `APIConstError` immutable.
- Repository / use case / entity layers. They belong in the apps, not this package.
