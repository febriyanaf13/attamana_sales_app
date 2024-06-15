import 'dart:ffi';

import 'package:attamana_salles_app/app/components/custom_dialog.dart';
import 'package:attamana_salles_app/app/modules/sales_module/assign_sales/models/customer_assign.dart';
import 'package:attamana_salles_app/app/modules/sales_module/assign_sales/models/customer_not_assign_ischecked.dart';
import 'package:attamana_salles_app/app/modules/sales_module/assign_sales/models/customer_sales.dart';
import 'package:attamana_salles_app/app/modules/sales_module/assign_sales/models/customer_sales_update.dart';
import 'package:attamana_salles_app/app/modules/sales_module/assign_sales/providers/assign_sales_provider.dart';
import 'package:attamana_salles_app/app/modules/sales_module/report_visit/models/sales.dart';
import 'package:attamana_salles_app/app/modules/sales_module/report_visit/providers/report_visit_provider.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../utils/constants.dart';
import '../models/customer_not_assign.dart';

class AssignSalesController extends GetxController {
  //TODO: Implement AssignSalesController
  //key
  final formKey = GlobalKey<FormState>();

  //text editing controller
  TextEditingController textEditingControllerSearchSales =
      TextEditingController();

  // controller
  // TabController tabController = TabController(length: 2, vsync: )

  //variable list
  var dataListCustomerAssign = <CustomerAssign>[].obs;
  var dataListCustomerNotAssign = <CustomerNotAssign>[].obs;
  var dataListCustomerNotAssignIsChecked = <CustomerNotAssignIsChecked>[].obs;
  var dataListCustomerSales = <Sales>[].obs;
  var dataListAllSales = <Sales>[].obs;
  var dataListCustomerSalesUpdate = <String>[].obs;

  //variable isLoading
  var isLoadingCustomerAssign = false.obs;
  var isLoadingCustomerNotAssign = false.obs;
  var isLoadingListDropdown = false.obs;

  //variable user
  var userId = storage.read(kUserId);

  //variable id
  var pegawaiId = ''.obs;

  //variable isLoading
  var isLoadingSubmitAssignSales = false.obs;
  var isLoadingUpdateAssignSales = false.obs;

  // variabel
  var listLength = 0.obs;

  @override
  void onInit() {
    getDataCustomerAsign();
    getDataCustomerNotAsign();
    getAllSalse();
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

  void getDataCustomerAsign() {
    isLoadingCustomerAssign.toggle();
    AssignSalesProvider().getCustomerAssign().then((value) {
      isLoadingCustomerAssign.toggle();

      if (value.status.isOk) {
        var data = value.body['data'];
        dataListCustomerAssign.value = customerAssignFromJson(data);
      }
    });
  }

  void getDataCustomerNotAsign() {
    isLoadingCustomerNotAssign.toggle();
    AssignSalesProvider().getCustomerNotAssign().then((value) {
      isLoadingCustomerNotAssign.toggle();

      if (value.status.isOk) {
        var data = value.body['data'];
        dataListCustomerNotAssign.value = customerNotAssignFromJson(data);

        // print(dataListCustomerNotAssign);
      }
    });
  }

  void getDataCustomerSales(customerId) {
    dataListCustomerSalesUpdate.clear();
    isLoadingListDropdown.toggle();

    AssignSalesProvider().getCustomerSales(customerId).then((value) {
      isLoadingListDropdown.toggle();

      if (value.status.isOk) {
        print(value.body);
        var data = value.body['data'];
        // var customerSales = <CustomerSales>[];
        // customerSales = salesFromJson(data);
        dataListCustomerSales.value = salesFromJson(data);

        listLength.value = dataListCustomerSales.length;
      }
    });
  }

  void postDataAssignSales() {
    List<String> list = [];
    String customerId = '';
    //mengambil data customer id dari list checked dan di reduce ke string dengan menggunakan pemisah koma
    for (var element in dataListCustomerNotAssignIsChecked) {
      if (element.isChecked.isTrue) {
        list.add(element.customerId);

        customerId = list.reduce((value, element) => value + ',' + element);
      }
    }
    var body = {
      'customer_id': customerId.toString(),
      'pegawai_id': pegawaiId.toString()
    };
    isLoadingSubmitAssignSales.toggle();
    AssignSalesProvider().postDataAssignSales(body).then((value) {
      isLoadingSubmitAssignSales.toggle();

      var success = value.body['success'];
      var message = value.body['message'];

      if (value.status.isOk) {
        if (success) {
          Get.back();
          Future<void>.delayed(
            const Duration(seconds: 1),
            () {
              dialogSuccess('Success', message);
            },
          );
        } else {
          dialogWarning('Gagal', message);
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

  void updateDataAssignSales(String customerId) {
    List<String> list = [];
    String pegawaiId = '';
    //mengambil data customer id dari list checked dan di reduce ke string dengan menggunakan pemisah koma
    for (var element in dataListCustomerSalesUpdate) {
      // if (element.isSet.isTrue) {
      list.add(element.toString());

      pegawaiId = list.reduce((value, element) => value + ',' + element);
      print('ini $customerId');
      // }
    }

    // for ()
    //   String removeSquareBracket = latlng.replaceAll("(", "");
    print(dataListCustomerSalesUpdate.length);
    print(dataListCustomerSalesUpdate);
    var body = {
      'customer_id': customerId.toString(),
      'pegawai_id': pegawaiId.toString()
    };

    print(body);
    isLoadingUpdateAssignSales.toggle();
    AssignSalesProvider().updateDataAssignSales(body).then((value) {
      isLoadingUpdateAssignSales.toggle();

      var success = value.body['success'];
      var message = value.body['message'];

      if (value.status.isOk) {
        if (success) {
          Get.back();
          Future<void>.delayed(
            const Duration(seconds: 1),
            () {
              Get.back();
              Future<void>.delayed(
                const Duration(seconds: 1),
                () {
                  dialogSuccess('Success', message);
                },
              );
            },
          );
        } else {
          dialogWarning('Gagal', message);
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

  void getAllSalse() {
    ReportVisitProvider().getAllSales().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        dataListAllSales.value = salesFromJson(data);
        print(data);
        //     .map((e) => {'text': e.nama, 'value': e.pegawaiId.toString()})
        //     .toList();
        // listSales.value.insert(0, {'text': 'ALL', 'value': 'ALL'});
      }
    });
  }
}
