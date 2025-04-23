import 'dart:async';

/// The session status enum.
enum SessionStatus {
  /// The session is active.
  active,

  /// The session is expired
  expired,
}

/// {@template session_manager}
/// Manages the session status of the user.
///
/// The `SessionExpirationManager` class is responsible for managing the session
/// status of the user. It uses a stream to broadcast session status changes,
/// allowing other parts of the application to listen for and react
/// to these changes.
/// {@endtemplate}
class SessionManager {
  /// The stream controller to manage the session status.
  final _sessionController = StreamController<SessionStatus>.broadcast()..add(SessionStatus.active);

  /// The stream to listen to the session status.
  Stream<SessionStatus> get sessionStatus => _sessionController.stream;

  /// should be called after login or register events
  /// if user successfully logged in or registered
  void startSession() => _sessionController.add(SessionStatus.active);

  /// should be called after logout events
  void expireSession() => _sessionController.add(SessionStatus.expired);
}
