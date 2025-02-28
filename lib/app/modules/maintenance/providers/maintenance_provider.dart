import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class MaintenanceProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getMaintenance() {
    var api = Api.maintenance;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getServices() {
    var api = Api.services;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getVendors() {
    var api = Api.vendors;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
