library analytics_x;

import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';

const ALL = ['all'];

class AnalyticsX {
  static final AnalyticsX _instance = AnalyticsX._internal();
  final List<AnalyticsVendor> _vendors = [];

  factory AnalyticsX() {
    return _instance;
  }

  AnalyticsX._internal();

  Future<void> init(List<AnalyticsVendor> vendors) async {
    final newVendors = List.from(vendors).toSet().difference(_vendors.toSet()).toList();
    if (newVendors.isEmpty) {
      return;
    }

    for (final vendor in newVendors) {
      await vendor.init();
    }

    _vendors.addAll(List.from(newVendors));
  }

  Future<void> invokeAction(AnalyticsAction action, [List<String> vendorIds = ALL]) async {
    final List<AnalyticsVendor> vendorsToUse = _filterVendors(vendorIds);

    for (final vendor in vendorsToUse) {
      await vendor.handleAction(action);
    }
  }

  List<AnalyticsVendor> _filterVendors(List<String> vendorIds) {
    return vendorIds == ALL ? _vendors : _getVendorsById(vendorIds);
  }

  List<AnalyticsVendor> _getVendorsById(List<String> ids) {
    return _vendors.where((element) => ids.contains(element.id)).toList();
  }

  void uninit() {
    _vendors.clear();
  }
}
