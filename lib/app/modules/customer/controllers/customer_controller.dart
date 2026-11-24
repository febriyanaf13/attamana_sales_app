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
  TextEditingController controllerPhone = TextEditingController();

  // Tambahan untuk Dropdown Provinsi & Kabupaten
  TextEditingController controllerProvinsi = TextEditingController();
  var provinsiId = ''.obs;
  var listProvinsi = <dynamic>[].obs;

  TextEditingController controllerKabupaten = TextEditingController();
  var kabupatenId = ''.obs;
  var listKabupaten = <dynamic>[].obs;

  var userId = storage.read(kUserId);
  var listCustomer = <Customer>[].obs;
  var listCustomerSearch = <Customer>[].obs;

  // Loading States
  var isLoadingSimpanCustomer = false.obs;
  var isLoadingUpdateCustomer = false.obs;
  var isLoadingProvinsi = false.obs;
  var isLoadingKabupaten = false.obs;
  var isLoadingCustomer = false.obs;
  var isLoadingMore = false.obs;

  // Pagination & Scroll (VERSI 49)
  var curretPage = 1.obs;
  var totalPages = 1.obs;
  var totalCustomer = 0.obs;
  var visiblePage = 1.obs;
  var urut = 'nama'.obs; // nama | order_terakhir | baru
  var kataCari = ''.obs;
  final scrollController = ScrollController();
  int _permintaan = 0;

  @override
  void onInit() {
    getCustomer();
    getProvinsi();
    // Debounce search: Tunggu 450ms setelah user berhenti mengetik
    debounce(kataCari, (_) => getCustomer(),
        time: const Duration(milliseconds: 450));

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        muatBerikutnya();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void ubahUrut(String nilai) {
    if (urut.value == nilai) return;
    urut.value = nilai;
    getCustomer();
  }

  void muatBerikutnya() {
    if (isLoadingCustomer.isTrue || isLoadingMore.isTrue) return;
    if (curretPage.value >= totalPages.value) return;
    _ambil(curretPage.value + 1, tambah: true);
  }

  void resetForm() {
    controllerNama.clear();
    controllerAddress.clear();
    controllerPhone.clear();
    controllerProvinsi.clear();
    controllerKabupaten.clear();
    provinsiId.value = '';
    kabupatenId.value = '';
    listKabupaten.clear();
  }

  void getProvinsi() {
    isLoadingProvinsi.value = true;
    CustomerProvider().getProvinsi().then((value) {
      isLoadingProvinsi.value = false;
      if (value.status.isOk && value.body['success'] == true) {
        listProvinsi.value = value.body['data'] ?? [];
      }
    });
  }

  void getKabupaten(String provId) {
    isLoadingKabupaten.value = true;
    listKabupaten.clear();
    controllerKabupaten.clear();
    CustomerProvider().getKabupaten(provId).then((value) {
      isLoadingKabupaten.value = false;
      if (value.status.isOk && value.body['success'] == true) {
        listKabupaten.value = value.body['data'] ?? [];
      }
    });
  }

  void getCustomer() {
    _ambil(1, tambah: false);
  }

  void _ambil(int page, {required bool tambah}) {
    final nomor = ++_permintaan;
    if (tambah) {
      isLoadingMore.value = true;
    } else {
      isLoadingCustomer.value = true;
    }

    CustomerProvider()
        .getCustomer(userId, controllerSearch.text.trim(), page,
            urut: urut.value)
        .then((value) {
      if (nomor != _permintaan) return;
      isLoadingMore.value = false;
      isLoadingCustomer.value = false;

      if (value.status.isOk &&
          value.body is Map &&
          value.body['success'] == true) {
        var data = value.body['data'] ?? [];
        var total = int.tryParse('${value.body['total'] ?? 0}') ?? 0;
        var perhalaman =
            int.tryParse('${value.body['perhalaman'] ?? 10}') ?? 10;

        totalCustomer.value = total;
        totalPages.value = total == 0 ? 1 : (total / perhalaman).ceil();
        curretPage.value = page;

        final baru = customerFromJson(data);
        if (tambah) {
          listCustomer.addAll(baru);
        } else {
          listCustomer.value = baru;
          if (scrollController.hasClients) scrollController.jumpTo(0);
        }
        listCustomerSearch.value = List<Customer>.from(listCustomer);
        visiblePage.value = totalPages.value > 3 ? 3 : totalPages.value;
      } else if (!tambah) {
        _handleError(value);
      }
    });
  }

  void postNewCustomer() {
    if (!formKey.currentState!.validate()) return;
    var body = {
      "userid": userId,
      "nama": controllerNama.text,
      "address": controllerAddress.text,
      "city": controllerKabupaten.text, // Nama Kabupaten
      "phone1": controllerPhone.text,
      "state": controllerProvinsi.text, // Nama Provinsi
    };
    isLoadingSimpanCustomer.toggle();
    CustomerProvider().postNewCustomer(body).then((value) {
      isLoadingSimpanCustomer.toggle();
      if (value.status.isOk && value.body['success']) {
        Get.back();
        getCustomer();
        dialogSuccess('Success', value.body['message']);
      } else {
        dialogWarning('Ops...', value.body['message'] ?? 'Gagal simpan');
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
      if (value.status.isOk && value.body['success']) {
        Get.back();
        getCustomer();
        dialogSuccess('Success', value.body['message']);
      } else {
        dialogWarning('Ops...', value.body['message'] ?? 'Gagal update');
      }
    });
  }

  void _handleError(Response value) {
    if (value.status.isServerError) {
      dialogError('Terjadi Kesalahan', 'Masalah pada server');
    } else {
      dialogError('Gagal', 'Kode error: ${value.status.code}');
    }
  }
}
