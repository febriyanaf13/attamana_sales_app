import 'package:attamana_salles_app/app/modules/lembur/models/lembur.dart';
import 'package:attamana_salles_app/app/modules/lembur/providers/lembur_provider.dart';
import 'package:get/get.dart';

class LemburController extends GetxController {
  //TODO: Implement LemburController

  var listRiwayatLembur = <Lembur>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getRiwayatLembur();
    super.onInit();
  }

  void getRiwayatLembur() {
    LemburProvider().getRiwayatLembur().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        listRiwayatLembur.value = lemburFromJson(data);
      }
    });
  }
}
