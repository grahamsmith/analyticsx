import 'package:analyticsx/actions/track_event.dart';
import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';
import 'package:example/MyExampleAnalytics/simple_counter_event.dart';

class ExampleAnalyticsVendor extends AnalyticsVendor {
  static ExampleAnalyticsVendor analytics = ExampleAnalyticsVendor();

  ExampleAnalyticsVendor() : super('ExampleAnalytics');

  @override
  void init() {
    print('ExampleAnalytics has run init()');
  }

  @override
  void handleAction(AnalyticsAction action) {
    if (action is TrackEvent) {
      print('TrackEvent: ${action.eventName} with ${action.parameters}');
    }

    if (action is SimpleCounterEvent) {
      print('CountEvent: ${action.counterName} has count ${action.count}');
    }
  }
}
