import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/api/my_api.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/string.dart';

class SalesOrderProvider extends GetConnect {
  SalesOrderProvider() : super(timeout: const Duration(seconds: 30));

  // token dibaca setiap request (dulu disimpan sekali saat provider dibuat)
  Map<String, String> get headers => {
        "Authorization": "Bearer ${storage.read(kToken)}",
        "Accept": "application/json"
      };

  /// API lama (so_monitoring) — tetap ada untuk versi aplikasi sebelumnya
  Future<Response> reqPostSalesOrder(body) {
    var api = Api.salesOrder;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  /// VERSI 49: list tracking SO (paging, cari, filter tahap & tanggal)
  Future<Response> getSoTracking(Map<String, String> query) {
    return get(Api.soTracking, headers: headers, query: query);
  }

  /// VERSI 49: detail tracking 1 SO
  Future<Response> getSoTrackingDetail(int pesananId, String userId) {
    return get('${Api.soTracking}/$pesananId',
        headers: headers, query: {'userid': userId});
  }
}
