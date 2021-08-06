import 'package:analyticsx/analytics_action.dart';

abstract class AnalyticsVendor {
  final String id;

  final List<Type> supportedActions;

  AnalyticsVendor(this.id, this.supportedActions);

  void init();
  void handleAction(AnalyticsAction action);
}
