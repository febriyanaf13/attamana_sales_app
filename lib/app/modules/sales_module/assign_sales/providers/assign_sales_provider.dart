import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/api/my_api.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/string.dart';

class AssignSalesProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getCustomerAssign() {
    var api = Api.customerAssign;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getCustomerNotAssign() {
    var api = Api.customerNotAssign;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getCustomerSales(customerId) {
    var api = '${Api.customerSales}/$customerId';
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> postDataAssignSales(body) {
    var api = Api.simpanAssignSales;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> updateDataAssignSales(body) {
    var api = Api.updateAssignSales;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }
}
