import 'package:analyticsx/src/analytics_action.dart';

/// The most common event for analytics vendors - tracking an arbitrary event that the app developer cares about
class TrackEvent extends AnalyticsAction {
  /// A likely unique name to identify this event in the context of the application, e.g. "login_tap"
  final String eventName;

  /// Any parameters required or desired to accompany the event, e.g. user's analytics ID, device info, session ID
  final Map<String, dynamic> parameters;

  TrackEvent(this.eventName, this.parameters);
}
