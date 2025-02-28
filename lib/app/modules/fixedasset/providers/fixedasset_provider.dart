import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class FixedassetProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getFixedasset() {
    var api = Api.fixedasset;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
