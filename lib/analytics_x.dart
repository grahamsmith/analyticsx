library analytics_x;

import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';

const ALL = ['all'];

class AnalyticsX {
  late List<AnalyticsVendor> vendors;

  void init(List<AnalyticsVendor> vendors) {
    vendors.addAll(vendors);
    for (final vendor in vendors) {
      vendor.init();
    }
  }

  void invokeAction(AnalyticsAction action, [List<String> vendorIds = ALL]) {
    final List<AnalyticsVendor> vendorsToUse = _filterVendors(vendorIds);

    for (final vendor in vendorsToUse) {
      vendor.handleAction(action);
    }
  }

  List<AnalyticsVendor> _filterVendors(List<String> vendorIds) {
    return vendorIds == ALL ? vendors : _getVendorsById(vendorIds);
  }

  List<AnalyticsVendor> _getVendorsById(List<String> ids) {
    return vendors.where((element) => ids.contains(element.id)).toList();
  }
}
