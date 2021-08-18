library analytics_x;

import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';

const ALL = ['all'];

class AnalyticsX {
  static final AnalyticsX _instance = AnalyticsX._internal();
  List<AnalyticsVendor> _vendors = [];
  bool _isInited = false;

  factory AnalyticsX() {
    return _instance;
  }

  AnalyticsX._internal();

  void init(List<AnalyticsVendor> vendors) {
    if (_isInited) throw Exception('AnalyticsX has already been inited');

    _vendors = List.from(vendors);
    for (final vendor in vendors) {
      vendor.init();
    }
    _isInited = true;
  }

  void invokeAction(AnalyticsAction action, [List<String> vendorIds = ALL]) {
    final List<AnalyticsVendor> vendorsToUse = _filterVendors(vendorIds);

    for (final vendor in vendorsToUse) {
      vendor.handleAction(action);
    }
  }

  List<AnalyticsVendor> _filterVendors(List<String> vendorIds) {
    return vendorIds == ALL ? _vendors : _getVendorsById(vendorIds);
  }

  List<AnalyticsVendor> _getVendorsById(List<String> ids) {
    return _vendors.where((element) => ids.contains(element.id)).toList();
  }
}
