//Example analytics event that represents a simple counter
//This event is supported by ExampleAnalyticsVendor

import 'package:analyticsx/analytics_action.dart';

class SimpleCounterEvent extends AnalyticsAction {
  final String counterName;
  final int count;

  SimpleCounterEvent(this.counterName, this.count);
}
