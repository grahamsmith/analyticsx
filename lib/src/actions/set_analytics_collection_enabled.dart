import 'package:analyticsx/src/analytics_action.dart';

/// Represents an action to disable/enable analytics collection
///
/// This might be useful for a screen recording analytics provider that a developer doesn't want PII leaked to
class SetAnalyticsCollectionEnabled extends AnalyticsAction {
  final bool enabled;

  SetAnalyticsCollectionEnabled({required this.enabled});
}
