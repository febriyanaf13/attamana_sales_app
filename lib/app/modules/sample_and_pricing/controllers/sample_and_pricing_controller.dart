import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_dialog.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../models/sample.dart';
import '../providers/sample_provider.dart';

/// VERSI 49: list Sample & Pricing milik sales (monitoring status, approval & progres).
class SampleAndPricingController extends GetxController {
  final controllerCari = TextEditingController();
  final scrollController = ScrollController();

  static const filterStatus = {
    'SEMUA': 'Semua',
    'MENUNGGU_APPROVAL': 'Menunggu approval',
    'DITOLAK': 'Ditolak',
    'PROSES': 'Proses',
    'DIKIRIM': 'Dikirim',
    'SELESAI': 'Selesai',
  };

  var list = <SampleItem>[].obs;
  var status = 'SEMUA'.obs;
  var kataCari = ''.obs;
  var total = 0.obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  int page = 1;
  int lastPage = 1;
  int _permintaan = 0;

  @override
  void onInit() {
    super.onInit();
    debounce(kataCari, (_) => muatUlang(),
        time: const Duration(milliseconds: 450));
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) muatBerikutnya();
    });
    muatUlang();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void pilihStatus(String kode) {
    if (status.value == kode) return;
    status.value = kode;
    muatUlang();
  }

  void muatUlang() => _ambil(1, tambah: false);

  void muatBerikutnya() {
    if (isLoading.isTrue || isLoadingMore.isTrue || page >= lastPage) return;
    _ambil(page + 1, tambah: true);
  }

  void _ambil(int halaman, {required bool tambah}) {
    final nomor = ++_permintaan;
    if (tambah) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
    }
    SampleProvider().getList({
      'page': '$halaman',
      'per_page': '10',
      'cari': controllerCari.text.trim(),
      'status': status.value == 'SEMUA' ? '' : status.value,
    }).then((r) {
      if (nomor != _permintaan) return;
      isLoading.value = false;
      isLoadingMore.value = false;
      final body = r.body;
      if (r.status.isOk && body is Map && body['success'] == true) {
        final data = (body['data'] is List ? body['data'] as List : [])
            .map((e) => SampleItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        page = intDari(body['page']);
        lastPage = intDari(body['last_page']);
        total.value = intDari(body['total']);
        if (tambah) {
          list.addAll(data);
        } else {
          list.value = data;
          if (scrollController.hasClients) scrollController.jumpTo(0);
        }
      } else if (!tambah) {
        if (r.status.connectionError) {
          dialogError('Tidak ada koneksi',
              'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        } else {
          dialogWarning(
              'Ops...',
              body is Map
                  ? '${body['message'] ?? body['status'] ?? 'Gagal memuat sample'}'
                  : 'Gagal memuat sample');
        }
      }
    });
  }
}
