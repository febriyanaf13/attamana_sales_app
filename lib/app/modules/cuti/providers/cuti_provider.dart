import 'package:attamana_salles_app/app/data/api/my_api.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CutiProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> getTipeCuti() {
    var api = Api.tipeCuti;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getAllPengajuanCuti() {
    var api = Api.cuti;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getPengajuanCutiById(int id) {
    var api = '${Api.cuti}/$id';
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> postPengajuanCuti(Map<String, dynamic> body) {
    var api = Api.cuti;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> updatePengajuanCuti(int id, Map<String, dynamic> body) {
    var api = '${Api.cuti}/$id';
    if (kDebugMode) {
      print(api);
    }
    return put(api, body, headers: headers);
  }

  Future<Response> deletePengajuanCuti(int id) {
    var api = '${Api.cuti}/$id';
    if (kDebugMode) {
      print(api);
    }
    return delete(api, headers: headers);
  }
}
