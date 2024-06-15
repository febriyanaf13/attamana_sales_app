import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../style/colors.dart';
import '../controllers/kendaraan_controller.dart';

class KendaraanView extends GetView<KendaraanController> {
  const KendaraanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kendaraan'),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future<void>.delayed(
              const Duration(seconds: 3),
              () {
                controller.getKendaraan();
              },
            );
          },
          child: Obx(
            () => ListView.separated(
              separatorBuilder: (context, index) => 10.height,
              itemCount: controller.listKendaraan.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Code : ${controller.listKendaraan[index].kodeAsset}',
                      style: Get.textTheme.bodyMedium?.copyWith(),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  // Image border
                                  child: SizedBox.fromSize(
                                    // Image radius
                                    child: Image.network(
                                      '',
                                      fit: BoxFit.fill,
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'car'.png,
                                        fit: BoxFit.contain,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                ),
                                10.width,
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller
                                            .listKendaraan[index].namaAsset,
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      // 10.height,
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(
                                      //       'Catatan Bensin :',
                                      //       style: Get.textTheme.bodySmall
                                      //           ?.copyWith(),
                                      //     ),
                                      //     10.width,
                                      //     const Icon(
                                      //       Icons.local_gas_station_rounded,
                                      //       color: Colors.red,
                                      //       size: 30,
                                      //     ).onTap(controller.getBensin)
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status Aktif :',
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                ),
                                Text(
                                  controller.listKendaraan[index].statusAktif,
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                ),
                              ],
                            ),
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Metode :',
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                ),
                                Text(
                                  controller.listKendaraan[index].metode,
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                ),
                              ],
                            ),
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tanggal Beli :',
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                ),
                                Text(
                                  DateFormat("EEE, dd MMM yyyy", "id_ID")
                                      .format(controller
                                          .listKendaraan[index].tglBeli),
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                ),
                              ],
                            ),
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Harga Beli :',
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                ),
                                Text(
                                  controller.listKendaraan[index].hargaBeli,
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
