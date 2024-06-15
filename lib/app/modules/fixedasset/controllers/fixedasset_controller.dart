import 'package:attamana_salles_app/app/modules/fixedasset/models/fixedasset.dart';
import 'package:attamana_salles_app/app/modules/fixedasset/providers/fixedasset_provider.dart';
import 'package:get/get.dart';

class FixedassetController extends GetxController {
  //TODO: Implement FixedassetController

  var listFixedasset = <Fixedasset>[].obs;
  var listFixedassetDropdown = <Map<String, Object>>[].obs;

  @override
  void onInit() {
    getFixedasset();

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

  void getFixedasset() {
    FixedassetProvider().getFixedasset().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        print(data);
        listFixedasset.value = fIxedassetFromJson(data);
        listFixedassetDropdown.value = listFixedasset
            .map((element) => {'text': element.namaAsset, 'value': element.id})
            .toList();
      }
    });
  }
}
