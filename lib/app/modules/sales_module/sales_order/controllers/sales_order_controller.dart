import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/sales_order.dart';
import '../providers/sales_order_provider.dart';

class SalesOrderController extends GetxController {
  //TODO: Implement SalesOrderController

  TextEditingController textEditingControllerTglFilterMulai =
      TextEditingController();
  TextEditingController textEditingControllerTglFilterSelesai =
      TextEditingController();
  TextEditingController textEditingControllerSearch = TextEditingController();

  var userId = storage.read(kUserId);

  var listSalesOrder = <SalesOrder>[].obs;
  var listSalesOrderSearch = <SalesOrder>[].obs;
  var rangeTanggal = ''.obs;
  var isLoadingSalesOrder = false.obs;

  @override
  void onInit() {
    textEditingControllerTglFilterMulai.text =
        '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year.toString().padLeft(2, '0')}';
    textEditingControllerTglFilterSelesai.text =
        '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year.toString().padLeft(2, '0')}';
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

  void reqPostSalesOrder() {
    isLoadingSalesOrder.toggle();
    var body = {
      'user_id': userId,
      'tgl_mulai': textEditingControllerTglFilterMulai.text,
      'tgl_selesai': textEditingControllerTglFilterSelesai.text,
    };
    print(body);
    SalesOrderProvider().reqPostSalesOrder(body).then((value) {
      isLoadingSalesOrder.toggle();

      if (value.status.isOk) {
        var data = value.body['data'];
        if (kDebugMode) {
          print(data);
        }
        if (kDebugMode) {
          print(value.body);
        }
        rangeTanggal.value =
            '${textEditingControllerTglFilterMulai.text}  -  ${textEditingControllerTglFilterSelesai.text}';
        listSalesOrder.value = SalesOrderFromJson(data);
        listSalesOrderSearch.value = SalesOrderFromJson(data);
      }
    });
  }

  getlistSalesOrderSearch(String searchText) {
    List<SalesOrder> listSearch = listSalesOrder.where((element) {
      return element.namaCustomer
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          element.namaSales.toLowerCase().contains(searchText.toLowerCase()) ||
          element.noTransaksi
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          element.tglTransaksi
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase());
    }).toList();
    // listSearch.sort((a, b) => b!.tgllunas!.compareTo(a!.tgllunas!));
    listSalesOrderSearch(listSearch);
    print(listSearch.length);
  }
}
