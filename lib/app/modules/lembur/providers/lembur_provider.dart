import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class LemburProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getRiwayatLembur() {
    var api = Api.lembur;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
