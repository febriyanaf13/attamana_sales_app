import 'package:attamana_salles_app/app/modules/customer/models/customer.dart';
import 'package:attamana_salles_app/app/modules/customer/providers/customer_provider.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';

class CustomerController extends GetxController {
  //TODO: Implement CustomerController

  TextEditingController controllerSearch = TextEditingController();
  var userId = storage.read(kUserId);

  var listCustomer = <Customer>[].obs;
  var listCustomerSearch = <Customer>[].obs;

  var isSearchCustomer = false.obs;

  @override
  void onInit() {
    getCustomer();
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

  void getCustomer() {
    CustomerProvider().getCustomer(userId).then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        listCustomer.value = customerFromJson(data);
        listCustomerSearch.value = customerFromJson(data);
      }
    });
  }

  getlistSCustomerSearch(String searchText) {
    List<Customer> listSearch = listCustomer.where((element) {
      return element.nama.toLowerCase().contains(searchText.toLowerCase()) ||
          element.companyName
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          element.phone1.toLowerCase().contains(searchText.toLowerCase()) ||
          element.address
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          element.corporate
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          element.city
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          element.country
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase());
    }).toList();
    // listSearch.sort((a, b) => b!.tgllunas!.compareTo(a!.tgllunas!));
    listCustomerSearch(listSearch);
    print(listSearch.length);
  }
}
