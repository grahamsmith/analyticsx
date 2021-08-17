import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';
import 'package:analyticsx/analytics_x.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeVendor extends AnalyticsVendor {
  FakeVendor() : super('Dummy');

  int initWasCalledXTimes = 0;

  @override
  void handleAction(AnalyticsAction action) {
    // TODO: implement handleAction
  }

  @override
  void init() {
    initWasCalledXTimes++;
  }
}

void main() {
  late FakeVendor fakeVendor;
  late AnalyticsX ax;

  setUp(() {
    fakeVendor = FakeVendor();
  });

  test('Init is called', () {
    ax = AnalyticsX()..init([fakeVendor]);
    assert(fakeVendor.initWasCalledXTimes == 1);
  });
}
