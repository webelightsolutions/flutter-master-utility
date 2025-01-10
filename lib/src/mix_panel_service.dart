import 'package:master_utility/src/log/log.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelService {
  MixPanelService._();
  static final MixPanelService instance = MixPanelService._();

  static late Mixpanel _mixPanelInstance;
  static String? userId;
  static String? userName;

  static Future<void> init({required String mixPanelToken}) async {
    try {
      _mixPanelInstance = await Mixpanel.init(mixPanelToken, trackAutomaticEvents: true);
      _mixPanelInstance.setLoggingEnabled(true);
    } catch (e) {
      LogHelper.logError(e, stackTrace: StackTrace.current);
    }
  }

  static void setUserIdentity({required String userId, required String userName}) {
    try {
      userId = userId;
      userName = userName;
      _mixPanelInstance
        ..identify(userId)
        ..getPeople().set('name', userName);
    } catch (e) {
      LogHelper.logError('Failed to identify: $userId', stackTrace: StackTrace.current);
    }
  }

  static void trackEvent({required String eventName, Map<String, dynamic>? data}) {
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
