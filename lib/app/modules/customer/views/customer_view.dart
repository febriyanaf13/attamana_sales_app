import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../style/colors.dart';
import '../controllers/customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50 background
      appBar: AppBar(
        elevation: 0,
        title: Obx(
          () => controller.isSearchCustomer.isFalse
              ? const Text('Data Customer',
                  style: TextStyle(fontWeight: FontWeight.bold))
              : _buildModernSearchBar(),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.ADD_CUSTOMER),
            icon: const Icon(Icons.person_add_alt_1_rounded),
          ),
          IconButton(
            onPressed: () => controller.isSearchCustomer.toggle(),
            icon: Obx(() => Icon(controller.isSearchCustomer.isTrue
                ? Icons.close_rounded
                : Icons.search_rounded)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () async {
                controller.getCustomer();
              },
              child: Obx(
                () => controller.listCustomerSearch.isEmpty
                    ? const CustomLottieNotFound()
                    : ListView.separated(
                        itemCount: controller.listCustomerSearch.length,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildCustomerCard(index);
                        },
                      ),
              ),
            ),
          ),

          // Pagination Modern yang dimasukkan
          _buildPaginationSection(),
        ],
      ),
    );
  }

  // --- WIDGET PENCARIAN MODERN ---
  Widget _buildModernSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller.controllerSearch,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Cari nama atau korporat...',
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (value) {
          controller.curretPage.value = 1;
          controller.getCustomer();
        },
      ),
    );
  }

  // --- KARTU CUSTOMER MODERN ---
  Widget _buildCustomerCard(int index) {
    var isDetail = false.obs;
    final data = controller.listCustomerSearch[index];

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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.person_rounded,
                      color: kPrimaryColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        data.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B), // Slate 900
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.corporate ?? '-',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.phone_android_rounded,
                              size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            data.phone1,
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () =>
                          Get.toNamed(Routes.EDIT_CUSTOMER, arguments: index),
                      icon: const Icon(Icons.edit_note_rounded,
                          color: Colors.blue),
                    ),
                    Obx(() => IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => isDetail.toggle(),
                          icon: Icon(
                            isDetail.isTrue
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey.shade400,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          Obx(() => isDetail.isTrue
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC), // Slate 50
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Nama Perusahaan', data.companyName),
                      _buildDetailRow('Alamat', data.address),
                      _buildDetailRow('Kota', data.city),
                      _buildDetailRow('Negara', data.country),
                    ],
                  ),
                )
              : const SizedBox()),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Text(' :  ',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // --- MODIFIED PAGINATION SECTION ---
  Widget _buildPaginationSection() {
    return Obx(() {
      // Jangan tampilkan jika hanya ada 1 halaman
      if (controller.totalPages.value <= 1) return const SizedBox(height: 20);

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
                isEnabled: controller.curretPage.value > 1,
                onTap: () {
                  controller.curretPage.value--;
                  controller.getCustomer();
                },
              ),

              // Info Halaman (Tengah)
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
                      text: "${controller.curretPage.value} ",
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: "/ ${controller.totalPages.value}",
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
                isEnabled:
                    controller.curretPage.value < controller.totalPages.value,
                onTap: () {
                  controller.curretPage.value++;
                  controller.getCustomer();
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  // Helper untuk tombol navigasi yang rapi
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
}
