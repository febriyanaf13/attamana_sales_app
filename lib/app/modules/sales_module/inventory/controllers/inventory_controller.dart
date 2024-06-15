import 'package:attamana_salles_app/app/modules/sales_module/inventory/models/barang.dart';
import 'package:attamana_salles_app/app/modules/sales_module/inventory/models/gudang.dart';
import 'package:attamana_salles_app/app/modules/sales_module/inventory/providers/inventory_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController {
  //TODO: Implement InventoryController

  final count = 0.obs;

  TextEditingController textEditingControllerGudang =
      TextEditingController(text: 'ALL');
  var listGudang = <Map<String, String>>[].obs;
  var listStockBarang = <Barang>[].obs;

  var gudangId = ''.obs;
  var isLoadingListStockBarang = false.obs;

  @override
  void onInit() {
    getListGudang();
    postRequestlistStockBarang('ALL');

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

  void increment() => count.value++;

  void getListGudang() {
    InventoryProvider().getListGudang().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        listGudang.value = gudangFromJson(data)
            .map((e) => {'text': e.namaGudang, 'value': e.gudangId.toString()})
            .toList();
        listGudang.value.insert(0, {'text': 'ALL', 'value': 'ALL'});
// for (var list in listJobVisit) {
//   if (list.status == null || list.status == 'CHECK IN') {
//     listJobVisitOpenProgress.add(list);
//   }
// }
      }
    });
  }

  void postRequestlistStockBarang(gudangId) {
    isLoadingListStockBarang.toggle();

    var body = {'gudang_id': gudangId};
    InventoryProvider().postRequestListStockBarang(body).then((value) {
      isLoadingListStockBarang.toggle();

      if (value.status.isOk) {
        var data = value.body['data'];
        listStockBarang.value = barangFromJson(data);
      }
    });
  }
}
