import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class StaffHomeProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> checkPresensiHariIni() {
    var api = Api.checkPresensihariIni;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getAnnouncement() {
    var api = Api.getAnnouncement;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
