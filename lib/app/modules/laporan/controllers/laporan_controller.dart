import 'package:get/get.dart';

import '../../../components/custom_dialog.dart';
import '../../../utils/constants.dart';
import '../models/laporan_bulanan.dart';
import '../models/laporan_tahunan.dart';
import '../providers/laporan_provider.dart';

class LaporanController extends GetxController {
  var currentTabIndex = 0.obs;
  var userData = storage.read('userData');
  int bulanIni = DateTime.now().month;
  int tahunIni = DateTime.now().year;
  var listLaporanBulanan = <LaporanBulanan>[].obs;
  var listLaporanTahunan = <LaporanTahunan>[].obs;

  final data = ['H', 'T', 'I', 'S', 'PA', 'DL', 'A', 'C'];

  @override
  void onInit() {
    super.onInit();
    // getLaporanBulanan();
    // getLaporanTahunan();
  }

  void getLaporanBulanan() {
    LaporanProvider()
        .getRiwayatAbsenBulanan(userData['userid'].toString(),
            bulanIni.toString(), tahunIni.toString())
        .then((value) {
      if (value.statusCode == 200) {
        var body = value.body;
        var success = body['success'];
        var message = body['message'];

        if (success) {
          var data = body['data'];
          listLaporanBulanan.value =
              laporanBulananFromJson(data).reversed.toList();
        }
      }
    });
  }

  void getLaporanTahunan() {
    LaporanProvider()
        .getRiwayatAbsenTahunan(
            userData['userid'].toString(), tahunIni.toString())
        .then((value) {
      if (value.statusCode == 200) {
        var body = value.body;
        var success = body['success'];
        var message = body['message'];

        if (success) {
          var data = body['data'];
          listLaporanTahunan.value =
              laporanTahunanFromJson(data).reversed.toList();
        }
      }
    });
  }
}
