library analytics_x;

import 'package:analyticsx/analytics_action.dart';
import 'package:analyticsx/analytics_vendor.dart';

const ALL = ['all'];

typedef AnalyticsError = Function(Object error, StackTrace stack);

class AnalyticsX {
  static final AnalyticsX _instance = AnalyticsX._internal();
  final List<AnalyticsVendor> _vendors = [];
  late AnalyticsError? onError;

  factory AnalyticsX() {
    return _instance;
  }

  AnalyticsX._internal();

  Future<void> init(List<AnalyticsVendor> vendors, [AnalyticsError? onError]) async {
    this.onError = onError;

    final newVendors = List<AnalyticsVendor>.from(vendors)..removeWhere((v) => _vendors.contains(v));

    if (newVendors.isEmpty) {
      return;
    }

    //Do all the inits in parallel, and add them to the list on successful completion
    await Future.wait(newVendors.map((vendor) => _initAndAddVendor(vendor)));
  }

  Future<void> invokeAction(AnalyticsAction action, [List<String> vendorIds = ALL]) async {
    final List<AnalyticsVendor> vendorsToUse = _filterVendors(vendorIds);

    await Future.wait(
        vendorsToUse.map((vendor) => _handleActionSafely(vendor, action))); //Do all the actions in parallel
  }

  Future<void> _initAndAddVendor(AnalyticsVendor vendor) async {
    try {
      await vendor.init();
      _vendors.add(vendor);
    } catch (error, stack) {
      onError?.call(error, stack);
    }
  }

  Future<void> _handleActionSafely(AnalyticsVendor vendor, AnalyticsAction action) async {
    try {
      await vendor.handleAction(action);
    } catch (error, stack) {
      onError?.call(error, stack);
    }
  }

  List<AnalyticsVendor> _filterVendors(List<String> vendorIds) {
    return vendorIds == ALL ? _vendors : _getVendorsById(vendorIds);
  }

  List<AnalyticsVendor> _getVendorsById(List<String> ids) {
    return _vendors.where((element) => ids.contains(element.id)).toList();
  }

  void reset() => _vendors.clear();
}
