import 'package:analyticsx/src/analytics_action.dart';

/// Represents the common "user viewed this screen" analytics event
class SetScreen extends AnalyticsAction {
  /// Unique name of the screen (where uniqueness isn't mandated for anything but the sanity of the consumer of
  /// analytics data)
  final String screenName;

  final String screenClassOverride;

  SetScreen(this.screenName, this.screenClassOverride);
}
