import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class CustomerProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getCustomer(int userId) {
    var api = "${Api.customer}/$userId";
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
