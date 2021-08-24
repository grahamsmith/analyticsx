/// Analytics manager through which multiple vendors are registered and events are triggered
///
/// Early in the application lifecycle, vendors are registered with AnalyticsX by passing a list of [AnalyticsVendor]
/// instances to [AnalyticsX.init], which in turn calls the init method on each [AnalyticsVendor]. The top-level init
/// method can be called multiple times, and whilst the resultant list of vendors is cumulative, the init of each
/// [AnalyticsVendor] will only be called once.
///
/// Once registered, each call to [AnalyticsX.invokeAction] is fanned out to all vendors with the accompanying
/// [AnalyticsAction], and each [AnalyticsVendor] implementation decides how (or if) to act upon it.
export 'src/actions/set_analytics_collection_enabled.dart';
export 'src/actions/set_screen.dart';
export 'src/actions/set_user_id.dart';
export 'src/actions/set_user_property.dart';
export 'src/actions/track_event.dart';
export 'src/analytics_action.dart';
export 'src/analytics_vendor.dart';
export 'src/analytics_x.dart';
