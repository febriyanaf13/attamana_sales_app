import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/custom_dialog.dart';
import '../../shared/sales_ui.dart';
import '../models/so_tracking.dart';
import '../providers/sales_order_provider.dart';

/// VERSI 49: tracking sales order.
/// List SO milik sales langsung tampil (tanpa harus pilih tanggal dulu), bisa dicari, difilter per tahap
/// (Konfirmasi, Produksi, Siap kirim, Pengiriman, Selesai) dan rentang tanggal, dimuat bertahap saat di-scroll.
class SalesOrderController extends GetxController {
  TextEditingController textEditingControllerTglFilterMulai =
      TextEditingController();
  TextEditingController textEditingControllerTglFilterSelesai =
      TextEditingController();
  TextEditingController textEditingControllerSearch = TextEditingController();

  var userId = storage.read(kUserId);

  static const filterTahap = {
    'SEMUA': 'Semua',
    'KONFIRMASI': 'Konfirmasi',
    'PRODUKSI': 'Produksi',
    'SIAP_KIRIM': 'Siap kirim',
    'PENGIRIMAN': 'Dikirim',
    'SELESAI': 'Selesai',
  };

  var listSo = <SoTracking>[].obs;
  var jumlahTahap = <String, int>{}.obs;
  var tahap = 'SEMUA'.obs;
  var rangeTanggal = ''.obs;
  var kataCari = ''.obs;
  var total = 0.obs;
  var page = 1;
  var lastPage = 1;
  var isLoadingSalesOrder = false.obs;
  var isLoadingMore = false.obs;
  final scrollController = ScrollController();
  int _permintaan = 0;

  @override
  void onInit() {
    super.onInit();
    debounce(kataCari, (_) => muatUlang(),
        time: const Duration(milliseconds: 450));
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        muatBerikutnya();
      }
    });
    muatUlang();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void pilihTahap(String kode) {
    if (tahap.value == kode) return;
    tahap.value = kode;
    muatUlang();
  }

  void terapkanTanggal() {
    final a = textEditingControllerTglFilterMulai.text;
    final b = textEditingControllerTglFilterSelesai.text;
    rangeTanggal.value = (a.isEmpty && b.isEmpty)
        ? ''
        : '${a.isEmpty ? '...' : fmtTanggal(a)}  –  ${b.isEmpty ? '...' : fmtTanggal(b)}';
    muatUlang();
  }

  void hapusTanggal() {
    textEditingControllerTglFilterMulai.clear();
    textEditingControllerTglFilterSelesai.clear();
    rangeTanggal.value = '';
    muatUlang();
  }

  void muatUlang() => _ambil(1, tambah: false);

  void muatBerikutnya() {
    if (isLoadingSalesOrder.isTrue || isLoadingMore.isTrue || page >= lastPage)
      return;
    _ambil(page + 1, tambah: true);
  }

  /// dipertahankan untuk kompatibilitas pemanggil lama
  void reqPostSalesOrder() => muatUlang();

  void _ambil(int halaman, {required bool tambah}) {
    final nomor = ++_permintaan;
    if (tambah) {
      isLoadingMore.value = true;
    } else {
      isLoadingSalesOrder.value = true;
    }
    final query = <String, String>{
      'userid': '$userId',
      'page': '$halaman',
      'per_page': '10',
      'cari': textEditingControllerSearch.text.trim(),
      'tahap': tahap.value == 'SEMUA' ? '' : tahap.value,
      'tgl_mulai': textEditingControllerTglFilterMulai.text,
      'tgl_selesai': textEditingControllerTglFilterSelesai.text,
    };
    SalesOrderProvider().getSoTracking(query).then((value) {
      if (nomor != _permintaan) return;
      isLoadingSalesOrder.value = false;
      isLoadingMore.value = false;
      final body = value.body;
      if (value.status.isOk && body is Map && body['success'] == true) {
        final data = (body['data'] is List ? body['data'] as List : [])
            .map((e) => SoTracking.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        page = intDari(body['page']);
        lastPage = intDari(body['last_page']);
        total.value = intDari(body['total']);
        if (body['jumlah_tahap'] is Map) {
          jumlahTahap.value = Map<String, dynamic>.from(body['jumlah_tahap'])
              .map((k, v) => MapEntry(k, intDari(v)));
        }
        if (tambah) {
          listSo.addAll(data);
        } else {
          listSo.value = data;
          if (scrollController.hasClients) scrollController.jumpTo(0);
        }
      } else if (!tambah) {
        if (value.status.connectionError) {
          dialogError('Tidak ada koneksi',
              'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        } else if (value.status.isServerError) {
          dialogError('Terjadi Kesalahan',
              'Terjadi masalah pada server / koneksi internet lambat');
        } else {
          dialogWarning(
              'Ops...',
              body is Map
                  ? '${body['message'] ?? body['status'] ?? 'Gagal memuat sales order'}'
                  : 'Gagal memuat sales order');
        }
      }
    });
  }
}
