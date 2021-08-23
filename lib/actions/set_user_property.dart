import 'package:analyticsx/analytics_action.dart';

class SetUserProperty extends AnalyticsAction {
  final String propertyName;
  final String propertyValue;

  SetUserProperty(this.propertyName, this.propertyValue);
}
