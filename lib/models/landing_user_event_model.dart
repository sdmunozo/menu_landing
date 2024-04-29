import 'package:landing_v3/provider/global_config_provider.dart';

class LandingUserEventModel {
  String? userId;
  String? sessionId;
  String? eventType;
  DateTime? eventTimestamp;
  EventDetails? details;

  LandingUserEventModel({
    this.userId,
    this.sessionId,
    this.eventType,
    this.eventTimestamp,
    this.details,
  });

  LandingUserEventModel.build(EventBuilder builder) {
    userId = GlobalConfigProvider.sessionId;
    sessionId = GlobalConfigProvider.sessionId;
    eventType = builder.eventType;
    eventTimestamp = DateTime.now();
    details = builder.details;
  }

  factory LandingUserEventModel.fromJson(Map<String, dynamic> json) {
    return LandingUserEventModel(
      userId: json['userId'],
      sessionId: json['sessionId'],
      eventType: json['eventType'],
      eventTimestamp: DateTime.parse(json['eventTimestamp']),
      details: EventDetails.fromJson(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp?.toIso8601String(),
      'details': details?.toJson(),
    };
  }
}

class EventBuilder {
  String? eventType;
  EventDetails? details;

  EventBuilder({
    required this.eventType,
    required this.details,
  });

  LandingUserEventModel build() {
    return LandingUserEventModel.build(this);
  }
}

class EventDetails {
  int? presentationViewSecondsElapsed;
  int? menuHighlightsViewSecondsElapsed;
  int? menuScreensViewSecondsElapsed;
  int? forWhoViewSecondsElapsed;
  int? whyUsViewSecondsElapsed;
  int? suscriptionsViewSecondsElapsed;
  int? testimonialsViewSecondsElapsed;
  int? faqViewSecondsElapsed;
  int? trustElementsViewSecondsElapsed;
  String? linkDestination;
  String? linkLabel;
  int? playbackTime;
  int? duration;
  String? imageId;
  String? faqId;
  String? status;

  EventDetails({
    this.presentationViewSecondsElapsed,
    this.menuHighlightsViewSecondsElapsed,
    this.menuScreensViewSecondsElapsed,
    this.forWhoViewSecondsElapsed,
    this.whyUsViewSecondsElapsed,
    this.suscriptionsViewSecondsElapsed,
    this.testimonialsViewSecondsElapsed,
    this.faqViewSecondsElapsed,
    this.trustElementsViewSecondsElapsed,
    this.linkDestination,
    this.linkLabel,
    this.playbackTime,
    this.duration,
    this.imageId,
    this.faqId,
    this.status,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      presentationViewSecondsElapsed: json['presentationViewSecondsElapsed'],
      menuHighlightsViewSecondsElapsed:
          json['menuHighlightsViewSecondsElapsed'],
      menuScreensViewSecondsElapsed: json['menuScreensViewSecondsElapsed'],
      forWhoViewSecondsElapsed: json['forWhoViewSecondsElapsed'],
      whyUsViewSecondsElapsed: json['whyUsViewSecondsElapsed'],
      suscriptionsViewSecondsElapsed: json['suscriptionsViewSecondsElapsed'],
      testimonialsViewSecondsElapsed: json['testimonialsViewSecondsElapsed'],
      faqViewSecondsElapsed: json['faqViewSecondsElapsed'],
      trustElementsViewSecondsElapsed: json['trustElementsViewSecondsElapsed'],
      linkDestination: json['linkDestination'],
      linkLabel: json['linkLabel'],
      playbackTime: json['playbackTime'],
      duration: json['duration'],
      imageId: json['imageId'],
      faqId: json['faqId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'presentationViewSecondsElapsed': presentationViewSecondsElapsed,
      'menuHighlightsViewSecondsElapsed': menuHighlightsViewSecondsElapsed,
      'menuScreensViewSecondsElapsed': menuScreensViewSecondsElapsed,
      'forWhoViewSecondsElapsed': forWhoViewSecondsElapsed,
      'whyUsViewSecondsElapsed': whyUsViewSecondsElapsed,
      'suscriptionsViewSecondsElapsed': suscriptionsViewSecondsElapsed,
      'testimonialsViewSecondsElapsed': testimonialsViewSecondsElapsed,
      'faqViewSecondsElapsed': faqViewSecondsElapsed,
      'trustElementsViewSecondsElapsed': trustElementsViewSecondsElapsed,
      'linkDestination': linkDestination,
      'linkLabel': linkLabel,
      'playbackTime': playbackTime,
      'duration': duration,
      'imageId': imageId,
      'faqId': faqId,
      'status': status,
    };
  }
}
