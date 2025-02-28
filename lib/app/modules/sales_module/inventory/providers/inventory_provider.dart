import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/api/my_api.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/string.dart';

class InventoryProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getListGudang() {
    var api = Api.listGudang;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getListStockBarang(gudangId, cari, page) {
    var api =
        "${Api.listStockBarang}?gudang_id=$gudangId&cari=$cari&page=$page";
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }
}
