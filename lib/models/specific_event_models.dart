import 'event_model.dart';

class SectionLoadEvent extends EventModel {
  String pageName;

  SectionLoadEvent({
    required super.sessionId,
    required super.eventTimestamp,
    required this.pageName,
  }) : super(
          eventType: 'SectionLoad',
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp.toIso8601String(),
      'eventDetails': {'PageName': pageName},
    };
  }
}

class ExternalLinkEvent extends EventModel {
  String linkDestination;
  String linkLabel;

  ExternalLinkEvent({
    required super.sessionId,
    required super.eventTimestamp,
    required this.linkDestination,
    required this.linkLabel,
  }) : super(
          eventType: 'ExternalLink',
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp.toIso8601String(),
      'eventDetails': {
        'LinkDestination': linkDestination,
        'LinkLabel': linkLabel
      },
    };
  }
}

// Modelo para evento de tiempo de reproducción con volumen
class PlaybackWithVolumeEvent extends EventModel {
  int playbackTime;
  String muteStatus;

  PlaybackWithVolumeEvent({
    required super.sessionId,
    required super.eventTimestamp,
    required this.playbackTime,
    required this.muteStatus,
  }) : super(
          eventType: 'PlaybackWithVolume',
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp.toIso8601String(),
      'eventDetails': {'PlaybackTime': playbackTime, 'MuteStatus': muteStatus},
    };
  }
}

// Modelo para evento de tiempo de visita
class VisitDurationEvent extends EventModel {
  int duration;

  VisitDurationEvent({
    required super.sessionId,
    required super.eventTimestamp,
    required this.duration,
  }) : super(
          eventType: 'VisitDuration',
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp.toIso8601String(),
      'eventDetails': {'Duration': duration},
    };
  }
}

// Activity Status
class ActivityStatusEvent extends EventModel {
  String status;

  ActivityStatusEvent({
    required super.sessionId,
    required super.eventTimestamp,
    required this.status,
  }) : super(
          eventType: 'ActivityStatus',
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp.toIso8601String(),
      'eventDetails': {'Status': status},
    };
  }
}

// Modelo para evento de zoom en imagen
class ImageZoomEvent extends EventModel {
  String imageId;

  ImageZoomEvent({
    required super.sessionId,
    required super.eventTimestamp,
    required this.imageId,
  }) : super(
          eventType: 'ImageZoom',
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp.toIso8601String(),
      'eventDetails': {'ImageId': imageId},
    };
  }
}

// Modelo para evento de clic en preguntas frecuentes
class FAQClickEvent extends EventModel {
  String faqId;

  FAQClickEvent({
    required super.sessionId,
    required super.eventTimestamp,
    required this.faqId,
  }) : super(
          eventType: 'FAQClick',
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp.toIso8601String(),
      'eventDetails': {'FAQId': faqId},
    };
  }
}
