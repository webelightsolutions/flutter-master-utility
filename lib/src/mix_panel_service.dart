import 'package:master_utility/src/log/log.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelService {
  MixPanelService._();
  static final MixPanelService instance = MixPanelService._();

  static late Mixpanel _mixPanelInstance;
  static String? userId;
  static String? userName;

  Future<void> init({required String mixPanelToken}) async {
    try {
      _mixPanelInstance = await Mixpanel.init(mixPanelToken, trackAutomaticEvents: true);
      _mixPanelInstance.setLoggingEnabled(true);
    } catch (e) {
      LogHelper.logError(e, stackTrace: StackTrace.current);
    }
  }

  void setUserIdentity({
    required String userId,
    required String userName,
    Map<String, dynamic>? properties,
  }) {
    try {
      _mixPanelInstance.identify(userId);
      final people = _mixPanelInstance.getPeople();

      people.set('name', userName);

      properties?.forEach((key, value) {
        people.set(key, value);
      });
    } catch (e) {
      LogHelper.logError('Failed to identify: $userId', stackTrace: StackTrace.current);
    }
  }

  void trackEvent({required String eventName, Map<String, dynamic>? data}) {
    try {
      _mixPanelInstance.track(
        eventName,
        properties: {
          if (userId != null && userId!.isNotEmpty) 'userId': userId,
          if (userName != null && userName!.isNotEmpty) 'userName': userName,
          ...data ?? {},
        },
      );
    } catch (e) {
      LogHelper.logError('Failed to track event: $eventName', stackTrace: StackTrace.current);
    }
  }
}
