import 'package:analyticsx/analytics_action.dart';

class SetScreen extends AnalyticsAction {
  final String screenName;
  final String screenClassOverride;

  SetScreen(this.screenName, this.screenClassOverride);
}
