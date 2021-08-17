import 'package:analyticsx/analytics_action.dart';

abstract class AnalyticsVendor {
  final String id;

  AnalyticsVendor(this.id);

  void init();
  void handleAction(AnalyticsAction action);
}
