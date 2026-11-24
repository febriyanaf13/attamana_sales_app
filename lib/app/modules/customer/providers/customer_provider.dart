import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class CustomerProvider extends GetConnect {
  // Ambil token terbaru dari storage untuk headers
  Map<String, String> get headers => {
        "Authorization": "Bearer ${storage.read(kToken)}",
        "Accept": "application/json"
      };

  // Mengambil data provinsi menggunakan metode POST sesuai kebutuhan server
  Future<Response> getProvinsi() {
    var api = Api.getProvinsi;
    return get(api, headers: headers);
  }

  // VERSI 49: parameter urut & per_page, nilai pencarian di-encode
  Future<Response> getCustomer(int userId, String cari, int page,
      {String urut = 'nama', int perPage = 15}) {
    var api = "${Api.customer}/$userId";
    return get(api, headers: headers, query: {
      'cari': cari,
      'page': '$page',
      'urut': urut,
      'per_page': '$perPage',
    });
  }

  Future<Response> postNewCustomer(Map<String, dynamic> body) {
    return post(Api.addCustomer, body, headers: headers);
  }

  Future<Response> postUpdateCustomer(Map<String, dynamic> body) {
    return post(Api.updateCustomer, body, headers: headers);
  }

  Future<Response> getKabupaten(String provId) {
    var api = "${Api.getKabupaten}/$provId";
    if (kDebugMode) print('GET to: $api');
    return get(api, headers: headers);
  }
}
