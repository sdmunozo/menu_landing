class SessionModel {
  String sessionId;

  SessionModel({required this.sessionId});

  factory SessionModel.fromLocalStorage(String storedSessionId) {
    return SessionModel(sessionId: storedSessionId);
  }
}
