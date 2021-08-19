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
    final newVendors = List<AnalyticsVendor>.from(vendors)..removeWhere((v) => _vendors.contains(v));

    if (newVendors.isEmpty) {
      return;
    }

    await Future.wait(newVendors.map((vendor) => vendor.init())); //Do all the inits in parallel

    _vendors.addAll(List.from(newVendors));
  }

  Future<void> invokeAction(AnalyticsAction action, [List<String> vendorIds = ALL]) async {
    final List<AnalyticsVendor> vendorsToUse = _filterVendors(vendorIds);

    await Future.wait(vendorsToUse.map((vendor) => vendor.handleAction(action))); //Do all the actions in parallel
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
