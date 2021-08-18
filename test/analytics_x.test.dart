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
    ax = AnalyticsX();
  });

  test('AnalyticsX is (probably) a singleton', () {
    // Whilst identical(..) proves that both variables reference the same object, you can't definitively prove that it's
    // a singleton this way, since two identical strings are optimised to use the same reference
    final ax2 = AnalyticsX();
    expect(identical(ax, ax2), true);
  });

  test('Vendor init is called once when Analytics init is called once', () {
    ax.init([fakeVendor]);
    expect(fakeVendor.initWasCalledXTimes, 1);
  });

  test('Analytics init throws exception when called twice', () {
    ax.init([fakeVendor]);
    expect(() => ax.init([fakeVendor]), throwsException);
  });

  test('Init is called', () {
    ax = AnalyticsX()..init([fakeVendor]);
    assert(fakeVendor.initWasCalledXTimes == 1);
  });
}
