import 'package:attamana_salles_app/app/modules/sales_module/assign_sales/controllers/assign_sales_controller.dart';
import 'package:attamana_salles_app/app/modules/sales_module/inventory/models/barang.dart';
import 'package:attamana_salles_app/app/modules/sales_module/inventory/models/gudang.dart';
import 'package:attamana_salles_app/app/modules/sales_module/inventory/providers/inventory_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController {
  //TODO: Implement InventoryController

  TextEditingController controllerSearch = TextEditingController();
  TextEditingController textEditingControllerGudang =
      TextEditingController(text: 'ALL');
  var listGudang = <Gudang>[].obs;
  var listStockBarang = <Barang>[].obs;
  var listStockBarangSearch = <Barang>[].obs;

  var gudangId = ''.obs;
  var isLoadingListStockBarang = false.obs;
  var isSearchInventory = false.obs;

  var page = 1.obs;
  var numberPage = 1.obs;
  var visiblePage = 1.obs;

  @override
  void onInit() {
    getListGudang();
    gudangId.value = 'ALL';
    getListStockBarang(gudangId.value);

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

  void getListGudang() {
    InventoryProvider().getListGudang().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        List<Gudang> gudangs = gudangFromJson(data);
        listGudang.value = [
          Gudang(
            gudangId: 0,
            kode: 'ALL',
            namaGudang: 'ALL',
            alamat: '',
            deskripsi: '',
            status: '',
          ),
          ...gudangs
        ];
        //     .map((e) => {'text': e.namaGudang, 'value': e.gudangId.toString()})
        //     .toList();
        // listGudang.value.insert(0, {'text': 'ALL', 'value': 'ALL'});
// for (var list in listJobVisit) {
//   if (list.status == null || list.status == 'CHECK IN') {
//     listJobVisitOpenProgress.add(list);
//   }
// }
      }
    }).timeout(const Duration(seconds: 60));
  }

  void getListStockBarang(gudangId) {
    isLoadingListStockBarang.toggle();
    listStockBarangSearch.clear();

    print("gudang_id : $gudangId");
    InventoryProvider()
        .getListStockBarang(
            gudangId == 0 ? 'ALL' : gudangId, controllerSearch.text, page)
        .then((value) {
      isLoadingListStockBarang.toggle();
      print("inventory response : ${value.body}");
      print("inventory response code : ${value.statusCode}");
      print("inventory response text : ${value.statusText}");
      if (value.status.isOk) {
        var data = value.body['data'];
        var total = value.body['total'];
        var perhalaman = value.body['perhalaman'];
        print("inventory : $data");
        print('total $total');
        print('halaman $numberPage');
        listStockBarang.value = barangFromJson(data);
        listStockBarangSearch.value = barangFromJson(data);
        if (gudangId == 0) {
          numberPage.value = 1;
        } else {
          numberPage.value = (total / perhalaman).ceil();
        }
        page == 1;

        if (numberPage == 1) {
          visiblePage.value = 1;
        } else if (numberPage == 2) {
          visiblePage.value = 2;
        } else {
          visiblePage.value = 3;
        }
      }
    }).timeout(const Duration(minutes: 5));
  }

  getlistSCustomerSearch(String searchText) {
    List<Barang> listSearch = listStockBarang.where((element) {
      return element.namaGudang
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          element.namaProduk.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    // listSearch.sort((a, b) => b!.tgllunas!.compareTo(a!.tgllunas!));
    listStockBarangSearch(listSearch);
    print(listSearch.length);
  }
}
