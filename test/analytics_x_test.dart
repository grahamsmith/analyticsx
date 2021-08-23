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
  FakeVendor.withVendorId(String vendorId) : super(vendorId);

  int initWasCalledXTimes = 0;
  int handleActionWasCalledXTimes = 0;
  List<String> handleActionWasCalledWith = [];

  @override
  Future<void> handleAction(AnalyticsAction action) async {
    handleActionWasCalledXTimes++;
    if (action is FakeAction) {
      handleActionWasCalledWith.add(action.fakeProperty);
    }
  }

  @override
  Future<void> init() async {
    initWasCalledXTimes++;
  }
}

class FakeVendor2 extends FakeVendor {
  FakeVendor2() : super.withVendorId('Dummy2');
}

void main() {
  late FakeVendor fakeVendor;
  late AnalyticsX ax;

  setUp(() {
    fakeVendor = FakeVendor();
    ax = AnalyticsX();
  });

  tearDown(() {
    ax.uninit();
  });

  test('AnalyticsX is (probably) a singleton', () async {
    // Whilst identical(..) proves that both variables reference the same object, you can't definitively prove that it's
    // a singleton this way, since two identical strings are optimised to use the same reference
    final ax2 = AnalyticsX();
    expect(identical(ax, ax2), true);
  });

  test('Vendor init is called once when Analytics init is called once', () async {
    await ax.init([fakeVendor]);
    expect(fakeVendor.initWasCalledXTimes, 1);
  });

  test('Vendor init is called once when Analytics init is called twice', () async {
    await ax.init([fakeVendor]);
    await ax.init([fakeVendor]);
    expect(fakeVendor.initWasCalledXTimes, 1);
  });

  test('First vendor init is not called again when Analytics init is called with second vendor', () async {
    await ax.init([fakeVendor]);
    final fakeVendor2 = FakeVendor2();
    await ax.init([fakeVendor2]);
    expect(fakeVendor.initWasCalledXTimes, 1);
  });

  test('Second vendor init is called when Analytics init is called with second vendor', () async {
    await ax.init([fakeVendor]);
    final fakeVendor2 = FakeVendor2();
    await ax.init([fakeVendor2]);
    expect(fakeVendor2.initWasCalledXTimes, 1);
  });

  test('Vendor handleAction is called once when invokeAction is called once', () async {
    await ax.init([fakeVendor]);
    await ax.invokeAction(FakeAction("potato"));
    expect(fakeVendor.handleActionWasCalledXTimes, 1);
  });

  test('Correct vendor handleActions are called when invokeAction is called with vendorIds', () async {
    final fakeVendor2 = FakeVendor2();
    await ax.init([fakeVendor, fakeVendor2]);
    await ax.invokeAction(FakeAction("potato"), [fakeVendor2.id]);
    expect(fakeVendor.handleActionWasCalledXTimes, 0);
    expect(fakeVendor2.handleActionWasCalledXTimes, 1);
  });

  test('Vendor handleAction is not called when invokeAction is called with non-existent vendorId', () async {
    await ax.init([fakeVendor]);
    await ax.invokeAction(FakeAction("potato"), ['NonExistentVendorId']);
    expect(fakeVendor.handleActionWasCalledXTimes, 0);
  });
}
