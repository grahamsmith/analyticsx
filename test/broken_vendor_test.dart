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
    ax.uninit();
  });

  test('Broken vendor does not stop other vendors from initing', () async {
    final brokenVendor = BrokenFakeVendor(initWillThrow: true);
    await ax.init([brokenVendor, fakeVendor]).catchError((_) => {/*nothing*/});

    expect(fakeVendor.initWasCalledXTimes, 1);
  });

  test('Broken vendor that fails to init never runs actions', () async {
    final brokenVendor = BrokenFakeVendor(initWillThrow: true);
    await ax.init([brokenVendor, fakeVendor]).catchError((_) => {/*nothing*/});
    await ax.invokeAction(FakeAction("potato"));
    await ax.invokeAction(FakeAction("potato"), [brokenVendor.id]);
    expect(brokenVendor.handleActionWasCalledXTimes, 0);
  });

  test('Broken vendor does not stop other vendors from performing actions', () async {
    final brokenVendor = BrokenFakeVendor(handleActionWillThrow: true);
    await ax.init([brokenVendor, fakeVendor]);
    await ax.invokeAction(FakeAction("potato")).catchError((_) => {/*nothing*/});
    expect(fakeVendor.handleActionWasCalledXTimes, 1);
  });
}
