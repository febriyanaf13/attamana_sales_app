import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../style/colors.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../controllers/sample_and_pricing_controller.dart';
import '../controllers/sample_form_controller.dart';
import '../models/sample.dart';
import 'sample_detail_view.dart';
import 'sample_form_view.dart';

/// VERSI 49: Sample & Pricing — list milik sales + monitoring status.
/// Input & edit dari aplikasi; approval, R&D, pricing dan pengiriman sample tetap di web.
class SampleAndPricingView extends GetView<SampleAndPricingController> {
  const SampleAndPricingView({Key? key}) : super(key: key);

  static Future<void> bukaForm({int? sampleId}) async {
    final hasil = await Get.to<bool>(
      () => const SampleFormView(),
      binding: BindingsBuilder(
          () => Get.put(SampleFormController(sampleId: sampleId))),
    );
    if (hasil == true && Get.isRegistered<SampleAndPricingController>()) {
      Get.find<SampleAndPricingController>().muatUlang();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSlate50,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Sample & Pricing',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Obx(() => Text('${fmtAngka(controller.total.value)} sample',
                style: const TextStyle(fontSize: 11.5, color: Colors.white70))),
          ],
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(66),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: SalesSearchBox(
              controller: controller.controllerCari,
              hint: 'Cari kode, hotel, kota, tipe barang...',
              onChanged: (v) => controller.kataCari.value = v,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        onPressed: () => bukaForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Sample baru',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Obx(() => SalesFilterChips(
                pilihan: SampleAndPricingController.filterStatus,
                aktif: controller.status.value,
                onPilih: controller.pilihStatus,
              )),
          const SizedBox(height: 6),
          Expanded(
            child: RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () async => controller.muatUlang(),
              child: Obx(() {
                if (controller.isLoading.isTrue && controller.list.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor));
                }
                if (controller.list.isEmpty) {
                  return const SalesKosong(
                    judul: 'Belum ada sample',
                    pesan:
                        'Tekan "Sample baru" untuk mengajukan sample & pricing.',
                    ikon: Icons.science_outlined,
                  );
                }
                final n = controller.list.length;
                return ListView.separated(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: n + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    if (i == n) {
                      return Obx(() => controller.isLoadingMore.isTrue
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5, color: kPrimaryColor)),
                            )
                          : const SizedBox(height: 8));
                    }
                    return _SampleCard(s: controller.list[i]);
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

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.s});

  final SampleItem s;

  @override
  Widget build(BuildContext context) {
    final w = warnaStatusSample(s.statusKode);
    return SalesCard(
      onTap: () async {
        final ubah = await Get.to<bool>(
            () => SampleDetailView(sampleId: s.sampleId, kode: s.kodeSample));
        if (ubah == true) Get.find<SampleAndPricingController>().muatUlang();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              height: 64,
              color: w.withOpacity(0.10),
              child: s.foto.isEmpty
                  ? Icon(ikonStatusSample(s.statusKode), color: w, size: 28)
                  : Image.network(
                      s.foto,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                          ikonStatusSample(s.statusKode),
                          color: w,
                          size: 28),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(s.kodeSample,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: kSlate500,
                              letterSpacing: 0.3)),
                    ),
                    Text(fmtTanggal(s.tanggal),
                        style: const TextStyle(fontSize: 11, color: kSlate500)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(s.namaHotel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: kSlate900)),
                const SizedBox(height: 2),
                Text(
                    [s.tipeBarang, s.kota]
                        .where((e) => e.isNotEmpty)
                        .join(' • '),
                    style: const TextStyle(
                        fontSize: 12,
                        color: kSlate500,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                        child: SalesBadge(
                            teks: s.statusLabel,
                            warna: w,
                            ikon: ikonStatusSample(s.statusKode))),
                    if (s.bolehEdit) ...[
                      const SizedBox(width: 6),
                      const SalesBadge(
                          teks: 'Bisa diedit',
                          warna: kSlate500,
                          ikon: Icons.edit_rounded),
                    ],
                  ],
                ),
                if (s.statusKode == 'PROSES' || s.progres > 0) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (s.progres / 100).clamp(0.0, 1.0).toDouble(),
                      minHeight: 5,
                      backgroundColor: kSlate100,
                      valueColor: AlwaysStoppedAnimation<Color>(w),
                    ),
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
