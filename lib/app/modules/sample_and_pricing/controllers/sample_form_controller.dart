import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/custom_dialog.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../providers/sample_provider.dart';

/// satu pertanyaan spesifikasi (dari API sample/pertanyaan/{tipe_barang_id})
class PertanyaanSample {
  final int id;
  final String pertanyaan;
  final bool pilihanGanda;
  final List<Map<String, dynamic>> pilihan; // jawaban_id, jawaban, perlu_isian
  final RxInt jawabanId = 0.obs;
  final TextEditingController isian = TextEditingController();

  PertanyaanSample({required this.id, required this.pertanyaan, required this.pilihanGanda, required this.pilihan});

  bool get perluIsian {
    if (!pilihanGanda) return true;
    final p = pilihan.firstWhereOrNull((e) => intDari(e['jawaban_id']) == jawabanId.value);
    return p != null && boolDari(p['perlu_isian']);
  }
}

class KompetitorBaris {
  final nama = TextEditingController();
  final harga = TextEditingController();
}

/// VERSI 49: form input / edit Sample & Pricing, urutan isian sama dengan form web.
/// Validasi bisnis (approval, R&D, harga) tetap di web; di sini hanya kelengkapan isian seperti form web.
class SampleFormController extends GetxController {
  SampleFormController({this.sampleId});

  final int? sampleId;
  bool get modeEdit => sampleId != null;

  final formKey = GlobalKey<FormState>();
  final cTanggal = TextEditingController(text: ymd(DateTime.now()));
  final cDueDate = TextEditingController(text: ymd(DateTime.now()));
  final cNamaHotel = TextEditingController();
  final cLokasi = TextEditingController();
  final cJumlahKamar = TextEditingController();
  final cEstimasi = TextEditingController();
  final cTarget = TextEditingController();
  final cPic = TextEditingController();
  final cKontakPic = TextEditingController();
  final cNote = TextEditingController();

  var tipeCustomer = ''.obs; // EXISTING | NEW
  var customerId = 0.obs;
  var customerNama = ''.obs;
  var rating = 0.obs;
  var provinsi = ''.obs;
  var provinsiId = '';
  var kota = ''.obs;
  var tipeBarangId = 0.obs;
  var tipeBarang = ''.obs;
  var paymentTerm = ''.obs;

  var listTipeBarang = <Map<String, dynamic>>[].obs;
  var listPaymentTerm = <String>['CASH', 'TERM 7', 'TERM 14', 'TERM 30', 'TERM 60'].obs;
  var listProvinsi = <Map<String, dynamic>>[].obs;
  var listKota = <Map<String, dynamic>>[].obs;
  var pertanyaan = <PertanyaanSample>[].obs;
  var kompetitor = <KompetitorBaris>[].obs;
  var fotoBaru = <File>[].obs;
  var fotoLama = <Map<String, dynamic>>[].obs; // id, url
  final hapusFoto = <int>[];

  var isLoading = true.obs;
  var isLoadingPertanyaan = false.obs;
  var isLoadingKota = false.obs;
  var isSaving = false.obs;

  final _provider = SampleProvider();

  @override
  void onInit() {
    super.onInit();
    kompetitor.add(KompetitorBaris());
    _awal();
  }

  Future<void> _awal() async {
    isLoading.value = true;
    final m = await _provider.getMaster();
    if (m.status.isOk && m.body is Map && m.body['success'] == true) {
      final data = Map<String, dynamic>.from(m.body['data']);
      listTipeBarang.value = (data['tipe_barang'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
      if (data['payment_terms'] is List) {
        listPaymentTerm.value = (data['payment_terms'] as List).map((e) => e.toString()).toList();
      }
    }
    final p = await _provider.getProvinsi();
    if (p.status.isOk && p.body is Map && p.body['data'] is List) {
      listProvinsi.value = (p.body['data'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (modeEdit) await _muatSample();
    isLoading.value = false;
  }

  Future<void> _muatSample() async {
    final r = await _provider.getDetail(sampleId!);
    if (!(r.status.isOk && r.body is Map && r.body['success'] == true)) {
      dialogError('Gagal', r.body is Map ? '${r.body['message']}' : 'Data sample tidak dapat dimuat');
      return;
    }
    final d = Map<String, dynamic>.from(r.body['data']);
    cTanggal.text = teksDari(d['tanggal']);
    cDueDate.text = teksDari(d['due_date']);
    tipeCustomer.value = teksDari(d['tipe_customer']);
    customerId.value = intDari(d['customer_id']);
    customerNama.value = teksDari(d['nama_customer']);
    cNamaHotel.text = teksDari(d['nama_hotel']);
    rating.value = intDari(d['hotel_rating']);
    cLokasi.text = teksDari(d['lokasi_hotel']);
    cJumlahKamar.text = _angkaForm(d['jumlah_kamar']);
    cEstimasi.text = _angkaForm(d['estimasi_pemakaian_perbulan']);
    cTarget.text = _angkaForm(d['target_price']);
    paymentTerm.value = teksDari(d['payment_terms']);
    cPic.text = teksDari(d['pic_detail']);
    cKontakPic.text = teksDari(d['kontak_pic']);
    cNote.text = teksDari(d['note']);
    await _setProvinsi(teksDari(d['provinsi']), kotaAwal: teksDari(d['kota']));
    tipeBarangId.value = intDari(d['tipe_barang_id']);
    tipeBarang.value = teksDari(d['tipe_barang']);
    await _muatPertanyaan();
    for (final j in (d['jawaban'] is List ? d['jawaban'] as List : [])) {
      final q = pertanyaan.firstWhereOrNull((e) => e.id == intDari(j['pertanyaan_id']));
      if (q == null) continue;
      q.jawabanId.value = intDari(j['jawaban_id']);
      q.isian.text = teksDari(j['isian']);
    }
    final komp = (d['kompetitor'] is List ? d['kompetitor'] as List : []);
    if (komp.isNotEmpty) {
      kompetitor.clear();
      for (final k in komp) {
        final b = KompetitorBaris();
        b.nama.text = teksDari(k['nama_kompetitor']);
        b.harga.text = _angkaForm(k['harga']);
        kompetitor.add(b);
      }
    }
    fotoLama.value = (d['foto'] is List ? d['foto'] as List : []).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  String _angkaForm(dynamic v) {
    final n = angkaDari(v);
    if (n == 0) return '';
    return n == n.roundToDouble() ? n.round().toString() : n.toString();
  }

  // ------------------------------------------------------------------ pilihan

  Future<void> pilihTipeCustomer() async {
    final h = await pilihDariDaftar<String>(judul: 'Tipe customer', data: ['EXISTING', 'NEW'], label: (e) => e);
    if (h == null) return;
    tipeCustomer.value = h;
    if (h == 'NEW') {
      customerId.value = 0;
      customerNama.value = '';
    }
  }

  /// cari customer existing di server lalu isi otomatis data hotel (sama seperti form web)
  Future<void> pilihCustomer() async {
    final hasil = <Map<String, dynamic>>[].obs;
    final loading = false.obs;
    Future<void> cari(String q) async {
      loading.value = true;
      final r = await _provider.getCustomer(q);
      loading.value = false;
      if (r.status.isOk && r.body is Map && r.body['data'] is List) {
        hasil.value = (r.body['data'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
      }
    }

    cari('');
    final pilih = await Get.bottomSheet<Map<String, dynamic>>(
      Container(
        height: Get.height * 0.8,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            const SizedBox(height: 14),
            const Text('Pilih customer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kSlate900)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (v) => cari(v),
                decoration: InputDecoration(
                  hintText: 'Cari nama hotel / corporate / kota...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: kSlate50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (loading.isTrue && hasil.isEmpty) return const Center(child: CircularProgressIndicator());
                if (hasil.isEmpty) return const Center(child: Text('Customer tidak ditemukan', style: TextStyle(color: kSlate500)));
                return ListView.separated(
                  itemCount: hasil.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (_, i) {
                    final c = hasil[i];
                    return ListTile(
                      title: Text(teksDari(c['nama']), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      subtitle: Text([teksDari(c['corporate']), teksDari(c['kota'])].where((e) => e.isNotEmpty).join(' • '),
                          style: const TextStyle(fontSize: 12)),
                      onTap: () => Get.back(result: c),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
    if (pilih == null) return;
    customerId.value = intDari(pilih['customer_id']);
    customerNama.value = teksDari(pilih['nama']);
    cNamaHotel.text = teksDari(pilih['nama']);
    cLokasi.text = teksDari(pilih['alamat']);
    if (teksDari(pilih['payment_terms']).isNotEmpty) paymentTerm.value = teksDari(pilih['payment_terms']);
    rating.value = intDari(pilih['hotel_rating']);
    await _setProvinsi(teksDari(pilih['provinsi']), kotaAwal: teksDari(pilih['kota']));
  }

  Future<void> _setProvinsi(String nama, {String kotaAwal = ''}) async {
    if (nama.isEmpty) return;
    final p = listProvinsi.firstWhereOrNull((e) => teksDari(e['nama_provinsi']).toUpperCase() == nama.toUpperCase());
    provinsi.value = p == null ? nama : teksDari(p['nama_provinsi']);
    provinsiId = p == null ? '' : teksDari(p['provinsi_id']);
    kota.value = kotaAwal;
    if (provinsiId.isNotEmpty) await _muatKota();
  }

  Future<void> pilihProvinsi() async {
    final h = await pilihDariDaftar<Map<String, dynamic>>(
        judul: 'Provinsi', data: listProvinsi.toList(), label: (e) => teksDari(e['nama_provinsi']));
    if (h == null) return;
    provinsi.value = teksDari(h['nama_provinsi']);
    provinsiId = teksDari(h['provinsi_id']);
    kota.value = '';
    await _muatKota();
  }

  Future<void> _muatKota() async {
    isLoadingKota.value = true;
    listKota.clear();
    final r = await _provider.getKabupaten(provinsiId);
    isLoadingKota.value = false;
    if (r.status.isOk && r.body is Map && r.body['data'] is List) {
      listKota.value = (r.body['data'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  Future<void> pilihKota() async {
    if (provinsi.value.isEmpty) {
      dialogWarning('Pilih provinsi', 'Pilih provinsi terlebih dahulu.');
      return;
    }
    final h = await pilihDariDaftar<Map<String, dynamic>>(
        judul: 'Kota / kabupaten', data: listKota.toList(), label: (e) => teksDari(e['nama_kabupaten']));
    if (h != null) kota.value = teksDari(h['nama_kabupaten']);
  }

  Future<void> pilihTipeBarang() async {
    final h = await pilihDariDaftar<Map<String, dynamic>>(
        judul: 'Tipe barang', data: listTipeBarang.toList(), label: (e) => teksDari(e['nama_tipe']));
    if (h == null) return;
    if (intDari(h['id']) == tipeBarangId.value) return;
    tipeBarangId.value = intDari(h['id']);
    tipeBarang.value = teksDari(h['nama_tipe']);
    await _muatPertanyaan();
  }

  Future<void> _muatPertanyaan() async {
    if (tipeBarangId.value == 0) return;
    isLoadingPertanyaan.value = true;
    final r = await _provider.getPertanyaan(tipeBarangId.value);
    isLoadingPertanyaan.value = false;
    if (r.status.isOk && r.body is Map && r.body['data'] is List) {
      pertanyaan.value = (r.body['data'] as List).map((e) {
        final m = Map<String, dynamic>.from(e);
        final pilihan = (m['pilihan'] is List ? m['pilihan'] as List : []).map((x) => Map<String, dynamic>.from(x)).toList();
        return PertanyaanSample(
          id: intDari(m['pertanyaan_id']),
          pertanyaan: teksDari(m['pertanyaan']),
          pilihanGanda: pilihan.isNotEmpty,
          pilihan: pilihan,
        );
      }).toList();
    }
  }

  Future<void> pilihPaymentTerm() async {
    final h = await pilihDariDaftar<String>(judul: 'Payment term', data: listPaymentTerm.toList(), label: (e) => e);
    if (h != null) paymentTerm.value = h;
  }

  void tambahKompetitor() => kompetitor.add(KompetitorBaris());

  void hapusKompetitor(int i) {
    kompetitor.removeAt(i);
    if (kompetitor.isEmpty) kompetitor.add(KompetitorBaris());
  }

  Future<void> ambilFoto(ImageSource sumber) async {
    try {
      if (sumber == ImageSource.camera) {
        final f = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 1600);
        if (f != null) fotoBaru.add(File(f.path));
      } else {
        final fs = await ImagePicker().pickMultiImage(imageQuality: 70, maxWidth: 1600);
        fotoBaru.addAll(fs.map((e) => File(e.path)));
      }
    } catch (e) {
      dialogError('Foto', 'Gagal mengambil foto: $e');
    }
  }

  void hapusFotoLama(int id) {
    hapusFoto.add(id);
    fotoLama.removeWhere((e) => intDari(e['id']) == id);
  }

  // ------------------------------------------------------------------ simpan

  Future<void> simpan() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      dialogWarning('Belum lengkap', 'Periksa isian yang ditandai merah.');
      return;
    }
    if (tipeCustomer.value == 'EXISTING' && customerId.value == 0) {
      dialogWarning('Belum lengkap', 'Pilih customer existing.');
      return;
    }
    for (final q in pertanyaan) {
      if (q.pilihanGanda && q.jawabanId.value == 0) {
        dialogWarning('Spesifikasi belum lengkap', 'Pilih jawaban untuk "${q.pertanyaan}".');
        return;
      }
      if (q.perluIsian && q.isian.text.trim().isEmpty) {
        dialogWarning('Spesifikasi belum lengkap', 'Isi jawaban untuk "${q.pertanyaan}".');
        return;
      }
    }

    final jawaban = pertanyaan
        .map((q) => {
              'pertanyaan_id': q.id,
              'jawaban_id': q.pilihanGanda ? q.jawabanId.value : 0,
              'isian': q.perluIsian ? q.isian.text.trim() : '',
            })
        .toList();
    final komp = kompetitor
        .where((k) => k.nama.text.trim().isNotEmpty)
        .map((k) => {'nama_kompetitor': k.nama.text.trim(), 'harga': k.harga.text.trim().replaceAll('.', '').replaceAll(',', '.')})
        .toList();

    final body = FormData({
      'userid': _provider.userId,
      'tanggal': cTanggal.text,
      'due_date': cDueDate.text,
      'tipe_customer': tipeCustomer.value,
      'customer_id': tipeCustomer.value == 'EXISTING' ? '${customerId.value}' : '',
      'nama_hotel': cNamaHotel.text.trim(),
      'hotel_rating': '${rating.value}',
      'state': provinsi.value,
      'city': kota.value,
      'lokasi_hotel': cLokasi.text.trim(),
      'jumlah_kamar': cJumlahKamar.text.trim(),
      'tipe_barang_id': '${tipeBarangId.value}',
      'estimasi_pemakaian_perbulan': cEstimasi.text.trim(),
      'target_price': cTarget.text.trim().replaceAll('.', '').replaceAll(',', '.'),
      'payment_terms': paymentTerm.value,
      'pic_detail': cPic.text.trim(),
      'kontak_pic': cKontakPic.text.trim(),
      'note': cNote.text.trim(),
      'jawaban': jsonEncode(jawaban),
      'kompetitor': jsonEncode(komp),
      'hapus_foto': jsonEncode(hapusFoto),
      'foto[]': fotoBaru
          .asMap()
          .entries
          .map((e) => MultipartFile(e.value, filename: 'foto_${e.key}${_ekstensi(e.value.path)}'))
          .toList(),
    });

    isSaving.value = true;
    final r = modeEdit ? await _provider.update(sampleId!, body) : await _provider.simpan(body);
    isSaving.value = false;
    final b = r.body;
    if (r.status.isOk && b is Map && b['success'] == true) {
      Get.back(result: true);
      dialogSuccess('Berhasil', '${b['message']}');
    } else if (r.status.connectionError) {
      dialogError('Tidak ada koneksi', 'Jaringan internet bermasalah, silahkan coba lagi.');
    } else if (r.status.isServerError) {
      dialogError('Terjadi Kesalahan', 'Terjadi masalah pada server, silahkan coba lagi.');
    } else {
      dialogWarning('Gagal disimpan', b is Map ? '${b['message'] ?? b['status'] ?? 'Data sample gagal disimpan'}' : 'Data sample gagal disimpan');
    }
  }

  String _ekstensi(String path) {
    final i = path.lastIndexOf('.');
    return i < 0 ? '.jpg' : path.substring(i).toLowerCase();
  }
}
