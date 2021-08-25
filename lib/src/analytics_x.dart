library analytics_x;

import 'package:analyticsx/src/analytics_action.dart';
import 'package:analyticsx/src/analytics_vendor.dart';

const ALL = ['all'];

typedef AnalyticsError = Function(Object error, StackTrace stack);

/// Static analytics manager class, through which all consumer application interactions occur.
///
/// Vendors are registered and initialised via [AnalyticsX.init] and analytics activities are triggered and fanned out
/// to said vendors via [AnalyticsX.invokeAction]
class AnalyticsX {
  static final AnalyticsX _instance = AnalyticsX._internal();

  /// The [List] of [AnalyticsVendor] instances that have been passed to [AnalyticsX.init] and completed initialisation without error
  final List<AnalyticsVendor> _vendors = [];

  /// The function provided by the consuming application, called when an [AnalyticsVendor] throws an error on [AnalyticsVendor.init] or [AnalyticsVendor.handleAction].
  late AnalyticsError? onError;

  factory AnalyticsX() {
    return _instance;
  }

  AnalyticsX._internal();

  /// Initialise AnalyticsX with [vendors] via a list of [AnalyticsVendor] instances.
  ///
  /// The init method will check the list against existing initialised vendors and call the [AnalyticsVendor.init]
  /// method on each new vendor.
  ///
  /// If an AnalyticsVendor throws an error from the init method, they will not be registered with AnalyticsX, and so
  /// are eligible to attempt registration again.
  ///
  /// Optionally accepts an [onError] function that will be called with any error returned from [AnalyticsVendor.init]
  Future<void> init(List<AnalyticsVendor> vendors, [AnalyticsError? onError]) async {
    this.onError = onError;

    final uniqueVendors = _getUniqueVendorsById(vendors);

    final newVendors = List<AnalyticsVendor>.from(uniqueVendors)
      ..removeWhere((v) => _getVendorsById([v.id]).isNotEmpty);

    if (newVendors.isEmpty) {
      return;
    }

    //Do all the inits in parallel, and add them to the list on successful completion
    await Future.wait(newVendors.map((vendor) => _initAndAddVendor(vendor)));
  }

  /// Runs an analytics event via an [AnalyticsAction] abstraction named [action].
  ///
  /// Can be limited by the called to a list of vendor ids, as defined by the [AnalyticsVendor.id]
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

  List<AnalyticsVendor> _getUniqueVendorsById(List<AnalyticsVendor> vendorList) {
    final List<String> uniqueIds = [];
    for (final AnalyticsVendor vendor in List.from(vendorList)) {
      if (uniqueIds.contains(vendor.id)) {
        vendorList.remove(vendor);
      }
      uniqueIds.add(vendor.id);
    }
    return vendorList;
  }

  /// Resets the list of known vendors.
  ///
  /// Doesn't perform any additional work on the [AnalyticsVendor], but permits all vendors to be passed to [init]
  /// again and have their [AnalyticsVendor.init] method invoked.
  void reset() => _vendors.clear();

  /// Fetches the list of all registered (init'd) vendors
  List<AnalyticsVendor> get allRegisteredVendors => _vendors;
}
