import 'package:analyticsx/actions/set_analytics_collection_enabled.dart';
import 'package:analyticsx/actions/set_screen.dart';
import 'package:analyticsx/actions/set_user_id.dart';
import 'package:analyticsx/actions/set_user_property.dart';
import 'package:analyticsx/actions/track_event.dart';
import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Firebase extends AnalyticsVendor {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  Firebase() : super('Firebase');

  @override
  Future<void> init() async {
    //nothing for Firebase;
  }

  @override
  Future<void> handleAction(AnalyticsAction action) async {
    if (action is TrackEvent) {
      await analytics.logEvent(name: action.eventName, parameters: action.parameters);
    }

    if (action is SetScreen) {
      await analytics.setCurrentScreen(
        screenName: action.screenName,
        screenClassOverride: action.screenClassOverride,
      );
    }

    if (action is SetUserId) {
      await analytics.setUserId(action.userId);
    }

    if (action is SetUserProperty) {
      await analytics.setUserProperty(name: action.propertyName, value: action.propertyValue);
    }

    if (action is SetAnalyticsCollectionEnabled) {
      await analytics.setAnalyticsCollectionEnabled(action.enabled);
    }
  }
}
