import 'package:analyticsx/analytics_x.dart';

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

class FakeVendorWithSameID extends FakeVendor {}

class BrokenFakeVendor extends FakeVendor {
  bool initWillThrow = true;
  bool handleActionWillThrow = false;

  BrokenFakeVendor({this.initWillThrow = false, this.handleActionWillThrow = false}) : super.withVendorId('Broken');

  @override
  Future<void> init() async {
    if (initWillThrow) {
      throw Exception('BrokenAnalytics threw during init()');
    }
    return super.init();
  }

  @override
  Future<void> handleAction(AnalyticsAction action) async {
    if (handleActionWillThrow) {
      throw Exception('BrokenAnalytics threw during handleAction()');
    }
    return super.handleAction(action);
  }
}
