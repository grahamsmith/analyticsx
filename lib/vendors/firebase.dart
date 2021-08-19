import 'package:analyticsx/actions/set_screen.dart';
import 'package:analyticsx/actions/track_event.dart';
import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Firebase extends AnalyticsVendor {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  Firebase() : super('Firebase');

  @override
  void init() {
    //nothing for Firebase;
  }

  @override
  void handleAction(AnalyticsAction action) {
    if (action is TrackEvent) {
      analytics.logEvent(name: action.eventName, parameters: action.parameters);
    }

    if (action is SetScreen) {
      analytics.setCurrentScreen(screenName: action.screenName);
    }
  }
}
