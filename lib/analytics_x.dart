library analytics_x;

import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';

const ALL = const ['all'];

class AnalyticsX {
  late List<AnalyticsVendor> vendors;

  void init(List<AnalyticsVendor> vendors) {
    vendors.addAll(vendors);
    for (var vendor in vendors) {
      vendor.init();
    }
  }

  void invokeAction(AnalyticsAction action, [List<String> vendorIds = ALL]) {
    List<AnalyticsVendor> vendorsToUse = _filterVendors(vendorIds);

    for (var vendor in vendorsToUse) {
      if (canHandleAction(vendor, action)) {
        vendor.handleAction(action);
      }
    }
  }

  bool canHandleAction(AnalyticsVendor vendor, AnalyticsAction action) {
    for (var supportedAction in vendor.supportedActions) {
      if (supportedAction == action.runtimeType) {
        return true;
      }
    }

    return false;
  }

  // void trackEvent(String event, Map<String, String> properties, [List<String> vendorIds = ALL]) {
  //   List<AnalyticsVendor> vendorsToUse = _filterVendors(vendorIds);
  //
  //   for (var vendor in vendorsToUse) {
  //     if (vendor is AnalyticsEventProvider) {
  //       AnalyticsEventProvider analyticsEventProvider = vendor as AnalyticsEventProvider;
  //
  //       analyticsEventProvider.trackEvent(event, properties);
  //     }
  //   }
  // }

  List<AnalyticsVendor> _filterVendors(List<String> vendorIds) {
    return vendorIds == ALL ? vendors : _getVendorsById(vendorIds);
  }

  List<AnalyticsVendor> _getVendorsById(List<String> ids) {
    return vendors.where((element) => ids.contains(element.id)).toList();
  }
}
