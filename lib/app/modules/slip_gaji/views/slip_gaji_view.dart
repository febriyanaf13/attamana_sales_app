import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/slip_gaji_controller.dart';

class SlipGajiView extends GetView<SlipGajiController> {
  const SlipGajiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Slip Gaji'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future<void>.delayed(
              const Duration(seconds: 3),
              () {
                controller.getAllSlipGaji();
              },
            );
          },
          child: Obx(
            () => controller.listAllSlipGaji.isEmpty
                ? const CustomLottieNotFound()
                : ListView.separated(
                    itemCount: controller.listAllSlipGaji.length,
                    padding: const EdgeInsets.all(20),
                    separatorBuilder: (context, index) {
                      return Column(
                        children: [
                          const Divider(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                    itemBuilder: (context, index) {
                      var tambahan = int.parse(controller
                              .listAllSlipGaji[index].tunjangan
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].homeBase
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].bonus
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].lembur
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].revisi
                              .toString());

                      var potongan = int.parse(controller
                              .listAllSlipGaji[index].potonganAbsensi
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].terlambat
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].bpjsKes
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].jht
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].jkk
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].jkm
                              .toString()) +
                          int.parse(controller.listAllSlipGaji[index].jp.toString()) +
                          int.parse(controller.listAllSlipGaji[index].pinjaman.toString()) +
                          int.parse(controller.listAllSlipGaji[index].lainLain.toString());

                      return GestureDetector(
                        onTap: () {
                          controller.getSlipGajiById(int.parse(
                              controller.listAllSlipGaji[index].id.toString()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat("EEE, dd MMM yyyy", "id_ID")
                                      .format(controller
                                          .listAllSlipGaji[index].tanggalAwal),
                                  style: Get.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    controller.setRupiah(int.parse(controller
                                        .listAllSlipGaji[index].gajiDiterima
                                        .toString())),
                                    style: Get.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Gaji',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(color: Colors.grey)),
                                    Text(
                                        controller.setRupiah(int.parse(
                                            controller.listAllSlipGaji[index]
                                                .gajiPokok
                                                .toString())),
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tambahan',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(color: Colors.grey)),
                                    Text(controller.setRupiah(tambahan),
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Potongan',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(color: Colors.grey)),
                                    Text(controller.setRupiah(potongan),
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                )),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ));
  }
}
