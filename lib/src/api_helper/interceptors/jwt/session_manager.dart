import 'dart:async';

/// The session status enum.
enum SessionStatus {
  /// The session is active.
  active,

  /// The session is expired
  expired,
}

/// Manages the session status of the user.
class SessionManager {
  /// The stream controller to manage the session status.
  final _sessionController = StreamController<SessionStatus>.broadcast()
    ..add(SessionStatus.active);

  /// The stream to listen to the session status.
  Stream<SessionStatus> get sessionStatus => _sessionController.stream;

  /// Call after a successful login or register.
  void startSession() => _sessionController.add(SessionStatus.active);

  /// Call after logout.
  void expireSession() => _sessionController.add(SessionStatus.expired);
}
