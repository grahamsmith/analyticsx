import 'package:analyticsx/src/analytics_action.dart';

/// Abstract class to represent analytics providers (e.g. Firebase), which all implementations must extend.
///
/// Any implementation must provide a unique ID string by which it can be identified, but no format is enforced, and
/// this can be as simple as "MegaCorpAnalytics".
abstract class AnalyticsVendor {
  /// Unique ID of this vendor. Used by the application developer in [AnalyticsX.invokeAction] to explicitly emit an
  /// action to one or more specific vendors, rather than all registered vendors.
  final String id;

  AnalyticsVendor(this.id);

  /// Called by [AnalyticsX.init] when the vendor is registered.
  ///
  /// Implementations requiring intialisation (e.g. configuration, authentication) might choose to do that here.
  Future<void> init();

  /// Called by [AnalyticsX.invokeAction]. Gives the vendor implementation the option to handle an analytics event
  /// (a.k.a. [AnalyticsAction].
  ///
  /// This method will only receive instances of concrete subclasses of [AnalyticsAction], and so should be implemented
  /// such that they can differentiate if required. See Firebase in the example directory of the source for prior art.
  Future<void> handleAction(AnalyticsAction action);
}
