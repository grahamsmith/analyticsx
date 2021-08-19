import 'package:analyticsx/actions/set_screen.dart';
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
      await analytics.setCurrentScreen(screenName: action.screenName);
    }
  }
}
