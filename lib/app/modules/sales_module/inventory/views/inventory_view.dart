import 'package:attamana_salles_app/app/components/custom_lottie_loading.dart';
import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/modules/sales_module/inventory/models/gudang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/custom_dropdown_search2.dart';
import '../../../../style/colors.dart';
import '../controllers/inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50 background
      appBar: AppBar(
        title: Obx(
          () => controller.isSearchInventory.isFalse
              ? const Text('Inventory',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
              : Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: controller.controllerSearch,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Cari nama produk...',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6), fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      prefixIcon: const Icon(Icons.search, size: 20),
                    ),
                    onChanged: (value) {
                      controller.page.value = 1;
                      controller.getListStockBarang(controller.gudangId.value);
                    },
                  ),
                ),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.isSearchInventory.toggle(),
            icon: Obx(() => Icon(controller.isSearchInventory.isTrue
                ? Icons.close_rounded
                : Icons.search_rounded)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // --- FILTER GUDANG ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Obx(
              () => CustomDropDownSearch<Gudang>(
                controller: controller.textEditingControllerGudang,
                title: 'Pilih Gudang',
                isRequired: true,
                withTitle: true,
                hint: 'Cari list gudang...',
                dataList: controller.listGudang,
                itemLabel: (item) => item.namaGudang,
                onSelectedItem: (Gudang? value) {
                  if (value != null) {
                    controller.gudangId.value = value.gudangId.toString();
                    controller.textEditingControllerGudang.text =
                        value.namaGudang;
                    controller.getListStockBarang(value.gudangId);
                  }
                },
                onSubmit: (_) {},
                onSave: (_) {},
                validator: (x) => null,
              ),
            ),
          ),

          // --- LIST STOCK BARANG ---
          Expanded(
            child: RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () async {
                controller.getListStockBarang(controller.gudangId.value);
              },
              child: Obx(
                () => controller.isLoadingListStockBarang.isTrue
                    ? const CustomLottieLoading()
                    : controller.listStockBarangSearch.isEmpty
                        ? const CustomLottieNotFound()
                        : ListView.separated(
                            itemCount: controller.listStockBarangSearch.length,
                            padding: const EdgeInsets.all(20),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) =>
                                _buildStockCard(index),
                          ),
              ),
            ),
          ),

          // --- PAGINATION (Opsi A) ---
          _buildPaginationSection(),
        ],
      ),
    );
  }

  // ============================================================
  // PAGINATION SECTION — gaya customer_view.dart
  // ============================================================
  Widget _buildPaginationSection() {
    return Obx(() {
      final totalPages = controller.numberPage.value;
      final currentPage = controller.page.value;

      if (totalPages <= 1) return const SizedBox(height: 8);

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E293B).withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol Previous
              _buildNavButton(
                icon: Icons.chevron_left_rounded,
                isEnabled: currentPage > 1,
                onTap: () {
                  controller.page.value = currentPage - 1;
                  controller.getListStockBarang(controller.gudangId.value);
                },
              ),

              // Info Halaman
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "HALAMAN",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      text: "$currentPage ",
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: "/ $totalPages",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Tombol Next
              _buildNavButton(
                icon: Icons.chevron_right_rounded,
                isEnabled: currentPage < totalPages,
                onTap: () {
                  controller.page.value = currentPage + 1;
                  controller.getListStockBarang(controller.gudangId.value);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 60,
          height: 65,
          child: Icon(
            icon,
            color: isEnabled ? kPrimaryColor : Colors.grey.shade200,
            size: 30,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STOCK CARD — REDESIGN
  // ============================================================
  Widget _buildStockCard(int index) {
    final item = controller.listStockBarangSearch[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon soft-square
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                color: kPrimaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Konten
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama produk
                  Text(
                    item.namaProduk,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Baris info: gudang + stok
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      // Chip gudang (soft abu)
                      _buildChip(
                        icon: Icons.home_work_rounded,
                        label: item.namaGudang,
                        bgColor: const Color(0xFFF1F5F9),
                        iconColor: const Color(0xFF64748B),
                        textColor: const Color(0xFF475569),
                      ),
                      // Chip stok (soft primary)
                      _buildChip(
                        icon: Icons.inventory_2_rounded,
                        label: '${item.jumlahStok} ${item.satuan}',
                        bgColor: kPrimaryColor.withOpacity(0.08),
                        iconColor: kPrimaryColor,
                        textColor: kPrimaryColor,
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper chip modern
  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
    bool isBold = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
