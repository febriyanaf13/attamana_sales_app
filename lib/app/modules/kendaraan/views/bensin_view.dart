import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/modules/kendaraan/controllers/kendaraan_controller.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_awesome_dialog.dart';
import '../../../routes/app_pages.dart';
import '../../../style/colors.dart';

class BensinView extends GetView<KendaraanController> {
  const BensinView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('Catatan Pengisian Bensin'),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(Routes.ADD_BENSIN);
                },
                icon: const Icon(Icons.add_box))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future<void>.delayed(
              const Duration(seconds: 3),
              () {
                controller.getBensin();
              },
            );
          },
          child: Obx(
            () => controller.listBensin.isEmpty
                ? const CustomLottieNotFound()
                : ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    itemCount: controller.listBensin.length,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'bensin'.png,
                                    fit: BoxFit.contain,
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .listBensin[index].namaFixedAsset
                                              .toString(),
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                DateFormat("EEE, dd MMM yyyy",
                                                        "id_ID")
                                                    .format(controller
                                                        .listBensin[index]
                                                        .fillUpDate),
                                                style: Get.textTheme.bodySmall
                                                    ?.copyWith(),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                        .controllerJenisKendaraan
                                                        .text =
                                                    controller.listBensin[index]
                                                        .namaFixedAsset;
                                                // controller
                                                //         .controllerTanggal.text =
                                                //     controller.listBensin[index]
                                                //         .fillUpDate
                                                //         .toString();
                                                controller
                                                        .controllerLiter.text =
                                                    controller
                                                        .listBensin[index].liter
                                                        .toString();
                                                controller
                                                        .controllerHargaPerLiter
                                                        .text =
                                                    controller.listBensin[index]
                                                        .hargaPerLiter
                                                        .toString();
                                                controller.controllerOdometer
                                                        .text =
                                                    controller.listBensin[index]
                                                        .odometer
                                                        .toString();
                                                controller
                                                        .controllerNotes.text =
                                                    controller
                                                        .listBensin[index].notes
                                                        .toString();

                                                Get.toNamed(Routes.ADD_BENSIN,
                                                    arguments: controller
                                                        .listBensin[index].id);
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                size: 20,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                awesomeDialogQuestion(
                                                  'Hapus Catatan Bensin',
                                                  'Yakin ingin menghapus item ini?',
                                                  () {
                                                    print('object');
                                                  },
                                                ).show();
                                              },
                                              child: const Icon(
                                                Icons.delete_forever_rounded,
                                                color: Colors.red,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Liter :',
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                  Text(
                                    '${controller.listBensin[index].liter} L',
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Harga/Liter :',
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                  Text(
                                    setRupiah(controller
                                        .listBensin[index].hargaPerLiter),
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total :',
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                  Text(
                                    setRupiah(
                                        controller.listBensin[index].total),
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Notes :',
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                  Text(
                                    controller.listBensin[index].notes
                                        .toString(),
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bukti :',
                                    style: Get.textTheme.bodySmall?.copyWith(),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.defaultDialog(
                                          title: 'Bukti Pengisian Bensin',
                                          content: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            // Image border
                                            child: SizedBox.fromSize(
                                              // Image radius
                                              child: Image.network(
                                                controller
                                                    .listBensin[index].bukti,
                                                fit: BoxFit.fill,
                                                width: 50,
                                                height: 50,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Image.asset(
                                                  'bensin'.png,
                                                  fit: BoxFit.contain,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              ),
                                            ),
                                          ));
                                    },
                                    child: Text(
                                      'Lihat Bukti',
                                      style: Get.textTheme.bodySmall
                                          ?.copyWith(color: Colors.blue),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ));
  }
}
