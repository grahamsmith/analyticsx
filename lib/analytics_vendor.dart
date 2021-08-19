import 'package:analyticsx/analytics_action.dart';

abstract class AnalyticsVendor {
  final String id;

  AnalyticsVendor(this.id);

  Future<void> init();
  Future<void> handleAction(AnalyticsAction action);
}
