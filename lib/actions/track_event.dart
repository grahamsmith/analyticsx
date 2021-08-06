import 'package:analyticsx/analytics_action.dart';

class TrackEvent extends AnalyticsAction {
  final String eventName;
  final Map<String, String> parameters;

  TrackEvent(this.eventName, this.parameters);
}
