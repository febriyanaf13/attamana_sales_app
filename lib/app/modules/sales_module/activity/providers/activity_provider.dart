import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/api/my_api.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/string.dart';

class ActivityProvider extends GetConnect {
  var headers = {
    "Authorization": "Bearer ${storage.read(kToken)}",
    "Accept": "application/json"
  };

  Future<Response> postReqListVisit(body) {
    var api = Api.listActivity;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> getDetailVisit(visitId) {
    var api = '${Api.detailActivity}/$visitId';
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getExistingCustomer() {
    var api = Api.existingCustomer;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> getJenisKunjungan() {
    var api = Api.jenisKunjungan;
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> postSimpanActivity(body) {
    var api = Api.simpanActivity;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> updateActivity(body) {
    var api = Api.updateActivity;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> postPresensiActivity(body) {
    var api = Api.presensiActivity;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> postKunjunganAutoCheckOutActivity(body) {
    var api = Api.kunjunganAutoCheckOutActivity;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }

  Future<Response> getLead(int userId) {
    var api = '${Api.lead}/$userId';
    if (kDebugMode) {
      print(api);
    }
    return get(api, headers: headers);
  }

  Future<Response> postImageCheckIn(body) {
    var api = Api.uploadCheckinImage;
    if (kDebugMode) {
      print(api);
    }
    return post(api, body, headers: headers);
  }
}
