import 'package:attamana_salles_app/app/modules/customer/models/customer.dart';
import 'package:attamana_salles_app/app/modules/customer/providers/customer_provider.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:awesome_dialog/awesome_dialog.dart' as awd;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_dialog.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../splash/controllers/splash_controller.dart';

class CustomerController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  TextEditingController controllerSearch = TextEditingController();
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  // Tambahan untuk Dropdown Provinsi
  TextEditingController controllerProvinsi = TextEditingController();
  var provinsiId = ''.obs;
  var listProvinsi = <dynamic>[].obs;

  //kabupaten
  TextEditingController controllerKabupaten = TextEditingController();
  var kabupatenId = ''.obs;
  var listKabupaten = <dynamic>[].obs;
  var isLoadingKabupaten = false.obs;

  var userId = storage.read(kUserId);

  var listCustomer = <Customer>[].obs;
  var listCustomerSearch = <Customer>[].obs;

  var isSearchCustomer = false.obs;
  var isLoadingSimpanCustomer = false.obs;
  var isLoadingUpdateCustomer = false.obs;
  var isLoadingProvinsi = false.obs;

  var curretPage = 1.obs;
  var totalPages = 1.obs;
  var visiblePage = 1.obs;

  @override
  void onInit() {
    getCustomer();
    getProvinsi(); // Ambil data provinsi saat inisialisasi
    super.onInit();
  }

  // Fungsi untuk mereset form (panggil saat akan tambah customer baru)
  void resetForm() {
    controllerNama.clear();
    controllerAddress.clear();
    controllerCity.clear();
    controllerPhone.clear();
    controllerProvinsi.clear();
    provinsiId.value = '';
    provinsiId.value = '';
    kabupatenId.value = ''; // Reset kabupaten ID
    listKabupaten.clear(); //
  }

  // Mengambil data provinsi dari API (Metode POST sesuai provider)
  void getProvinsi() {
    isLoadingProvinsi.value = true;
    CustomerProvider().getProvinsi().then((value) {
      isLoadingProvinsi.value = false;

      // PRINT RESPONSE BODY LENGKAP
      debugPrint("Full Response Provinsi: ${value.body}");

      if (value.status.isOk && value.body['success'] == true) {
        listProvinsi.value = value.body['data'] ?? [];
        // Print data spesifik yang akan masuk ke dropdown
        debugPrint("Data List Provinsi yang tampil: ${listProvinsi.value}");
      } else {
        debugPrint("Error Get Provinsi: ${value.statusText}");
      }
    });
  }

  // customer_controller.dart

  void getKabupaten(String provId) {
    isLoadingKabupaten.value = true;
    listKabupaten.clear();
    kabupatenId.value = '';
    controllerKabupaten.clear();

    CustomerProvider().getKabupaten(provId).then((value) {
      isLoadingKabupaten.value = false;

      // TAMBAHKAN INI UNTUK PRINT RESPONSE
      debugPrint("Full Response Kabupaten: ${value.body}");

      if (value.status.isOk && value.body['success'] == true) {
        listKabupaten.value = value.body['data'] ?? [];
        debugPrint("Data Kabupaten yang tampil: ${listKabupaten.value}");
      } else {
        debugPrint("Error Get Kabupaten: ${value.statusText}");
      }
    });
  }

  void getCustomer() {
    CustomerProvider()
        .getCustomer(userId, controllerSearch.text, curretPage.value)
        .then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        var total = value.body['total'];
        var perhalaman = value.body['perhalaman'];

        totalPages.value = (total / perhalaman).ceil();
        listCustomer.value = customerFromJson(data);
        listCustomerSearch.value = customerFromJson(data);

        // Perbaikan logika visible page
        if (totalPages.value == 1) {
          visiblePage.value = 1;
        } else if (totalPages.value == 2) {
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
          element.companyName.toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
          element.phone1.toLowerCase().contains(searchText.toLowerCase()) ||
          element.address.toString().toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
          element.corporate.toString().toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
          element.city.toString().toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
          element.country.toString().toLowerCase().contains(
                searchText.toLowerCase(),
              );
    }).toList();
    listCustomerSearch(listSearch);
  }

  void postNewCustomer() {
    if (!formKey.currentState!.validate()) return;

    var body = {
      "userid": userId,
      "nama": controllerNama.text,
      "address": controllerAddress.text,
      "city": controllerKabupaten.text,
      "phone1": controllerPhone.text,
      "state": controllerProvinsi.text,
    };

    isLoadingSimpanCustomer.toggle();
    CustomerProvider().postNewCustomer(body).then((value) {
      isLoadingSimpanCustomer.toggle();
      if (value.status.isOk) {
        var success = value.body['success'];
        var message = value.body['message'];
        if (success) {
          Get.back();
          getCustomer(); // Refresh list utama
          dialogSuccess('Success', message);
        } else {
          dialogWarning('Ops...', message);
        }
      } else {
        _handleError(value);
      }
    });
  }

  void postUpdateCustomer(customerId) {
    if (!formKey.currentState!.validate()) return;

    var body = {
      "customer_id": customerId,
      "userid": userId,
      "nama": controllerNama.text,
      "address": controllerAddress.text,
      "city": controllerKabupaten.text,
      "phone1": controllerPhone.text,
      "state": controllerProvinsi.text,
    };

    isLoadingUpdateCustomer.toggle();
    CustomerProvider().postUpdateCustomer(body).then((value) {
      isLoadingUpdateCustomer.toggle();
      if (value.status.isOk) {
        var success = value.body['success'];
        var message = value.body['message'];
        if (success) {
          Get.back();
          getCustomer(); // Refresh list utama
          dialogSuccess('Success', message);
        } else {
          dialogWarning('Ops...', message);
        }
      } else {
        _handleError(value);
      }
    });
  }

  // Helper untuk menangani error server
  void _handleError(Response value) {
    if (value.status.isServerError) {
      dialogError(
        'Terjadi Kesalahan',
        'Masalah pada server atau koneksi internet lambat',
      );
      awd.AwesomeDialog(
        context: Get.context!,
        dialogType: awd.DialogType.error,
        animType: awd.AnimType.topSlide,
        title: 'Koneksi Gagal',
        desc:
            'Tidak dapat terhubung ke server. Silakan periksa koneksi internet Anda.',
        btnOkText: 'Refresh',
        btnOkOnPress: () => getCustomer(),
        btnCancelText: 'Re-login',
        btnCancelOnPress: () {
          storage.remove('session');
          Get.offAllNamed(Routes.LOGIN);
        },
      ).show();
    } else {
      dialogError('Gagal', 'Kode error: ${value.status.code}');
    }
  }
}
