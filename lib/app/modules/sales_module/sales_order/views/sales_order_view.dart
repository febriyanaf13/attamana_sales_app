import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_lottie_not_found.dart';
import '../../../../style/colors.dart';
import '../../shared/sales_ui.dart';
import '../controllers/sales_order_controller.dart';
import '../models/so_tracking.dart';
import 'so_tracking_detail_view.dart';

/// Desain kartu & app bar mengikuti desain developer (6 Nov 2026).
/// VERSI 49 dipasang di atasnya: data dari API so_tracking (langsung tampil tanpa pilih tanggal),
/// filter tahap, posisi tahap + progress, cari langsung saat mengetik, muat bertahap saat di-scroll,
/// filter tanggal opsional, dan tombol ke detail tracking SO.
class SalesOrderView extends GetView<SalesOrderController> {
  const SalesOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50 background
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Sales Order',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Obx(() => Text(
                  '${fmtAngka(controller.total.value)} SO',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                )),
          ],
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            onPressed: showBottomSheetFilter,
            icon: Obx(() => Icon(
                controller.rangeTanggal.value.isEmpty
                    ? Icons.filter_list_rounded
                    : Icons.event_available_rounded,
                size: 28)),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Info Range Tanggal yang Aktif (ketuk untuk kembali ke semua tanggal)
                Obx(() => controller.rangeTanggal.value.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: InkWell(
                          onTap: controller.hapusTanggal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.rangeTanggal.value,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.close_rounded,
                                  size: 14, color: Colors.white70),
                            ],
                          ),
                        ),
                      )),
                // Search Bar Modern
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: TextFormField(
                    controller: controller.textEditingControllerSearch,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Cari No. SO atau Nama Customer...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                          fontStyle: FontStyle.italic),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: kPrimaryColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    // VERSI 49: cari langsung saat mengetik (jeda 450 ms)
                    onChanged: (value) => controller.kataCari.value = value,
                    onFieldSubmitted: (_) => controller.muatUlang(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 14),
          // VERSI 49: filter tahap tracking + jumlah SO per tahap
          Obx(() => SalesFilterChips(
                pilihan: SalesOrderController.filterTahap,
                aktif: controller.tahap.value,
                jumlah: controller.jumlahTahap.isEmpty
                    ? null
                    : Map<String, int>.from(controller.jumlahTahap),
                onPilih: controller.pilihTahap,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              )),
          Expanded(
            child: RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () async => controller.muatUlang(),
              child: Obx(() {
                if (controller.isLoadingSalesOrder.isTrue &&
                    controller.listSo.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor));
                }
                if (controller.listSo.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: Get.height * 0.08),
                      const CustomLottieNotFound(),
                    ],
                  );
                }
                final n = controller.listSo.length;
                return ListView.separated(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                  itemCount: n + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) => index == n
                      ? _footer()
                      : _buildSOCard(controller.listSo[index]),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Obx(() => controller.isLoadingMore.isTrue
        ? const Padding(
            padding: EdgeInsets.all(8),
            child: Center(
                child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: kPrimaryColor))),
          )
        : const SizedBox());
  }

  void _bukaDetail(SoTracking item) => Get.to(() =>
      SoTrackingDetailView(pesananId: item.pesananId, noSo: item.noTransaksi));

  // --- KARTU SO MODERN ---
  Widget _buildSOCard(SoTracking item) {
    var seeProduct = false.obs;
    final warna = warnaTahap(item.tahap);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            onTap: () => _bukaDetail(item),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: No SO & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NO. TRANSAKSI',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade400,
                                    letterSpacing: 1)),
                            const SizedBox(height: 2),
                            Text(item.noTransaksi,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                    fontSize: 15)),
                          ],
                        ),
                      ),
                      _buildStatusBadge(item.statusSo),
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1)),

                  // Customer Info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.business_center_rounded,
                            color: kPrimaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CUSTOMER',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey.shade400)),
                            Text(item.namaCustomer,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF475569))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(fmtRupiah(item.total),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // VERSI 49: posisi tahap SO (konfirmasi, produksi, siap kirim, dikirim, selesai)
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    decoration: BoxDecoration(
                      color: warna.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(ikonTahap(item.tahap), size: 18, color: warna),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(item.tahapLabel,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: warna)),
                            ),
                            if (item.tahap != 'BATAL')
                              Text('${item.tahapUrutan}/${item.tahapTotal}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade500)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SalesStepBar(
                            urutan: item.tahapUrutan,
                            total: item.tahapTotal,
                            warna: warna),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Timeline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDateInfo('TGL TRANSAKSI', item.tglTransaksi),
                      Icon(Icons.arrow_forward_rounded,
                          size: 16, color: Colors.grey.shade300),
                      _buildDateInfo('JATUH TEMPO', item.dueDate),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Action: See Product Toggle + Tracking
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => seeProduct.toggle(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Lihat Detail Produk',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor)),
                          const SizedBox(width: 4),
                          Obx(() => Icon(
                              seeProduct.isTrue
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: kPrimaryColor,
                              size: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 22, color: Colors.grey.shade200),
                Expanded(
                  child: InkWell(
                    onTap: () => _bukaDetail(item),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Lihat Tracking',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor)),
                          SizedBox(width: 2),
                          Icon(Icons.chevron_right_rounded,
                              color: kPrimaryColor, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detail Produk (Expanded Table)
          Obx(() => seeProduct.isTrue
              ? _buildProductTable(item.produk)
              : const SizedBox(height: 4)),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildStatusBadge(String status) {
    final Color warna = status == 'BATAL'
        ? kMerah
        : (status == 'BARU' || status.isEmpty)
            ? Colors.orange
            : kBiru;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.isEmpty ? '-' : status.toUpperCase(),
        style:
            TextStyle(color: warna, fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildDateInfo(String label, String tanggal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade400)),
        Text(tanggal.isEmpty ? '-' : fmtTanggal(tanggal),
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF1E293B))),
      ],
    );
  }

  Widget _buildProductTable(List<SoProduk> details) {
    const judul = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
    const isi = TextStyle(fontSize: 11);
    if (details.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Belum ada produk', style: TextStyle(fontSize: 12)),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 40,
          horizontalMargin: 10,
          columnSpacing: 20,
          columns: const [
            DataColumn(label: Text('PRODUCT', style: judul)),
            DataColumn(label: Text('PESANAN', style: judul)),
            DataColumn(label: Text('DIPRODUKSI', style: judul)),
            DataColumn(label: Text('SIAP KIRIM', style: judul)),
            DataColumn(label: Text('TERKIRIM', style: judul)),
            DataColumn(label: Text('OUTSTANDING', style: judul)),
          ],
          rows: details.map((d) {
            final double sisa = (d.qtyPesanan - d.qtyTerkirim) < 0
                ? 0.0
                : d.qtyPesanan - d.qtyTerkirim;
            return DataRow(cells: [
              DataCell(Text(
                  d.satuan.isEmpty
                      ? d.namaProduk
                      : '${d.namaProduk} (${d.satuan})',
                  style: isi)),
              DataCell(Center(child: Text(fmtAngka(d.qtyPesanan), style: isi))),
              DataCell(Center(
                  child: Text(fmtAngka(d.qtyHasilProduksi), style: isi))),
              DataCell(
                  Center(child: Text(fmtAngka(d.qtySiapKirim), style: isi))),
              DataCell(
                  Center(child: Text(fmtAngka(d.qtyTerkirim), style: isi))),
              DataCell(Center(
                  child: Text(fmtAngka(sisa),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: sisa > 0 ? Colors.red : kHijau)))),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void showBottomSheetFilter() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter Tanggal",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            Text('Kosongkan untuk menampilkan semua tanggal.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SalesDateField(
                    label: 'Mulai',
                    controller: controller.textEditingControllerTglFilterMulai,
                    bisaDikosongkan: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SalesDateField(
                    label: 'Selesai',
                    controller:
                        controller.textEditingControllerTglFilterSelesai,
                    bisaDikosongkan: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Obx(() => controller.isLoadingSalesOrder.isTrue
                ? const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor))
                : CustomButton(
                    onTap: () {
                      controller.terapkanTanggal();
                      Get.back();
                    },
                    text: 'TAMPILKAN DATA',
                    border: 15,
                    height: 55,
                    gradient: LinearGradient(
                        colors: [kPrimaryColor, const Color(0xFF1E3C72)]),
                  )),
            const SizedBox(height: 6),
            Center(
              child: TextButton(
                onPressed: () {
                  controller.hapusTanggal();
                  Get.back();
                },
                child: const Text('Tampilkan semua tanggal',
                    style: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
}
