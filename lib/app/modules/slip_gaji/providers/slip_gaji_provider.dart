import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class SlipGajiProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getAllSlipGaji() {
    var api = Api.slipGaji;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getSlipGajiById(int id) {
    var api = '${Api.slipGaji}/$id';
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
