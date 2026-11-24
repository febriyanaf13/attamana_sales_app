import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_dialog.dart';
import '../../../services/notifikasi_service.dart';
import '../../../style/colors.dart';
import '../../notification/providers/notifikasi_provider.dart';
import '../../sales_module/shared/sales_ui.dart';

/// VERSI 51: Request Pendampingan activity — sama dengan menu web "kunjungan_assistance".
/// Pendamping menyetujui (APPROVE) atau menolak (REJECT, catatan wajib); sales peminta mendapat notifikasi.
class PendampinganView extends StatefulWidget {
  const PendampinganView({super.key});

  @override
  State<PendampinganView> createState() => _PendampinganViewState();
}

class _PendampinganViewState extends State<PendampinganView> {
  String status = 'REQUEST';
  bool loading = true;
  bool proses = false;
  String pesan = '';
  List<Map<String, dynamic>> data = [];
  final Set<int> dipilih = {};

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    setState(() {
      loading = true;
      dipilih.clear();
    });
    final r = await NotifikasiProvider().getPendampingan(status);
    if (!mounted) return;
    final body = r.body;
    setState(() {
      loading = false;
      if (r.status.isOk && body is Map && body['success'] == true) {
        data = (body['data'] is List ? body['data'] as List : []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        pesan = '';
      } else {
        data = [];
        pesan = body is Map
            ? '${body['message'] ?? body['status'] ?? 'Gagal memuat data'}'
            : 'Gagal memuat data, periksa koneksi internet.';
      }
    });
    if (Get.isRegistered<NotifikasiService>()) NotifikasiService.to.muatJumlah();
  }

  Future<void> _putuskan(List<int> ids, String keputusan) async {
    if (ids.isEmpty) return;
    final catatan = TextEditingController();
    final tolak = keputusan == 'REJECT';
    final ok = await Get.dialog<bool>(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(tolak ? 'Tolak pendampingan' : 'Setujui pendampingan',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${ids.length} activity dipilih.', style: const TextStyle(color: kSlate500, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            controller: catatan,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: tolak ? 'Alasan menolak (wajib)' : 'Catatan (opsional)',
              filled: true,
              fillColor: kSlate50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text('Batal')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: tolak ? kMerah : kHijau,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            if (tolak && catatan.text.trim().isEmpty) {
              Get.snackbar('Catatan wajib', 'Isi alasan menolak pendampingan.',
                  snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(12));
              return;
            }
            Get.back(result: true);
          },
          child: Text(tolak ? 'Tolak' : 'Setujui'),
        ),
      ],
    ));
    if (ok != true) return;
    setState(() => proses = true);
    final r = await NotifikasiProvider().putuskanPendampingan(ids, keputusan, catatan.text.trim());
    if (!mounted) return;
    setState(() => proses = false);
    final body = r.body;
    if (r.status.isOk && body is Map && intDari(body['berhasil']) > 0) {
      dialogSuccess('Berhasil', '${body['message']}');
    } else if (r.status.connectionError) {
      dialogError('Tidak ada koneksi', 'Jaringan internet bermasalah, silahkan cek koneksi internet!');
    } else {
      dialogWarning('Gagal', body is Map ? '${body['message'] ?? body['status'] ?? 'Gagal'}' : 'Gagal');
    }
    _muat();
  }

  @override
  Widget build(BuildContext context) {
    final menunggu = status == 'REQUEST';
    return Scaffold(
      backgroundColor: kSlate50,
      appBar: AppBar(
        title: const Text('Request Pendampingan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: menunggu && dipilih.isNotEmpty
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: kMerah,
                            side: const BorderSide(color: kMerah),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: proses ? null : () => _putuskan(dipilih.toList(), 'REJECT'),
                        icon: const Icon(Icons.close_rounded),
                        label: Text('Tolak (${dipilih.length})'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kHijau,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: proses ? null : () => _putuskan(dipilih.toList(), 'APPROVE'),
                        icon: const Icon(Icons.check_rounded),
                        label: Text('Setujui (${dipilih.length})'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          const SizedBox(height: 12),
          SalesFilterChips(
            pilihan: const {'REQUEST': 'Menunggu keputusan', 'RIWAYAT': 'Riwayat'},
            aktif: status,
            onPilih: (k) {
              if (k == status) return;
              status = k;
              _muat();
            },
          ),
          const SizedBox(height: 6),
          if (proses) const LinearProgressIndicator(color: kPrimaryColor, minHeight: 2),
          Expanded(
            child: RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: _muat,
              child: loading
                  ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
                  : data.isEmpty
                      ? SalesKosong(
                          judul: pesan.isNotEmpty ? 'Gagal memuat' : (menunggu ? 'Tidak ada permintaan' : 'Belum ada riwayat'),
                          pesan: pesan.isNotEmpty ? pesan : (menunggu ? 'Permintaan pendampingan dari sales lain akan muncul di sini.' : ''),
                          ikon: Icons.people_outline_rounded,
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                          itemCount: data.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) => _kartu(data[i], menunggu),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartu(Map<String, dynamic> k, bool menunggu) {
    final id = intDari(k['id']);
    final st = teksDari(k['status_pendampingan']);
    final pilih = dipilih.contains(id);
    final customer = teksDari(k['nama_customer']);
    return SalesCard(
      padding: const EdgeInsets.all(14),
      onTap: menunggu
          ? () => setState(() => pilih ? dipilih.remove(id) : dipilih.add(id))
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (menunggu)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Checkbox(
                value: pilih,
                activeColor: kPrimaryColor,
                onChanged: (v) => setState(() => v == true ? dipilih.add(id) : dipilih.remove(id)),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(customer.isNotEmpty ? customer : teksDari(k['lokasi']),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: kSlate900)),
                    ),
                    if (!menunggu)
                      SalesBadge(
                        teks: st == 'APPROVE' ? 'DISETUJUI' : 'DITOLAK',
                        warna: st == 'APPROVE' ? kHijau : kMerah,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                SalesInfoRow('Peminta', teksDari(k['peminta']), lebarLabel: 72),
                SalesInfoRow('Jadwal', fmtTanggal(teksDari(k['tgl_awal']), denganJam: true), lebarLabel: 72),
                SalesInfoRow('Jenis', teksDari(k['jenis']), lebarLabel: 72),
                if (teksDari(k['lokasi']).isNotEmpty)
                  SalesInfoRow('Lokasi', teksDari(k['lokasi']), lebarLabel: 72),
                if (teksDari(k['notulen']).isNotEmpty)
                  SalesInfoRow('Agenda', teksDari(k['notulen']), lebarLabel: 72),
                if (!menunggu && teksDari(k['catatan']).isNotEmpty)
                  SalesInfoRow('Catatan', teksDari(k['catatan']), lebarLabel: 72),
                if (menunggu) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: kMerah,
                              side: const BorderSide(color: kMerah),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: proses ? null : () => _putuskan([id], 'REJECT'),
                          child: const Text('Tolak'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kHijau,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: proses ? null : () => _putuskan([id], 'APPROVE'),
                          child: const Text('Setujui'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
