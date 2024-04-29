abstract class EventModel {
  String sessionId;
  String eventType;
  DateTime eventTimestamp;

  EventModel({
    required this.sessionId,
    required this.eventType,
    required this.eventTimestamp,
  });

  Map<String, dynamic> toJson();
}
