import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/notifikasi_service.dart';
import '../../../style/colors.dart';
import '../../pendampingan/views/pendampingan_view.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../controllers/notification_controller.dart';

/// VERSI 51: daftar notifikasi (isi sama dengan lonceng di web).
class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  static IconData ikon(String kategori, String tipe) {
    if (tipe == 'SO_SIAP_KIRIM') return Icons.local_shipping_rounded;
    if (tipe == 'SO_DITOLAK' || tipe == 'SO_BATAL') return Icons.report_gmailerrorred_rounded;
    if (tipe.startsWith('SLA')) return Icons.alarm_rounded;
    switch (kategori) {
      case 'SO':
        return Icons.receipt_long_rounded;
      case 'PENDAMPINGAN':
        return Icons.people_alt_rounded;
      case 'ACTIVITY':
        return Icons.event_note_rounded;
      case 'SAMPLE':
        return Icons.science_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  static Color warna(String tipe, String kategori) {
    if (tipe == 'SO_DITOLAK' || tipe == 'SO_BATAL' || tipe.contains('DITOLAK')) return kMerah;
    if (tipe == 'SO_DISETUJUI' || tipe == 'SO_SIAP_KIRIM') return kHijau;
    if (tipe.startsWith('SLA') || tipe.startsWith('ESKALASI')) return kOranye;
    if (kategori == 'PENDAMPINGAN') return kUngu;
    return kBiru;
  }

  @override
  Widget build(BuildContext context) {
    final svc = Get.isRegistered<NotifikasiService>() ? NotifikasiService.to : null;
    return Scaffold(
      backgroundColor: kSlate50,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            if (svc != null)
              Obx(() => Text(
                  svc.jumlahBelum.value > 0 ? '${fmtAngka(svc.jumlahBelum.value)} belum dibaca' : 'Semua sudah dibaca',
                  style: const TextStyle(fontSize: 11.5, color: Colors.white70))),
          ],
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Tandai semua dibaca',
            onPressed: controller.bacaSemua,
            icon: const Icon(Icons.done_all_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // permintaan pendampingan yang menunggu keputusan user ini
          if (svc != null)
            Obx(() => svc.pendampinganMenunggu.value > 0
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: SalesCard(
                      padding: const EdgeInsets.all(14),
                      onTap: () async {
                        await Get.to(() => const PendampinganView());
                        controller.muatUlang();
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: kUngu.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.people_alt_rounded, color: kUngu),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${svc.pendampinganMenunggu.value} permintaan pendampingan',
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: kSlate900)),
                                const Text('Menunggu persetujuan Anda', style: TextStyle(fontSize: 12, color: kSlate500)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: kSlate500),
                        ],
                      ),
                    ),
                  )
                : const SizedBox()),
          const SizedBox(height: 12),
          Obx(() => SalesFilterChips(
                pilihan: NotificationController.filterKategori,
                aktif: controller.filter.value,
                onPilih: controller.pilihFilter,
              )),
          const SizedBox(height: 6),
          Expanded(
            child: RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () async => controller.muatUlang(),
              child: Obx(() {
                if (controller.isLoading.isTrue && controller.list.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
                }
                if (controller.list.isEmpty) {
                  return const SalesKosong(
                    judul: 'Belum ada notifikasi',
                    pesan: 'Perubahan status sales order, pendampingan activity, sample & pengingat akan muncul di sini.',
                    ikon: Icons.notifications_none_rounded,
                  );
                }
                final n = controller.list.length;
                return ListView.separated(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  itemCount: n + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    if (i == n) {
                      return Obx(() => controller.isLoadingMore.isTrue
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2.5, color: kPrimaryColor)),
                            )
                          : const SizedBox(height: 8));
                    }
                    return _NotifCard(n: controller.list[i], onTap: controller.buka);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.n, required this.onTap});

  final NotifikasiItem n;
  final void Function(NotifikasiItem) onTap;

  @override
  Widget build(BuildContext context) {
    final w = NotificationView.warna(n.tipe, n.kategori);
    return SalesCard(
      padding: const EdgeInsets.all(14),
      onTap: () => onTap(n),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: w.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(NotificationView.ikon(n.kategori, n.tipe), color: w, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(n.judul,
                          style: TextStyle(
                              fontSize: 13.5,
                              color: kSlate900,
                              fontWeight: n.dibaca ? FontWeight.w600 : FontWeight.w900)),
                    ),
                    if (!n.dibaca)
                      Container(
                        margin: const EdgeInsets.only(left: 6, top: 4),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: kMerah, shape: BoxShape.circle),
                      ),
                  ],
                ),
                if (n.isi.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(n.isi, maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, color: kSlate700)),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(fmtTanggal(n.waktu, denganJam: true), style: const TextStyle(fontSize: 11, color: kSlate500)),
                    const Spacer(),
                    if (n.halaman.isNotEmpty)
                      const Text('Lihat', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: kPrimaryColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
