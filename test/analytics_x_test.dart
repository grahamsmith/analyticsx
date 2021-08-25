import 'package:analyticsx/analytics_x.dart';
import 'package:test/test.dart';

import 'util/vendors_and_actions.dart';

void main() {
  late FakeVendor fakeVendor;
  late AnalyticsX ax;

  setUp(() {
    fakeVendor = FakeVendor();
    ax = AnalyticsX();
  });

  tearDown(() {
    ax.reset();
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

  test('AnalyticsX only registers one of each class of AnalyticsVendor when initialised together', () async {
    final anotherFakeVendor = FakeVendor();
    await ax.init([fakeVendor, anotherFakeVendor]);
    expect(AnalyticsX().allRegisteredVendors.length, 1);
  });

  test('AnalyticsX only registers one of each class of AnalyticsVendor when initialised separately', () async {
    final anotherFakeVendor = FakeVendor();
    await ax.init([fakeVendor]);
    await ax.init([anotherFakeVendor]);
    expect(AnalyticsX().allRegisteredVendors.length, 1);
  });

  test('AnalyticsX only registers one AnalyticsVendor when two implementations are given the same ID', () async {
    final anotherFakeVendor = FakeVendorWithSameID();
    await ax.init([fakeVendor, anotherFakeVendor]);
    expect(AnalyticsX().allRegisteredVendors.length, 1);
  });
}
