import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/api/my_api.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/string.dart';

class ReportVisitProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> postRequestListReportVisit(body) {
    var api = Api.reportVisit;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> getAllSales() {
    var api = Api.sales;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
