import 'package:attamana_salles_app/app/modules/maps/models/all_shifts.dart';
import 'package:attamana_salles_app/app/modules/staff_home/controllers/staff_home_controller.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_dialog.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../models/lokasi_absen.dart';
import '../providers/maps_provider.dart';

class MapsController extends GetxController {
  var listLokasiAbsen = <LokasiAbsen?>[].obs;
  var loadingAbsenMasuk = false.obs;
  var loadingAbsenPulang = false.obs;
  var loadingCheckIn = false.obs;
  var loadingCheckOut = false.obs;
  var userData = storage.read('userData');
  var token = storage.read('token');
  var listKoorPolygonGedung = <LatLng>[].obs;

  var jamMasuk = ''.obs;
  var jamPulang = ''.obs;

  //shift
  var listAllShifts = <AllShifts>[].obs;
  var listAllShiftsUntukDipilih = <Map<String, Object>>[].obs;
  var shiftId = ''.obs;

  //controller
  var homeC = Get.put(StaffHomeController());

  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    // getRiwayatAbsenHarian();
    reqAllShifts();
    getKoorPolygonArea();
    super.onInit();
  }

  @override
  void onReady() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.onReady();
  }

  showDilarangMenggunakanMockLocaton() {
    return dialogError('Error',
        'Anda dideteksi menggunakan mock lockator, mohon dinonaktifkan.');
  }

  void getKoorPolygonArea() {
    // MapsProvider().getPoligonArea(userData['userid'], token).then((value) {
    //   if (value.statusCode == 200) {
    //     var body = value.body;
    //     var success = body['success'];
    //     var message = body['message'];
    //
    //     if (success) {
    //       var data = body['data'];
    //
    //       listLokasiAbsen.value = lokasiAbsenFromJson(data);
    //       listKoorPolygonGedung.value = listLokasiAbsen[0]!.geometryAbsen!;
    print(storage.read(kGeometryAbsen));
    //     } else {
    //       dialogWarning('Opss...', message);
    //     }
    //   } else {
    //     dialogError('Error ${value.statusCode}', 'Polygon Area');
    //   }
    // });
  }

  void onTapAccount() {
    Get.toNamed(Routes.ACCOUNT);
  }

  void getRiwayatAbsenHarian() {
    var dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
    MapsProvider()
        .getRiwayatAbsenHarian(userData['userid'], token, dateNow.toString())
        .then((value) {
      if (value.statusCode == 200) {
        var body = value.body;
        var success = body['success'];
        var message = body['message'];

        if (success) {
          var data = body['data'];
          jamMasuk.value = data[0]['jam_masuk'].toString();
          jamPulang.value = data[0]['jam_pulang'].toString();
        }
      }
    });
  }

  void postSimpanAbsensiMasuk(double lat, double lang) {
    var dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var timeNow = DateFormat('HH:mm:ss').format(DateTime.now());

    var body = {
      'shift_id': shiftId.value,
      'tanggal_absen': dateNow,
      'waktu': "$dateNow $timeNow",
      'lokasi': "($lat, $lang)"
    };
    print(body);
    loadingAbsenMasuk.toggle();

    MapsProvider().postSimpanAbsensiMasuk(body, token).then((value) {
      loadingAbsenMasuk.toggle();
      var data = value.body;
      print(data);

      if (value.status.isOk) {
        var success = value.body['success'];
        var message = value.body['message'];
        print(success);
        if (success) {
          var data = body['data'];

          dialogSuccess('Status Presensi', message);
          homeC.checkPresensiHariIni();
        } else {
          dialogWarning('Ops...', message);
        }
      } else if (value.status.isServerError) {
        dialogError('Terjadi Kesalahan',
            'Terjadi masalah pada server / koneksi internet lambat');
      } else if (value.status.connectionError) {
        dialogError('Tidak ada koneksi',
            'Jaringan internet bermasalah, silahkan cek koneksi internet!');
      }
    });
  }

  void postSimpanAbsensiPulang(double lat, double lang) {
    loadingAbsenPulang.toggle();
    var dateNow = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
    var body = {
      'tanggal_absen': dateNow,
      'waktu': "$dateNow $timeNow",
      'lokasi': "($lat, $lang)"
    };

    MapsProvider().postSimpanAbsensiPulang(body, token).then((value) {
      var data = value.body;
      print(data);
      if (value.statusCode == 200) {
        var message = data['message'];
        var success = data['success'];
        if (success) {
          var data = body['data'];
          dialogSuccess('Status Presensi Pulang', message);
          homeC.checkPresensiHariIni();

          // getRiwayatAbsenHarian();
        } else {
          dialogError('Opss...', message);
        }
      } else {
        dialogError('Error ${value.statusCode}', 'message');
      }
      loadingAbsenPulang.toggle();
    });
  }

  void reqAllShifts() {
    MapsProvider().getAllShift(token).then((value) {
      if (value.statusCode == 200) {
        var body = value.body;
        if (kDebugMode) {
          print(body);
        }

        listAllShifts.value = allShiftsFromJson(body['data']);

        listAllShiftsUntukDipilih.value =
            listAllShifts.map((e) => {'text': e.nama, 'value': e.id}).toList();
      }
    });
  }
}
