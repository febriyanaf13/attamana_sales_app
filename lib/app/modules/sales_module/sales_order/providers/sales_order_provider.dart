import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/api/my_api.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/string.dart';
import '../models/sales_order.dart';

class SalesOrderProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> reqPostSalesOrder(body) {
    var api = Api.salesOrder;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }
}
