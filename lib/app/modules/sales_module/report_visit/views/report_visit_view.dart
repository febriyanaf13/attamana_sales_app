import 'package:attamana_salles_app/app/components/custom_lottie_loading.dart';
import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_datepicker_dialog.dart';
import '../../../../components/custom_dropdown_search.dart';
import '../../../../style/colors.dart';
import '../controllers/report_visit_controller.dart';

class ReportVisitView extends GetView<ReportVisitController> {
  const ReportVisitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Visit'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
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
                    10.width,
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
                10.height,
                controller.roles == 'SALES MANAGER'
                    ? Obx(() => CustomDropDownSearch(
                          controller: controller.textEditingControllerSales,
                          title: 'Sales',
                          labelSpace: true,
                          isRequired: true,
                          withTitle: true,
                          hint: 'Search sales...',
                          dataList: controller.listSales.value,
                          onSubmit: (value) {
                            print(value);
                          },
                          onSave: (value) {},
                          onSelectedItem: (value) {
                            controller.managerSalesId.value = value.item!;
                          },
                          validator: (x) {
                            if (controller.listSales
                                    .map((element) => element['text']
                                        ?.replaceAll(
                                            RegExp('[^A-Za-z0-9]'), ''))
                                    .where((value) => value!.contains(x!))
                                    .contains(x) ||
                                x!.isEmpty) {
                              return 'Please Enter a valid Data';
                            }

                            return null;
                          },
                        ))
                    : const SizedBox(),
                10.height,
                CustomButton(
                  onTap: () {
                    controller.postRequstListReportVisit();
                  },
                  text: 'Cari',
                  border: 30,
                  color: kAccentColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return Future<void>.delayed(
                  const Duration(seconds: 3),
                  () {
                    controller.postRequstListReportVisit();
                  },
                );
              },
              child: SingleChildScrollView(
                child: Obx(() => controller.isLoadingeportVisit.isTrue
                    ? const CustomLottieLoading()
                    : controller.listReportVisit.isEmpty
                        ? const CustomLottieNotFound()
                        // : ListView.separated(
                        //     itemCount: controller.listReportVisit.length,
                        //     padding: const EdgeInsets.all(20),
                        //     itemBuilder: (context, index) {
                        //       return Card(
                        //         child: Stack(
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(15),
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Row(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.start,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       Expanded(
                        //                         flex: 3,
                        //                         child: Column(
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.start,
                        //                           children: [
                        //                             Text(
                        //                               controller
                        //                                   .listReportVisit[
                        //                                       index]
                        //                                   .action,
                        //                               style: Get
                        //                                   .textTheme.titleMedium
                        //                                   ?.copyWith(
                        //                                       fontWeight:
                        //                                           FontWeight
                        //                                               .bold),
                        //                             ),
                        //                             5.height,
                        //                             Row(
                        //                               children: [
                        //                                 const Icon(
                        //                                   Icons.home_work,
                        //                                   color: grey,
                        //                                   size: 20,
                        //                                 ),
                        //                                 5.width,
                        //                                 Text(
                        //                                   controller
                        //                                       .listReportVisit[
                        //                                           index]
                        //                                       .namaCustomer,
                        //                                   style: Get.textTheme
                        //                                       .bodySmall,
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             Row(
                        //                               children: [
                        //                                 const Icon(
                        //                                   Icons
                        //                                       .location_on_rounded,
                        //                                   color: grey,
                        //                                   size: 20,
                        //                                 ),
                        //                                 5.width,
                        //                                 Text(
                        //                                   controller
                        //                                       .listReportVisit[
                        //                                           index]
                        //                                       .lokasi,
                        //                                   style: Get.textTheme
                        //                                       .bodySmall,
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             // Row(
                        //                             //   children: [
                        //                             //     const Icon(
                        //                             //       Icons.assignment_late_rounded,
                        //                             //       color: grey,
                        //                             //       size: 20,
                        //                             //     ),
                        //                             //     5.width,
                        //                             //     Text(
                        //                             //       controller
                        //                             //           .listReportVisit[index]
                        //                             //           .action,
                        //                             //       style: Get.textTheme.bodySmall,
                        //                             //     ),
                        //                             //   ],
                        //                             // ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       Container(
                        //                           padding:
                        //                               const EdgeInsets.all(5),
                        //                           decoration: BoxDecoration(
                        //                               color: Colors.grey,
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       5)),
                        //                           child: Text(
                        //                               '${controller.listReportVisit[index].ketcustomer}')),
                        //                     ],
                        //                   ),
                        //                   const Divider(
                        //                     thickness: 1,
                        //                   ),
                        //                   Text(
                        //                     'Desc : ${controller.listReportVisit[index].notulen}',
                        //                     style: Get.textTheme.bodySmall,
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             Positioned(
                        //               bottom: 0,
                        //               top: 0,
                        //               left: 0,
                        //               child: Container(
                        //                 width: 5,
                        //                 decoration: const BoxDecoration(
                        //                   color: kSecondaryColor,
                        //                   borderRadius: BorderRadius.horizontal(
                        //                     left: Radius.circular(10),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     },
                        //     separatorBuilder:
                        //         (BuildContext context, int index) {
                        //       return 10.height;
                        //     },
                        //   ),
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns: [
                                  const DataColumn(
                                    label: Text('NO'),
                                  ),
                                  const DataColumn(
                                    label: Text('LEAD ID'),
                                  ),
                                  const DataColumn(
                                    label: Text('COMPANY NAME'),
                                  ),
                                  const DataColumn(
                                    label: Text('NAMA HOTEL'),
                                  ),
                                  controller.roles == 'SALES MANAGER'
                                      ? const DataColumn(
                                          label: Text('NAMA SALES'),
                                        )
                                      : const DataColumn(label: SizedBox()),
                                  const DataColumn(
                                    label: Text('TGL'),
                                  ),
                                  const DataColumn(
                                    label: Text('KETERANGAN'),
                                  ),
                                  const DataColumn(
                                    label: Text('NOTULEN'),
                                  ),
                                  const DataColumn(
                                    label: Text('LOKASI'),
                                  ),
                                  const DataColumn(
                                    label: Text('STATUS'),
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      'FOTO',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const DataColumn(
                                    label: Text('WAKTU CHECKIN'),
                                  ),
                                  const DataColumn(
                                    label: Text('WAKTU CHECKIN'),
                                  ),
                                ],
                                rows: controller.listReportVisit.map((element) {
                                  var no = controller.listReportVisit
                                          .indexOf(element) +
                                      1;
                                  return DataRow(cells: [
                                    DataCell(Text('$no')),
                                    DataCell(Text(element.leadId ?? '-')),
                                    DataCell(
                                        Text(element.namaPerusahaan ?? '-')),
                                    DataCell(Text(element.namaHotel == ''
                                        ? element.lokasi!
                                        : element.namaHotel)),
                                    controller.roles == 'SALES MANAGER'
                                        ? DataCell(
                                            Text(element.namaSales ?? '-'))
                                        : const DataCell(SizedBox()),
                                    DataCell(Text(
                                        setTanggal(element.tanggalVisit!) ??
                                            '-')),
                                    DataCell(Text(element.action ?? '-')),
                                    DataCell(Text(element.notulen ?? '-')),
                                    DataCell(Text(element.lokasi ?? '-')),
                                    DataCell(Text(element.status ?? '-')),
                                    DataCell(element.foto == null ||
                                            element.foto == ''
                                        ? const Text('-')
                                        : IconButton(
                                            onPressed: () {
                                              Get.dialog(Dialog(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                      element.foto!,
                                                      fit: BoxFit.fitWidth,
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                    return Image.asset(
                                                        'no_image'.png);
                                                  }),
                                                ),
                                              ));
                                            },
                                            icon: const Icon(
                                              Icons.image,
                                              color: Colors.blue,
                                            ))),
                                    DataCell(
                                        Text('${element.waktuCheckin ?? '-'}')),
                                    DataCell(Text(
                                        '${element.waktuCheckout ?? '-'}')),
                                  ]);
                                }).toList()
                                // for(var data in )

                                ),
                          )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
