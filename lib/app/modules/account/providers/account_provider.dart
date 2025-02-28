import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class AccountProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> postUpdatePassword(body) {
    var api = Api.updatePassword;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }
}
