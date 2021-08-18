import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';
import 'package:analyticsx/analytics_x.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAction extends AnalyticsAction {
  final String fakeProperty;
  FakeAction(this.fakeProperty);
}

class FakeVendor extends AnalyticsVendor {
  FakeVendor() : super('Dummy');

  int initWasCalledXTimes = 0;
  int handleActionWasCalledXTimes = 0;
  List<String> handleActionWasCalledWith = [];

  @override
  void handleAction(AnalyticsAction action) {
    handleActionWasCalledXTimes++;
    if (action is FakeAction) {
      handleActionWasCalledWith.add(action.fakeProperty);
    }
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

  test('Vendor handleAction is called once when invokeAction is called once', () {
    ax.init([fakeVendor]);
    ax.invokeAction(FakeAction("potato"));
    expect(fakeVendor.handleActionWasCalledXTimes, 1);
  });
}
