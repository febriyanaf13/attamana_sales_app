import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_datepicker_dialog.dart';
import '../../../../components/custom_lottie_not_found.dart';
import '../../../../style/colors.dart';
import '../controllers/sales_order_controller.dart';

class SalesOrderView extends GetView<SalesOrderController> {
  const SalesOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50 background
      appBar: AppBar(
        title: const Text(
          'Sales Order',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            icon: const Icon(Icons.filter_list_rounded, size: 28),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                // Info Range Tanggal yang Aktif
                Obx(() => controller.rangeTanggal.value.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          controller.rangeTanggal.value,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
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
                    onFieldSubmitted: (value) =>
                        controller.getlistSalesOrderSearch(value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: () async {
          controller.reqPostSalesOrder();
          controller.textEditingControllerTglFilterMulai.clear();
          controller.textEditingControllerTglFilterSelesai.clear();
          controller.rangeTanggal.value = '';
        },
        child: Obx(
          () => controller.isLoadingSalesOrder.isTrue
              ? const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor))
              : controller.listSalesOrderSearch.isEmpty
                  ? const CustomLottieNotFound()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      itemCount: controller.listSalesOrderSearch.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) => _buildSOCard(index),
                    ),
        ),
      ),
    );
  }

  // --- KARTU SO MODERN ---
  Widget _buildSOCard(int index) {
    var seeProduct = false.obs;
    final item = controller.listSalesOrderSearch[index];

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: No SO & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NO. TRANSAKSI',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey.shade400,
                                letterSpacing: 1)),
                        const SizedBox(height: 2),
                        Text(item.noTransaksi.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                                fontSize: 15)),
                      ],
                    ),
                    _buildStatusBadge(item.status.toString()),
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
                          Text(item.namaCustomer.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF475569))),
                        ],
                      ),
                    ),
                  ],
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

          // Action: See Product Toggle
          InkWell(
            onTap: () => seeProduct.toggle(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lihat Detail Produk',
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

          // Detail Produk (Expanded Table)
          Obx(() => seeProduct.isTrue
              ? _buildProductTable(item.detail)
              : const SizedBox()),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
            color: Colors.orange, fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade400)),
        Text(DateFormat("dd MMM yyyy").format(date),
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF1E293B))),
      ],
    );
  }

  Widget _buildProductTable(List<dynamic> details) {
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
            DataColumn(
                label: Text('PRODUCT',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('REQUEST',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('IN PROGRESS',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('DONE',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('DELIVERED',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('OUTSTANDING',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          ],
          rows: details
              .map((d) => DataRow(cells: [
                    DataCell(Text(d.namaProduk.toString(),
                        style: const TextStyle(fontSize: 11))),
                    DataCell(Center(
                        child: Text(d.request.toString(),
                            style: const TextStyle(fontSize: 11)))),
                    DataCell(Center(
                        child: Text(d.inProgress.toString(),
                            style: const TextStyle(fontSize: 11)))),
                    DataCell(Center(
                        child: Text(d.done.toString(),
                            style: const TextStyle(fontSize: 11)))),
                    DataCell(Center(
                        child: Text(d.delivered.toString(),
                            style: const TextStyle(fontSize: 11)))),
                    DataCell(Center(
                        child: Text(d.outstanding.toString(),
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)))),
                  ]))
              .toList(),
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomDateTimePickerDialog(
                    title: 'Mulai',
                    setDateValue:
                        controller.textEditingControllerTglFilterMulai.text,
                    onDataChange: (value) => controller
                        .textEditingControllerTglFilterMulai.text = value ?? '',
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDateTimePickerDialog(
                    title: 'Selesai',
                    setDateValue:
                        controller.textEditingControllerTglFilterSelesai.text,
                    onDataChange: (value) => controller
                        .textEditingControllerTglFilterSelesai
                        .text = value ?? '',
                    isRequired: true,
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
                      controller.reqPostSalesOrder();
                      Get.back();
                    },
                    text: 'TAMPILKAN DATA',
                    border: 15,
                    height: 55,
                    gradient: LinearGradient(
                        colors: [kPrimaryColor, const Color(0xFF1E3C72)]),
                  )),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
}
