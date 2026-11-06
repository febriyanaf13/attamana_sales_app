import 'package:attamana_salles_app/app/components/custom_lottie_loading.dart';
import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_datepicker_dialog.dart';
import '../../../../components/custom_dropdown_search2.dart';
import '../../../../style/colors.dart';
import '../../activity/models/existing_customer.dart';
import '../controllers/report_visit_controller.dart';
import '../models/sales.dart';

class ReportVisitView extends GetView<ReportVisitController> {
  const ReportVisitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Report Visit',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          // controller.exportReportVisitToPdf(controller.listReportVisit);
          controller.showExportPopup(context);
        },
        icon: const Icon(Icons.download_rounded, color: Colors.white),
        label: const Text(
          'Export',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ============================================================
            // FILTER CARD
            // ============================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E293B).withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.filter_alt_rounded,
                              color: kPrimaryColor, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Filter',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Row tanggal
                    Row(
                      children: [
                        Expanded(
                          child: CustomDateTimePickerDialog(
                            title: 'Mulai',
                            onDataChange: (value) {
                              if (value != null) {
                                controller.tglMulai.value = value;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pilih tanggal...!';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomDateTimePickerDialog(
                            title: 'Selesai',
                            onDataChange: (value) {
                              if (value != null) {
                                controller.tglSelesai.value = value;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pilih tanggal...!';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dropdown sales/customer
                    controller.roles == 'SALES MANAGER'
                        ? Obx(
                            () => Column(
                              children: [
                                CustomDropDownSearch<Sales>(
                                  controller:
                                      controller.textEditingControllerSales,
                                  title: 'Sales',
                                  labelSpace: true,
                                  isRequired: true,
                                  withTitle: true,
                                  hint: 'Search sales...',
                                  dataList: controller.listSales.value,
                                  itemLabel: (Sales sales) => sales.nama,
                                  onSubmit: (value) {
                                    print(value);
                                  },
                                  onSave: (value) {},
                                  onSelectedItem: (Sales? value) {
                                    if (value != null) {
                                      controller.managerSalesId.value =
                                          value.pegawaiId.toString();
                                      controller.textEditingControllerSales
                                          .text = value.nama;
                                    }
                                  },
                                  validator: (x) {
                                    if (x == null || x.isEmpty)
                                      return 'Please enter a valid data';
                                    if (!controller.listSales
                                        .map((e) => e.nama)
                                        .contains(x))
                                      return 'Please enter a valid data';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                CustomDropDownSearch<ExistingCustomer>(
                                  controller:
                                      controller.textEditingControllerCustomer,
                                  title: 'Existing Customer Name',
                                  labelSpace: true,
                                  isRequired: true,
                                  withTitle: true,
                                  hint: 'Search existing customer...',
                                  dataList: controller.listExistingCustomer,
                                  onSubmit: (value) {
                                    print(value);
                                  },
                                  onSave: (value) {},
                                  onSelectedItem: (value) {
                                    print(
                                        "ini test espac : ${value?.customerId}");
                                    controller.customerId.value =
                                        value!.customerId.toString();
                                  },
                                  validator: (x) {
                                    if (x == null || x.trim().isEmpty) {
                                      return 'Please enter a valid data';
                                    }
                                    return null;
                                  },
                                  itemLabel: (item) => item.namaHotel,
                                ),
                              ],
                            ),
                          )
                        : CustomDropDownSearch<ExistingCustomer>(
                            controller:
                                controller.textEditingControllerCustomer,
                            title: 'Existing Customer Name',
                            labelSpace: true,
                            isRequired: true,
                            withTitle: true,
                            hint: 'Search existing customer...',
                            dataList: controller.listExistingCustomer,
                            onSubmit: (value) {
                              print(value);
                            },
                            onSave: (value) {},
                            onSelectedItem: (value) {
                              print("ini test espac : ${value?.customerId}");
                              controller.customerId.value =
                                  value!.customerId.toString();
                            },
                            validator: (x) {
                              if (x == null || x.trim().isEmpty) {
                                return 'Please enter a valid data';
                              }
                              return null;
                            },
                            itemLabel: (item) => item.namaHotel,
                          ),
                    const SizedBox(height: 12),

                    // Tombol Cari
                    Obx(() => controller.isLoadingeportVisit.isTrue
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: CircularProgressIndicator(
                                  color: kPrimaryColor),
                            ),
                          )
                        : CustomButton(
                            onTap: () {
                              controller.postRequstListReportVisit();
                            },
                            text: 'TAMPILKAN DATA',
                            border: 15,
                            height: 55,
                            gradient: LinearGradient(colors: [
                              kPrimaryColor,
                              const Color(0xFF1E3C72),
                            ]),
                          )),
                  ],
                ),
              ),
            ),

            // ============================================================
            // HASIL REPORT
            // ============================================================
            RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () {
                return Future<void>.delayed(
                  const Duration(seconds: 3),
                  () {
                    controller.postRequstListReportVisit();
                  },
                );
              },
              child: SingleChildScrollView(
                child: Obx(
                  () => controller.isLoadingeportVisit.isTrue
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: CustomLottieLoading(),
                        )
                      : controller.listReportVisit.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 60),
                              child: CustomLottieNotFound(),
                            )
                          : _buildDataTable(context),
                ),
              ),
            ),
            const SizedBox(height: 80), // FAB spacing
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DATA TABLE — redesign dengan card + styling
  // ============================================================
  Widget _buildDataTable(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: kPrimaryColor.withOpacity(0.06),
                child: Row(
                  children: [
                    Icon(Icons.table_chart_rounded,
                        size: 16, color: kPrimaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Data Report Visit',
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${controller.listReportVisit.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Horizontal scroll untuk DataTable
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 44,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 72,
                  columnSpacing: 20,
                  horizontalMargin: 16,
                  headingRowColor:
                      WidgetStateProperty.all(kPrimaryColor.withOpacity(0.04)),
                  columns: [
                    _buildColumn('NO'),
                    _buildColumn('COMPANY NAME'),
                    _buildColumn('NAMA HOTEL'),
                    if (controller.roles == 'SALES MANAGER')
                      _buildColumn('NAMA SALES'),
                    _buildColumn('TGL'),
                    _buildColumn('KETERANGAN'),
                    _buildColumn('NOTULEN'),
                    _buildColumn('LOKASI'),
                    _buildColumn('STATUS'),
                    _buildColumn('FOTO', center: true),
                    _buildColumn('CHECK-IN'),
                    _buildColumn('CHECK-OUT'),
                  ],
                  rows: controller.listReportVisit.map((element) {
                    var no = controller.listReportVisit.indexOf(element) + 1;
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          '$no',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        )),
                        DataCell(_buildTextCell(element.namaPerusahaan ?? '-',
                            maxWidth: 160)),
                        DataCell(_buildTextCell(
                          element.namaHotel == ''
                              ? element.lokasi ?? '-'
                              : element.namaHotel,
                          maxWidth: 160,
                          bold: true,
                        )),
                        if (controller.roles == 'SALES MANAGER')
                          DataCell(_buildTextCell(element.namaSales ?? '-',
                              maxWidth: 120)),
                        DataCell(_buildTextCell(
                          setTanggal(element.tanggalVisit!) ?? '-',
                          maxWidth: 100,
                        )),
                        DataCell(_buildTextCell(element.action ?? '-',
                            maxWidth: 150)),
                        DataCell(_buildTextCell(element.notulen ?? '-',
                            maxWidth: 180)),
                        DataCell(_buildTextCell(element.lokasi ?? '-',
                            maxWidth: 140)),
                        DataCell(_buildStatusChip(element.status)),
                        DataCell(
                          element.foto == null || element.foto == ''
                              ? const Center(
                                  child: Text('-',
                                      style: TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 12)))
                              : Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Get.dialog(Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Image.network(
                                              element.foto!,
                                              fit: BoxFit.fitWidth,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                    'no_image'.png);
                                              },
                                            ),
                                          ),
                                        ));
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.image_rounded,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        DataCell(_buildTextCell(
                            '${element.waktuCheckin ?? '-'}',
                            maxWidth: 100)),
                        DataCell(_buildTextCell(
                            '${element.waktuCheckout ?? '-'}',
                            maxWidth: 100)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: header kolom
  DataColumn _buildColumn(String label, {bool center = false}) {
    return DataColumn(
      label: Text(
        label,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF475569),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Helper: cell text
  Widget _buildTextCell(String text,
      {double maxWidth = 150, bool bold = false}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: const Color(0xFF334155),
        ),
      ),
    );
  }

  // Helper: chip status berwarna
  Widget _buildStatusChip(String? status) {
    final s = (status ?? '').toLowerCase();
    Color bg;
    Color fg;
    if (s.contains('done') || s.contains('selesai') || s.contains('success')) {
      bg = const Color(0xFF10B981).withOpacity(0.1);
      fg = const Color(0xFF059669);
    } else if (s.contains('pending') ||
        s.contains('proses') ||
        s.contains('progress')) {
      bg = const Color(0xFFF59E0B).withOpacity(0.12);
      fg = const Color(0xFFB45309);
    } else if (s.contains('cancel') ||
        s.contains('batal') ||
        s.contains('reject') ||
        s.contains('fail')) {
      bg = const Color(0xFFEF4444).withOpacity(0.1);
      fg = const Color(0xFFDC2626);
    } else {
      bg = const Color(0xFF64748B).withOpacity(0.1);
      fg = const Color(0xFF475569);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status ?? '-',
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
