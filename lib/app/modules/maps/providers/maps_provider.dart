import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';

class MapsProvider extends GetConnect {
  Future<Response> getPoligonArea(int userId, String token) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    return get('${Api.lokasiAbsen}/$userId', headers: headers);
  }

  Future<Response> getRiwayatAbsenHarian(
      int userId, String token, String date) {
    var headers = {
      "Authorization": "Bearer $token",
      'Accept': 'application/json'
    };
    print('${Api.riwayatAbsenHarian}/$date/$userId');
    return get('${Api.riwayatAbsenHarian}/$date/$userId', headers: headers);
  }

  //post login
  Future<Response> postSimpanAbsensiMasuk(body, String token) {
    var headers = {
      "Authorization": "Bearer $token",
      'Accept': 'application/json'
    };
    if (kDebugMode) {
      print(Api.simpanAbsenMasuk);
    }

    return post(Api.simpanAbsenMasuk, body, headers: headers);
  }

  Future<Response> postSimpanAbsensiPulang(body, String token) {
    var headers = {
      "Authorization": "Bearer $token",
      'Accept': 'application/json'
    };
    if (kDebugMode) {
      print(Api.simpanAbsenPulang);
    }

    return post(Api.simpanAbsenPulang, body, headers: headers);
  }

  Future<Response> getAllShift(String token) {
    var headers = {
      "Authorization": "Bearer $token",
    };
    if (kDebugMode) {
      print(Api.getAllShift);
    }
    return get(Api.getAllShift, headers: headers);
  }
}
