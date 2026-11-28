import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/custom_dialog.dart';
import '../../../style/colors.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../models/sample.dart';
import '../providers/sample_provider.dart';

/// VERSI 61: aksi sales setelah sample siap, sama dengan menu Aksi di daftar Sample web.
///  - [SampleKirimView]  : status READY TO DELIVERED -> "Kirim" (tanggal kirim, nama armada, kirim via, nomor resi)
///                         => DELIVERED SAMPLE TO CUSTOMER (API POST sample/kirim/{id}).
///  - [SampleStatusView] : status DELIVERED SAMPLE TO CUSTOMER -> "Update Status" APPROVED / REVISI / FAIL
///                         + catatan / revisi, bukti approval wajib untuk APPROVED (API POST sample/status/{id}).
/// Halaman ditutup dengan Navigator.pop (bukan Get.back) supaya tidak hanya menutup snackbar (lihat VERSI 59),
/// hasilnya pesan sukses dari server (String) atau null bila dibatalkan.

/// pesan gagal dari respon API (sama dengan form sample)
String pesanGagalSample(Response r, String bawaan) {
  if (r.status.connectionError) return 'Jaringan internet bermasalah, silahkan coba lagi.';
  if (r.status.isServerError) return 'Terjadi masalah pada server, silahkan coba lagi.';
  final b = r.body;
  return b is Map ? '${b['message'] ?? b['status'] ?? bawaan}' : bawaan;
}

/// ubah nilai FormField; pesan error lama dihapus begitu pilihan diisi
void _ubah<T>(FormFieldState<T> state, T? nilai) {
  state.didChange(nilai);
  if (state.hasError) state.validate();
}

Future<bool> _konfirmasi(BuildContext context, String judul, String isi, String tombol) async {
  final ya = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(judul, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: kSlate900)),
      content: Text(isi, style: const TextStyle(fontSize: 14, color: kSlate700)),
      actions: [
        TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Batal')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, foregroundColor: Colors.white),
          onPressed: () => Navigator.of(c).pop(true),
          child: Text(tombol),
        ),
      ],
    ),
  );
  return ya == true;
}

class _KepalaSample extends StatelessWidget {
  const _KepalaSample({required this.kode, required this.namaHotel, required this.statusKode, required this.statusLabel});

  final String kode;
  final String namaHotel;
  final String statusKode;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final w = warnaStatusSample(statusKode);
    return SalesCard(
      child: Row(
        children: [
          Icon(ikonStatusSample(statusKode), color: w, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kSlate500)),
                Text(namaHotel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: kSlate900)),
                const SizedBox(height: 4),
                SalesBadge(teks: statusLabel, warna: w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TombolSimpan extends StatelessWidget {
  const _TombolSimpan({required this.teks, required this.ikon, required this.proses, required this.onPressed});

  final String teks;
  final IconData ikon;
  final bool proses;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: proses ? null : onPressed,
            icon: proses
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Icon(ikon),
            label: Text(proses ? 'Menyimpan...' : teks, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}

/// pilihan berupa kotak (dipakai untuk Kirim via dan Status)
class _Pilihan extends StatelessWidget {
  const _Pilihan({required this.teks, required this.aktif, required this.warna, required this.onTap, this.ikon, this.keterangan = ''});

  final String teks;
  final String keterangan;
  final bool aktif;
  final Color warna;
  final IconData? ikon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: aktif ? warna.withOpacity(0.10) : kSlate50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: aktif ? warna : const Color(0xFFE2E8F0), width: aktif ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(aktif ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, size: 20, color: aktif ? warna : kSlate500),
            const SizedBox(width: 10),
            if (ikon != null) ...[
              Icon(ikon, size: 18, color: warna),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(teks, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: aktif ? warna : kSlate900)),
                  if (keterangan.isNotEmpty) Text(keterangan, style: const TextStyle(fontSize: 11.5, color: kSlate500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================================================
// KIRIM SAMPLE
// =====================================================================================================

class SampleKirimView extends StatefulWidget {
  const SampleKirimView({
    super.key,
    required this.sampleId,
    this.kode = '',
    this.namaHotel = '',
    this.pilihanVia = const ['SALES', 'HOTEL'],
    this.provider,
  });

  final int sampleId;
  final String kode;
  final String namaHotel;
  final List<String> pilihanVia;

  /// untuk pengujian; bawaan SampleProvider()
  final SampleProvider? provider;

  @override
  State<SampleKirimView> createState() => _SampleKirimViewState();
}

class _SampleKirimViewState extends State<SampleKirimView> {
  final formKey = GlobalKey<FormState>();
  final cTanggal = TextEditingController(text: ymd(DateTime.now()));
  final cArmada = TextEditingController();
  final cResi = TextEditingController();
  String via = '';
  bool proses = false;

  @override
  void dispose() {
    cTanggal.dispose();
    cArmada.dispose();
    cResi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      dialogWarning('Belum lengkap', 'Periksa isian yang ditandai merah.');
      return;
    }
    final ok = await _konfirmasi(
      context,
      'Kirim sample?',
      'Sample ${widget.kode} dicatat sudah dikirim ke pelanggan via $via (${cArmada.text.trim()}) '
          'tanggal ${fmtTanggal(cTanggal.text)}. Status menjadi DELIVERED SAMPLE TO CUSTOMER.',
      'Ya, kirim',
    );
    if (!ok || !mounted) return;
    setState(() => proses = true);
    final r = await (widget.provider ?? SampleProvider()).kirim(widget.sampleId, {
      'tanggal_kirim': cTanggal.text,
      'real_armada_kirim': cArmada.text.trim(),
      'via': via,
      'nomor_resi': cResi.text.trim(),
    });
    if (!mounted) return;
    setState(() => proses = false);
    final b = r.body;
    if (r.status.isOk && b is Map && b['success'] == true) {
      Navigator.of(context).pop('${b['message'] ?? 'Pengiriman sample tersimpan'}');
    } else {
      dialogWarning('Gagal disimpan', pesanGagalSample(r, 'Data pengiriman gagal disimpan'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSlate50,
      appBar: AppBar(
        title: const Text('Kirim Sample', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            _KepalaSample(
                kode: widget.kode, namaHotel: widget.namaHotel, statusKode: 'READY_TO_DELIVERED', statusLabel: 'Siap dikirim ke pelanggan'),
            const SalesSectionTitle('Update pengiriman', ikon: Icons.local_shipping_outlined),
            SalesCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SalesDateField(label: 'Tanggal kirim', controller: cTanggal, wajib: true),
                  const SizedBox(height: 14),
                  SalesTextField(label: 'Nama armada', hint: 'mis. JNE, GoSend, mobil kantor', controller: cArmada, wajib: true, maxLength: 100),
                  const SizedBox(height: 14),
                  FormField<String>(
                    validator: (_) => via.isEmpty ? 'Kirim via wajib dipilih' : null,
                    builder: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SalesFieldLabel('Kirim via', wajib: true),
                        Row(
                          children: [
                            for (var i = 0; i < widget.pilihanVia.length; i++) ...[
                              if (i > 0) const SizedBox(width: 10),
                              Expanded(
                                child: _Pilihan(
                                  teks: widget.pilihanVia[i],
                                  aktif: via == widget.pilihanVia[i],
                                  warna: kPrimaryColor,
                                  onTap: () {
                                    setState(() => via = widget.pilihanVia[i]);
                                    _ubah(state, via);
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Text(state.errorText!, style: const TextStyle(color: kMerah, fontSize: 11.5)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SalesTextField(label: 'Nomor resi', hint: 'Nomor resi (bila ada)', controller: cResi, maxLength: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _TombolSimpan(teks: 'Kirim ke pelanggan', ikon: Icons.local_shipping_rounded, proses: proses, onPressed: _simpan),
    );
  }
}

// =====================================================================================================
// UPDATE STATUS (APPROVED / REVISI / FAIL)
// =====================================================================================================

class SampleStatusView extends StatefulWidget {
  const SampleStatusView({
    super.key,
    required this.sampleId,
    this.kode = '',
    this.namaHotel = '',
    this.pilihanStatus = const ['APPROVED', 'REVISI', 'FAIL'],
    this.provider,
    this.ambilGambar,
  });

  final int sampleId;
  final String kode;
  final String namaHotel;
  final List<String> pilihanStatus;

  /// untuk pengujian; bawaan SampleProvider()
  final SampleProvider? provider;

  /// untuk pengujian; bawaan ImagePicker (kamera / galeri)
  final Future<File?> Function(ImageSource sumber)? ambilGambar;

  @override
  State<SampleStatusView> createState() => _SampleStatusViewState();
}

class _SampleStatusViewState extends State<SampleStatusView> {
  static const label = {
    'APPROVED': ['Approved', 'Pelanggan menyetujui sample — wajib lampirkan bukti approval'],
    'REVISI': ['Revisi', 'Pelanggan minta perbaikan — tulis catatan revisi'],
    'FAIL': ['Fail', 'Sample tidak diterima pelanggan'],
  };

  final formKey = GlobalKey<FormState>();
  final cCatatan = TextEditingController();
  String status = '';
  File? bukti;
  bool proses = false;

  @override
  void dispose() {
    cCatatan.dispose();
    super.dispose();
  }

  Color _warna(String s) => warnaStatusSample(s);

  Future<void> _ambil(ImageSource sumber) async {
    try {
      File? f;
      if (widget.ambilGambar != null) {
        f = await widget.ambilGambar!(sumber);
      } else {
        final x = await ImagePicker().pickImage(source: sumber, imageQuality: 70, maxWidth: 1600);
        f = x == null ? null : File(x.path);
      }
      if (f != null && mounted) setState(() => bukti = f);
    } catch (e) {
      dialogError('Foto', 'Gagal mengambil foto: $e');
    }
  }

  String _ekstensi(String path) {
    final i = path.lastIndexOf('.');
    return i < 0 ? '.jpg' : path.substring(i).toLowerCase();
  }

  Future<void> _simpan() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) {
      dialogWarning('Belum lengkap', 'Periksa isian yang ditandai merah.');
      return;
    }
    final ok = await _konfirmasi(
      context,
      'Update status sample?',
      'Status sample ${widget.kode} diubah menjadi $status. Setelah disimpan status tidak bisa diubah lagi dari aplikasi.',
      'Ya, simpan',
    );
    if (!ok || !mounted) return;
    setState(() => proses = true);
    final provider = widget.provider ?? SampleProvider();
    final body = FormData({
      'userid': provider.userId,
      'status': status,
      'catatan': cCatatan.text.trim(),
      if (status == 'APPROVED' && bukti != null)
        'file_bukti_approval': MultipartFile(bukti!, filename: 'bukti_approval${_ekstensi(bukti!.path)}'),
    });
    final r = await provider.updateStatus(widget.sampleId, body);
    if (!mounted) return;
    setState(() => proses = false);
    final b = r.body;
    if (r.status.isOk && b is Map && b['success'] == true) {
      Navigator.of(context).pop('${b['message'] ?? 'Status sample tersimpan'}');
    } else {
      dialogWarning('Gagal disimpan', pesanGagalSample(r, 'Status sample gagal disimpan'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSlate50,
      appBar: AppBar(
        title: const Text('Update Status Sample', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            _KepalaSample(
                kode: widget.kode,
                namaHotel: widget.namaHotel,
                statusKode: 'DELIVERED_SAMPLE_TO_CUSTOMER',
                statusLabel: 'Sudah dikirim ke pelanggan'),
            const SalesSectionTitle('Hasil dari pelanggan', ikon: Icons.fact_check_outlined),
            SalesCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormField<String>(
                    validator: (_) => status.isEmpty ? 'Status wajib dipilih' : null,
                    builder: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SalesFieldLabel('Status', wajib: true),
                        for (final s in widget.pilihanStatus)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _Pilihan(
                              teks: label[s]?[0] ?? s,
                              keterangan: label[s]?[1] ?? '',
                              aktif: status == s,
                              warna: _warna(s),
                              ikon: ikonStatusSample(s),
                              onTap: () {
                                setState(() => status = s);
                                _ubah(state, s);
                              },
                            ),
                          ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(state.errorText!, style: const TextStyle(color: kMerah, fontSize: 11.5)),
                          ),
                      ],
                    ),
                  ),
                  if (status == 'APPROVED') ...[
                    const SizedBox(height: 8),
                    FormField<File>(
                      validator: (_) => bukti == null ? 'Bukti approval wajib dilampirkan untuk status APPROVED' : null,
                      builder: (state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SalesFieldLabel('File bukti approval', wajib: true),
                          if (bukti != null)
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(bukti!, height: 180, width: double.infinity, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                            height: 80,
                                            color: kSlate100,
                                            alignment: Alignment.center,
                                            child: Text(bukti!.path.split('/').last, style: const TextStyle(color: kSlate500)),
                                          )),
                                ),
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: InkWell(
                                    onTap: () => setState(() => bukti = null),
                                    child: const CircleAvatar(radius: 14, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 16, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await _ambil(ImageSource.camera);
                                    _ubah(state, bukti);
                                  },
                                  icon: const Icon(Icons.photo_camera_outlined),
                                  label: const Text('Kamera'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await _ambil(ImageSource.gallery);
                                    _ubah(state, bukti);
                                  },
                                  icon: const Icon(Icons.photo_library_outlined),
                                  label: const Text('Galeri'),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 4, left: 2),
                            child: Text('Foto / gambar jpg, png, gif (mis. foto PO atau chat persetujuan pelanggan).',
                                style: TextStyle(fontSize: 11, color: kSlate500)),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 4),
                              child: Text(state.errorText!, style: const TextStyle(color: kMerah, fontSize: 11.5)),
                            ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  SalesTextField(label: 'Catatan / revisi', hint: 'Catatan / revisi dari pelanggan', controller: cCatatan, maxLines: 4, maxLength: 255),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _TombolSimpan(teks: 'Simpan status', ikon: Icons.save_rounded, proses: proses, onPressed: _simpan),
    );
  }
}

/// buka halaman aksi dari detail / list; hasil = pesan sukses atau null
Future<String?> bukaKirimSample(BuildContext context, {required int sampleId, String kode = '', String namaHotel = '', List<String>? pilihanVia}) {
  return Navigator.of(context).push<String>(MaterialPageRoute(
    builder: (_) => SampleKirimView(
      sampleId: sampleId,
      kode: kode,
      namaHotel: namaHotel,
      pilihanVia: (pilihanVia == null || pilihanVia.isEmpty) ? const ['SALES', 'HOTEL'] : pilihanVia,
    ),
  ));
}

Future<String?> bukaStatusSample(BuildContext context,
    {required int sampleId, String kode = '', String namaHotel = '', List<String>? pilihanStatus}) {
  return Navigator.of(context).push<String>(MaterialPageRoute(
    builder: (_) => SampleStatusView(
      sampleId: sampleId,
      kode: kode,
      namaHotel: namaHotel,
      pilihanStatus: (pilihanStatus == null || pilihanStatus.isEmpty) ? const ['APPROVED', 'REVISI', 'FAIL'] : pilihanStatus,
    ),
  ));
}
