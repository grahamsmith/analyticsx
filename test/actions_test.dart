import 'package:analyticsx/analytics_x.dart';
import 'package:test/test.dart';

import 'util/vendors_and_actions.dart';

void main() {
  late AnalyticsX ax;

  setUp(() {
    ax = AnalyticsX();
  });

  tearDown(() {
    ax.reset();
  });

  group('TrackEvent', () {
    test('TrackEvent is recorded', () async {
      const testEventName = 'test_event';
      const testParams = {'p1': 'one', 'p2': 'two'};
      final recordingVendor = RecordingVendor();

      await ax.init([recordingVendor]);
      await ax.invokeAction(TrackEvent(testEventName, testParams));

      expect(recordingVendor.trackEventRecordings, {testEventName: testParams});
    });

    test('TrackEvent is recorded without params', () async {
      const testEventName = 'test_event';
      final recordingVendor = RecordingVendor();

      await ax.init([recordingVendor]);
      await ax.invokeAction(TrackEvent(testEventName));

      expect(recordingVendor.trackEventRecordings, {testEventName: null});
    });
  });
}
