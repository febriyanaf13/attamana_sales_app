import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../style/colors.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../models/sample.dart';
import '../providers/sample_provider.dart';
import 'sample_and_pricing_view.dart';

/// VERSI 49: detail & monitoring 1 sample — status, approval, langkah R&D (rendering, pricing, pembuatan, QC),
/// harga jual, pengiriman sample, feedback pelanggan, data input sales.
class SampleDetailView extends StatefulWidget {
  const SampleDetailView({super.key, required this.sampleId, this.kode = ''});

  final int sampleId;
  final String kode;

  @override
  State<SampleDetailView> createState() => _SampleDetailViewState();
}

class _SampleDetailViewState extends State<SampleDetailView> {
  Map<String, dynamic>? d;
  bool loading = true;
  bool berubah = false;
  String pesan = '';

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    setState(() => loading = true);
    final r = await SampleProvider().getDetail(widget.sampleId);
    if (!mounted) return;
    final body = r.body;
    setState(() {
      loading = false;
      if (r.status.isOk && body is Map && body['success'] == true) {
        d = Map<String, dynamic>.from(body['data']);
        pesan = '';
      } else {
        pesan = body is Map ? '${body['message'] ?? 'Gagal memuat data'}' : 'Gagal memuat data, periksa koneksi internet.';
      }
    });
  }

  List<Map<String, dynamic>> _list(dynamic v) =>
      v is List ? v.map((e) => Map<String, dynamic>.from(e as Map)).toList() : <Map<String, dynamic>>[];

  Future<void> _edit() async {
    await SampleAndPricingView.bukaForm(sampleId: widget.sampleId);
    berubah = true;
    _muat();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: berubah);
        return false;
      },
      child: Scaffold(
        backgroundColor: kSlate50,
        appBar: AppBar(
          title: Text(widget.kode.isEmpty ? 'Detail Sample' : widget.kode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back(result: berubah)),
          actions: [
            if (d != null && boolDari(d!['boleh_edit']))
              IconButton(tooltip: 'Edit', onPressed: _edit, icon: const Icon(Icons.edit_rounded)),
          ],
        ),
        body: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: _muat,
          child: loading && d == null
              ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
              : d == null
                  ? SalesKosong(judul: 'Data tidak dapat dimuat', pesan: pesan, ikon: Icons.cloud_off_rounded)
                  : _isi(d!),
        ),
      ),
    );
  }

  Widget _isi(Map<String, dynamic> d) {
    final kode = teksDari(d['status_kode']);
    final w = warnaStatusSample(kode);
    final approval = _list(d['approval']);
    final langkah = _list(d['langkah']);
    final jawaban = _list(d['jawaban']);
    final kompetitor = _list(d['kompetitor']);
    final foto = _list(d['foto']);
    final riset = d['riset'] is Map ? Map<String, dynamic>.from(d['riset']) : null;
    final kirim = d['pengiriman'] is Map ? Map<String, dynamic>.from(d['pengiriman']) : <String, dynamic>{};
    final rating = intDari(d['hotel_rating']);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        // ---------------------------------------------- status
        SalesCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(teksDari(d['nama_hotel']), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: kSlate900)),
              const SizedBox(height: 2),
              Text('${teksDari(d['tipe_barang'])}  •  ${fmtTanggal(teksDari(d['tanggal']))}',
                  style: const TextStyle(fontSize: 12.5, color: kSlate500, fontWeight: FontWeight.w600)),
              if (rating > 0) ...[
                const SizedBox(height: 4),
                Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, size: 16, color: i < rating ? Colors.amber : Colors.grey.shade300))),
              ],
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: w.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(ikonStatusSample(kode), color: w, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(teksDari(d['status_label']), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: w))),
                      ],
                    ),
                    if (langkah.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      SalesQtyBar(label: 'Progres pembuatan sample (%)', nilai: angkaDari(d['progres']), total: 100, warna: w),
                    ],
                    if (teksDari(d['catatan_revisi']).isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text('Catatan: ${teksDari(d['catatan_revisi'])}', style: const TextStyle(fontSize: 12.5, color: kSlate700)),
                    ],
                  ],
                ),
              ),
              if (!boolDari(d['boleh_edit']))
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Sample sudah disetujui / diproses — perubahan data lewat web.',
                      style: TextStyle(fontSize: 11.5, color: kSlate500, fontStyle: FontStyle.italic)),
                ),
            ],
          ),
        ),

        // ---------------------------------------------- approval
        if (approval.isNotEmpty) ...[
          SalesSectionTitle('Approval (pengajuan ke-${intDari(d['putaran_approval'])})', ikon: Icons.how_to_reg_rounded),
          SalesCard(
            child: Column(
              children: approval.map((a) {
                final st = teksDari(a['status']);
                final wa = st == 'APPROVE' ? kHijau : (st == 'REJECT' ? kMerah : kOranye);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(st == 'APPROVE' ? Icons.check_circle_rounded : (st == 'REJECT' ? Icons.cancel_rounded : Icons.schedule_rounded),
                          color: wa, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(teksDari(a['nama']), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: kSlate900)),
                            Text(
                                st == 'MENUNGGU'
                                    ? 'Belum memberi keputusan'
                                    : '${st == 'APPROVE' ? 'Setuju' : 'Tolak'} • ${fmtTanggal(teksDari(a['waktu']), denganJam: true)}',
                                style: const TextStyle(fontSize: 11.5, color: kSlate500)),
                            if (teksDari(a['catatan']).isNotEmpty)
                              Text('"${teksDari(a['catatan'])}"', style: const TextStyle(fontSize: 12, color: kSlate700, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],

        // ---------------------------------------------- langkah R&D
        if (langkah.isNotEmpty) ...[
          const SalesSectionTitle('Langkah pembuatan sample', ikon: Icons.science_outlined),
          SalesCard(
            child: Column(
              children: langkah.map((l) {
                final st = teksDari(l['status']);
                final wl = st == 'DONE' ? kHijau : (st == 'PROGRESS' ? kBiru : kSlate500);
                final info = [
                  if (teksDari(l['pelaksana']).isNotEmpty) 'Pelaksana ${teksDari(l['pelaksana'])}',
                  if (teksDari(l['target_selesai']).isNotEmpty) 'target ${fmtTanggal(teksDari(l['target_selesai']))}',
                  if (teksDari(l['hasil']).isNotEmpty) 'hasil ${teksDari(l['hasil'])}',
                ].join(' • ');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(teksDari(l['nama']), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: kSlate900))),
                          SalesBadge(teks: st == 'DONE' ? 'Selesai' : (st == 'PROGRESS' ? 'Progress' : 'Belum mulai'), warna: wl),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (intDari(l['progres']) / 100).clamp(0.0, 1.0).toDouble(),
                          minHeight: 5,
                          backgroundColor: kSlate100,
                          valueColor: AlwaysStoppedAnimation<Color>(wl),
                        ),
                      ),
                      if (info.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(info, style: const TextStyle(fontSize: 11.5, color: kSlate500)),
                      ],
                      if (teksDari(l['catatan']).isNotEmpty)
                        Text(teksDari(l['catatan']), style: const TextStyle(fontSize: 12, color: kSlate700)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],

        // ---------------------------------------------- harga & pengiriman
        if (riset != null || angkaDari(d['harga_jual']) > 0 || teksDari(kirim['tanggal_kirim']).isNotEmpty) ...[
          const SalesSectionTitle('Harga & pengiriman sample', ikon: Icons.local_offer_outlined),
          SalesCard(
            child: Column(
              children: [
                if (riset != null) ...[
                  SalesInfoRow('No. R&D', teksDari(riset['nomor'])),
                  SalesInfoRow('Status R&D', teksDari(riset['status'])),
                  SalesInfoRow('Nama produk', teksDari(riset['nama_produk'])),
                  if (angkaDari(riset['harga_jual']) > 0) SalesInfoRow('Harga jual', fmtRupiah(angkaDari(riset['harga_jual'])), tebal: true),
                  if (angkaDari(riset['minimum_order']) > 0) SalesInfoRow('Minimum order', fmtAngka(angkaDari(riset['minimum_order']))),
                ],
                if (riset == null && angkaDari(d['harga_jual']) > 0) SalesInfoRow('Harga jual', fmtRupiah(angkaDari(d['harga_jual'])), tebal: true),
                if (teksDari(kirim['tanggal_kirim']).isNotEmpty) ...[
                  SalesInfoRow('Tanggal kirim', fmtTanggal(teksDari(kirim['tanggal_kirim']))),
                  SalesInfoRow('Via / armada', [teksDari(kirim['via']), teksDari(kirim['armada'])].where((e) => e.isNotEmpty).join(' — ')),
                  SalesInfoRow('No. resi', teksDari(kirim['nomor_resi'])),
                ],
              ],
            ),
          ),
        ],

        // ---------------------------------------------- data input
        const SalesSectionTitle('Data sample', ikon: Icons.description_outlined),
        SalesCard(
          child: Column(
            children: [
              SalesInfoRow('Tipe customer', teksDari(d['tipe_customer'])),
              if (teksDari(d['nama_customer']).isNotEmpty) SalesInfoRow('Customer', teksDari(d['nama_customer'])),
              SalesInfoRow('Due date', fmtTanggal(teksDari(d['due_date']))),
              SalesInfoRow('Provinsi / kota', [teksDari(d['provinsi']), teksDari(d['kota'])].where((e) => e.isNotEmpty).join(' / ')),
              SalesInfoRow('Lokasi hotel', teksDari(d['lokasi_hotel'])),
              SalesInfoRow('Jumlah kamar', fmtAngka(angkaDari(d['jumlah_kamar']))),
              SalesInfoRow('Estimasi / bulan', angkaDari(d['estimasi_pemakaian_perbulan']) > 0 ? fmtAngka(angkaDari(d['estimasi_pemakaian_perbulan'])) : ''),
              SalesInfoRow('Target price', angkaDari(d['target_price']) > 0 ? fmtRupiah(angkaDari(d['target_price'])) : ''),
              SalesInfoRow('Payment term', teksDari(d['payment_terms'])),
              SalesInfoRow('PIC', teksDari(d['pic_detail'])),
              SalesInfoRow('Kontak PIC', teksDari(d['kontak_pic'])),
              SalesInfoRow('Note', teksDari(d['note'])),
            ],
          ),
        ),

        if (jawaban.isNotEmpty) ...[
          const SalesSectionTitle('Spesifikasi', ikon: Icons.tune_rounded),
          SalesCard(
            child: Column(
              children: jawaban
                  .map((j) => SalesInfoRow(teksDari(j['pertanyaan']),
                      [teksDari(j['jawaban']), teksDari(j['isian'])].where((e) => e.isNotEmpty).join(' — '),
                      lebarLabel: 140))
                  .toList(),
            ),
          ),
        ],

        if (kompetitor.isNotEmpty) ...[
          const SalesSectionTitle('Existing supplier', ikon: Icons.storefront_outlined),
          SalesCard(
            child: Column(
              children: kompetitor
                  .map((k) => SalesInfoRow(teksDari(k['nama_kompetitor']),
                      angkaDari(k['harga']) > 0 ? fmtRupiah(angkaDari(k['harga'])) : '-'))
                  .toList(),
            ),
          ),
        ],

        if (foto.isNotEmpty) ...[
          const SalesSectionTitle('Foto', ikon: Icons.photo_library_outlined),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: foto
                .map((f) => GestureDetector(
                      onTap: () => Get.dialog(
                        Dialog(
                          insetPadding: const EdgeInsets.all(12),
                          child: InteractiveViewer(child: Image.network(teksDari(f['url']), fit: BoxFit.contain)),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          teksDari(f['url']),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: kSlate100, child: const Icon(Icons.broken_image_outlined, color: kSlate500)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}
