import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_dialog.dart';
import '../../../services/notifikasi_service.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../providers/notifikasi_provider.dart';

/// 1 baris notifikasi (sama dengan lonceng web: tabel crm_notifikasis)
class NotifikasiItem {
  NotifikasiItem.fromJson(Map<String, dynamic> j)
      : id = intDari(j['id']),
        judul = teksDari(j['judul']),
        isi = teksDari(j['isi']),
        tipe = teksDari(j['tipe']),
        kategori = teksDari(j['kategori']),
        halaman = j['buka'] is Map ? teksDari(j['buka']['halaman']) : '',
        refId = j['buka'] is Map ? intDari(j['buka']['id']) : 0,
        waktu = teksDari(j['waktu']),
        dibaca = boolDari(j['dibaca']);

  final int id;
  final String judul;
  final String isi;
  final String tipe;
  final String kategori;
  final String halaman;
  final int refId;
  final String waktu;
  bool dibaca;
}

/// VERSI 51: daftar notifikasi, tandai dibaca, buka halaman terkait.
class NotificationController extends GetxController {
  final scrollController = ScrollController();

  static const filterKategori = {
    'SEMUA': 'Semua',
    'BELUM': 'Belum dibaca',
    'SO': 'Sales order',
    'PENDAMPINGAN': 'Pendampingan',
    'ACTIVITY': 'Activity',
    'SAMPLE': 'Sample',
  };

  var list = <NotifikasiItem>[].obs;
  var filter = 'SEMUA'.obs;
  var total = 0.obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  int page = 1;
  int lastPage = 1;
  int _permintaan = 0;

  NotifikasiService? get _svc => Get.isRegistered<NotifikasiService>() ? NotifikasiService.to : null;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300) muatBerikutnya();
    });
    muatUlang();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void pilihFilter(String kode) {
    if (filter.value == kode) return;
    filter.value = kode;
    muatUlang();
  }

  void muatUlang() {
    _ambil(1, tambah: false);
    _svc?.muatJumlah();
  }

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
    final f = filter.value;
    NotifikasiProvider()
        .getList(
            page: halaman,
            status: f == 'BELUM' ? 'belum' : '',
            kategori: (f == 'SEMUA' || f == 'BELUM') ? '' : f)
        .then((r) {
      if (nomor != _permintaan) return;
      isLoading.value = false;
      isLoadingMore.value = false;
      final body = r.body;
      if (r.status.isOk && body is Map && body['success'] == true) {
        final data = (body['data'] is List ? body['data'] as List : [])
            .map((e) => NotifikasiItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        page = intDari(body['page']);
        lastPage = intDari(body['last_page']);
        total.value = intDari(body['total']);
        _svc?.jumlahBelum.value = intDari(body['belum_dibaca']);
        if (tambah) {
          list.addAll(data);
        } else {
          list.value = data;
          if (scrollController.hasClients) scrollController.jumpTo(0);
        }
      } else if (!tambah) {
        if (r.status.connectionError) {
          dialogError('Tidak ada koneksi', 'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        } else {
          dialogWarning('Ops...', body is Map ? '${body['message'] ?? body['status'] ?? 'Gagal memuat notifikasi'}' : 'Gagal memuat notifikasi');
        }
      }
    });
  }

  /// ketuk notifikasi: tandai dibaca lalu buka halaman terkait
  void buka(NotifikasiItem n) {
    if (!n.dibaca) {
      n.dibaca = true;
      list.refresh();
      NotifikasiProvider().baca(ids: [n.id]).then((r) {
        final body = r.body;
        if (r.status.isOk && body is Map && body['success'] == true) {
          _svc?.jumlahBelum.value = intDari(body['belum_dibaca']);
        }
      });
    }
    if (n.halaman.isNotEmpty) {
      _svc?.bukaHalaman(n.halaman, n.refId);
    }
  }

  Future<void> bacaSemua() async {
    final r = await NotifikasiProvider().baca(semua: true);
    final body = r.body;
    if (r.status.isOk && body is Map && body['success'] == true) {
      for (final n in list) {
        n.dibaca = true;
      }
      list.refresh();
      _svc?.jumlahBelum.value = 0;
      if (filter.value == 'BELUM') muatUlang();
    } else {
      dialogWarning('Ops...', body is Map ? '${body['message'] ?? 'Gagal'}' : 'Gagal, periksa koneksi internet.');
    }
  }
}
