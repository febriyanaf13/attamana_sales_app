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

  var curretPage = 1.obs;
  var totalPages = 1.obs;
  var visiblePage = 1.obs;

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
    CustomerProvider()
        .getCustomer(userId, controllerSearch.text, curretPage)
        .then((value) {
      print("response get custommer :${value.body}");
      if (value.status.isOk) {
        var data = value.body['data'];
        var total = value.body['total'];
        var perhalaman = value.body['perhalaman'];
        totalPages.value = (total / perhalaman).ceil();
        listCustomer.value = customerFromJson(data);
        listCustomerSearch.value = customerFromJson(data);
        curretPage == 1;

        if (totalPages == 1) {
          visiblePage.value = 1;
        } else if (totalPages == 2) {
          visiblePage.value = 2;
        } else {
          visiblePage.value = 3;
        }
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
