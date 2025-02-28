import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class KendaraanProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getKendaraan() {
    var api = Api.kendaraan;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getBensin() {
    var api = Api.bensin;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> postBensin(body) {
    var api = Api.bensin;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> deleteBensin() {
    var api = Api.bensin;
    if (kDebugMode) {
      print(api);
    }
    return delete(api, headers: headers);
  }
}
