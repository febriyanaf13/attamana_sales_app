import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../style/colors.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/string.dart';
import '../../shared/sales_ui.dart';
import '../models/so_tracking.dart';
import '../providers/sales_order_provider.dart';

/// VERSI 49: detail tracking 1 sales order — timeline, per produk, per rencana kirim (WO, jadwal, faktur, DO).
class SoTrackingDetailView extends StatefulWidget {
  const SoTrackingDetailView({super.key, required this.pesananId, this.noSo = ''});

  final int pesananId;
  final String noSo;

  @override
  State<SoTrackingDetailView> createState() => _SoTrackingDetailViewState();
}

class _SoTrackingDetailViewState extends State<SoTrackingDetailView> {
  Map<String, dynamic>? data;
  bool loading = true;
  String pesan = '';

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    setState(() {
      loading = true;
      pesan = '';
    });
    final r = await SalesOrderProvider().getSoTrackingDetail(widget.pesananId, '${storage.read(kUserId)}');
    if (!mounted) return;
    final body = r.body;
    setState(() {
      loading = false;
      if (r.status.isOk && body is Map && body['success'] == true) {
        data = Map<String, dynamic>.from(body['data']);
      } else {
        pesan = body is Map ? '${body['message'] ?? 'Gagal memuat data'}' : 'Gagal memuat data, periksa koneksi internet.';
      }
    });
  }

  List<Map<String, dynamic>> _list(dynamic v) =>
      v is List ? v.map((e) => Map<String, dynamic>.from(e as Map)).toList() : <Map<String, dynamic>>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSlate50,
      appBar: AppBar(
        title: Text(widget.noSo.isEmpty ? 'Detail SO' : widget.noSo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: _muat,
        child: loading
            ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
            : data == null
                ? SalesKosong(judul: 'Data tidak dapat dimuat', pesan: pesan, ikon: Icons.cloud_off_rounded)
                : _isi(data!),
      ),
    );
  }

  Widget _isi(Map<String, dynamic> d) {
    final tahap = teksDari(d['tahap']);
    final warna = warnaTahap(tahap);
    final produk = _list(d['produk']).map((e) => SoProduk.fromJson(e)).toList();
    final plan = _list(d['rencana_kirim']);
    final timeline = _list(d['timeline']);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        // ------------------------------------------------ ringkasan
        SalesCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(teksDari(d['nama_customer']),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: kSlate900)),
                  ),
                  SalesBadge(teks: teksDari(d['status_so']), warna: kBiru),
                ],
              ),
              const SizedBox(height: 4),
              Text('${teksDari(d['no_transaksi'])}  •  ${fmtRupiah(angkaDari(d['total']))}',
                  style: const TextStyle(fontSize: 12.5, color: kSlate500, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: warna.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(ikonTahap(tahap), color: warna, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(teksDari(d['tahap_label']),
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: warna)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SalesStepBar(urutan: intDari(d['tahap_urutan']), total: intDari(d['tahap_total']), warna: warna),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SalesInfoRow('Tanggal SO', fmtTanggal(teksDari(d['tgl_transaksi']))),
              SalesInfoRow('Jatuh tempo', fmtTanggal(teksDari(d['due_date']))),
              SalesInfoRow('No. PO pelanggan', teksDari(d['ref_no'])),
              SalesInfoRow('Verifikasi CS', teksDari(d['status_verifikasi'])),
              if (teksDari(d['catatan_kelengkapan']).isNotEmpty) SalesInfoRow('Catatan CS', teksDari(d['catatan_kelengkapan'])),
            ],
          ),
        ),

        // ------------------------------------------------ timeline
        const SalesSectionTitle('Perjalanan sales order', ikon: Icons.timeline_rounded),
        SalesCard(
          child: Column(
            children: List.generate(timeline.length, (i) {
              final t = timeline[i];
              final selesai = boolDari(t['selesai']);
              final terakhir = i == timeline.length - 1;
              final batal = teksDari(t['kode']) == 'BATAL';
              final w = batal ? kMerah : (selesai ? kHijau : Colors.grey.shade300);
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 26,
                      child: Column(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(color: selesai ? w : Colors.white, shape: BoxShape.circle, border: Border.all(color: w, width: 2)),
                            child: selesai ? Icon(batal ? Icons.close : Icons.check, size: 12, color: Colors.white) : null,
                          ),
                          if (!terakhir) Expanded(child: Container(width: 2, color: selesai ? kHijau.withOpacity(0.5) : Colors.grey.shade200)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: terakhir ? 0 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(teksDari(t['label']),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: selesai ? FontWeight.w800 : FontWeight.w600,
                                    color: selesai ? kSlate900 : kSlate500)),
                            if (teksDari(t['waktu']).isNotEmpty)
                              Text(fmtTanggal(teksDari(t['waktu']), denganJam: true),
                                  style: const TextStyle(fontSize: 11.5, color: kSlate500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        // ------------------------------------------------ per produk
        if (produk.isNotEmpty) ...[
          const SalesSectionTitle('Progres per produk', ikon: Icons.inventory_2_outlined),
          ...produk.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SalesCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.namaProduk, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: kSlate900)),
                      const SizedBox(height: 2),
                      Text('Pesanan ${fmtAngka(p.qtyPesanan)} ${p.satuan}', style: const TextStyle(fontSize: 12, color: kSlate500)),
                      const SizedBox(height: 8),
                      SalesQtyBar(label: 'Rencana kirim', nilai: p.qtyRencanaKirim, total: p.qtyPesanan, warna: kOranye, satuan: p.satuan),
                      SalesQtyBar(label: 'Hasil produksi', nilai: p.qtyHasilProduksi, total: p.qtyPesanan, warna: kBiru, satuan: p.satuan),
                      SalesQtyBar(label: 'Siap kirim (terbooking)', nilai: p.qtySiapKirim, total: p.qtyPesanan, warna: const Color(0xFF0D9488), satuan: p.satuan),
                      SalesQtyBar(label: 'Sudah difaktur', nilai: p.qtyDifaktur, total: p.qtyPesanan, warna: kUngu, satuan: p.satuan),
                      SalesQtyBar(label: 'Terkirim', nilai: p.qtyTerkirim, total: p.qtyPesanan, warna: kHijau, satuan: p.satuan),
                    ],
                  ),
                ),
              )),
        ],

        // ------------------------------------------------ per rencana kirim
        const SalesSectionTitle('Rencana kirim', ikon: Icons.local_shipping_outlined),
        if (plan.isEmpty)
          const SalesCard(
            child: Text('Rencana kirim belum diisi Customer Service.', style: TextStyle(fontSize: 12.5, color: kSlate500)),
          ),
        ...plan.map((p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _PlanCard(p: p, list: _list))),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.p, required this.list});

  final Map<String, dynamic> p;
  final List<Map<String, dynamic>> Function(dynamic) list;

  @override
  Widget build(BuildContext context) {
    final status = teksDari(p['status']);
    final w = warnaStatusPlan(status);
    final satuan = teksDari(p['satuan']);
    final rencana = angkaDari(p['qty_rencana_kirim']);
    final wo = list(p['work_order']);
    final jadwal = list(p['jadwal_produksi']);
    final faktur = list(p['faktur']);
    final dos = list(p['delivery_order']);

    Widget baris(IconData ikon, String judul, List<String> isi) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(ikon, size: 16, color: kSlate500),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(judul, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kSlate500)),
                    ...isi.map((t) => Text(t, style: const TextStyle(fontSize: 12.5, color: kSlate900, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
            ],
          ),
        );

    return SalesCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(teksDari(p['nama_produk']), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: kSlate900)),
                    const SizedBox(height: 2),
                    Text('Kirim ${fmtTanggal(teksDari(p['tanggal_kirim']))}  •  ${fmtAngka(rencana)} $satuan'
                        '${teksDari(p['kategori']).isEmpty ? '' : '  •  ${teksDari(p['kategori'])}'}',
                        style: const TextStyle(fontSize: 12, color: kSlate500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SalesBadge(teks: teksDari(p['status_label']).isEmpty ? status : teksDari(p['status_label']), warna: w, ikon: Icons.flag_rounded),
          const SizedBox(height: 6),
          SalesQtyBar(label: 'Hasil produksi', nilai: angkaDari(p['qty_hasil_produksi']), total: rencana, warna: kBiru, satuan: satuan),
          SalesQtyBar(label: 'Siap kirim', nilai: angkaDari(p['qty_siap_kirim']), total: rencana, warna: const Color(0xFF0D9488), satuan: satuan),
          SalesQtyBar(label: 'Terkirim', nilai: angkaDari(p['qty_terkirim']), total: rencana, warna: kHijau, satuan: satuan),
          if (wo.isNotEmpty)
            baris(Icons.assignment_outlined, 'WORK ORDER', wo.map((x) => '${teksDari(x['wo_number'])} — ${teksDari(x['status'])}').toList()),
          if (jadwal.isNotEmpty)
            baris(
                Icons.precision_manufacturing_outlined,
                'JADWAL PRODUKSI',
                jadwal
                    .map((x) => '${teksDari(x['kode'])} — ${teksDari(x['status'])}'
                        '${teksDari(x['mulai']).isEmpty ? '' : ' (${fmtTanggal(teksDari(x['mulai']))})'}')
                    .toList()),
          if (faktur.isNotEmpty)
            baris(Icons.receipt_long_outlined, 'FAKTUR',
                faktur.map((x) => '${teksDari(x['no_faktur'])} — ${fmtTanggal(teksDari(x['tanggal']))}').toList()),
          if (dos.isNotEmpty)
            baris(
                Icons.local_shipping_outlined,
                'DELIVERY ORDER',
                dos.map((x) {
                  final st = teksDari(x['status']);
                  final diterima = teksDari(x['diterima']);
                  final resi = teksDari(x['nomor_resi']);
                  return '${teksDari(x['no_do'])} — $st'
                      '${diterima.isEmpty ? '' : ', diterima ${fmtTanggal(diterima)}${teksDari(x['penerima']).isEmpty ? '' : ' oleh ${teksDari(x['penerima'])}'}'}'
                      '${resi.isEmpty ? '' : ', resi $resi'}';
                }).toList()),
          if (wo.isEmpty && jadwal.isEmpty && faktur.isEmpty && dos.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Belum ada work order, faktur maupun pengiriman.', style: TextStyle(fontSize: 12, color: kSlate500)),
            ),
        ],
      ),
    );
  }
}
