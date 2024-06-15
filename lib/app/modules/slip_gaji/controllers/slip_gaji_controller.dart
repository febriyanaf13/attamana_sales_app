import 'package:attamana_salles_app/app/modules/slip_gaji/models/slip_gaji.dart';
import 'package:attamana_salles_app/app/modules/slip_gaji/providers/slip_gaji_provider.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';

class SlipGajiController extends GetxController {
  //TODO: Implement SlipGajiController
  //user data
  var nama = storage.read(kUserNama);

  var listAllSlipGaji = <SlipGaji>[].obs;
  SlipGaji? slipGajiById;
  final formatter = NumberFormat.simpleCurrency(
    decimalDigits: 0,
    locale: 'id_ID',
  );

  @override
  void onInit() {
    getAllSlipGaji();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String setRupiah(int nilai) {
    return formatter.format(nilai);
  }

  void getAllSlipGaji() {
    SlipGajiProvider().getAllSlipGaji().then((value) {
      var data = value.body['data'];
      if (kDebugMode) {
        print(value.body);
      }

      if (value.status.isOk) {
        listAllSlipGaji.value = slipGajiFromJson(data);
      }
    });
  }

  void getSlipGajiById(int id) {
    print(id);
    SlipGajiProvider().getSlipGajiById(id).then((value) {
      var data = value.body['data'];
      if (kDebugMode) {
        print(value.body);
      }

      if (value.status.isOk) {
        slipGajiById = slipGajiByIdFromJson(data);
        Get.toNamed(Routes.DETAIL_SLIP_GAJI);
      }
    });
  }
}
