import 'package:attamana_salles_app/app/data/api/my_api.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TerlambatProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getAllPengajuanTerlambat() {
    var api = Api.terlambat;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getPengajuanTerlambatById(int id) {
    var api = '${Api.terlambat}/$id';
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> postPengajuanTerlambat(dynamic body) {
    var api = Api.terlambat;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> updatePengajuanTerlambat(int id, Map<String, dynamic> body) {
    var api = '${Api.terlambat}/$id';
    if (kDebugMode) {
      print(api);
    }
    return put(api, body, headers: headers);
  }

  Future<Response> deletePengajuanTerlambat(int id) {
    var api = '${Api.terlambat}/$id';
    if (kDebugMode) {
      print(api);
    }
    return delete(api, headers: headers);
  }
}
