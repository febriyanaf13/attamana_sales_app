import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

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
                          10.height,
                        ],
                      );
                    },
                    itemBuilder: (context, index) {
                      var tambahan = controller.listAllSlipGaji[index].tunjangan
                              .toInt() +
                          controller.listAllSlipGaji[index].homeBase.toInt() +
                          controller.listAllSlipGaji[index].bonus.toInt() +
                          controller.listAllSlipGaji[index].lembur.toInt() +
                          controller.listAllSlipGaji[index].revisi.toInt();

                      var potongan = controller
                              .listAllSlipGaji[index].potonganAbsensi
                              .toInt() +
                          controller.listAllSlipGaji[index].terlambat.toInt() +
                          controller.listAllSlipGaji[index].bpjsKes.toInt() +
                          controller.listAllSlipGaji[index].jht.toInt() +
                          controller.listAllSlipGaji[index].jkk.toInt() +
                          controller.listAllSlipGaji[index].jkm.toInt() +
                          controller.listAllSlipGaji[index].jp.toInt() +
                          controller.listAllSlipGaji[index].pinjaman.toInt() +
                          controller.listAllSlipGaji[index].lainLain.toInt();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat("EEE, dd MMM yyyy", "id_ID").format(
                                    controller
                                        .listAllSlipGaji[index].tanggalAwal),
                                style: Get.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  controller.setRupiah(controller
                                      .listAllSlipGaji[index].gajiDiterima
                                      .toInt()),
                                  style: Get.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor)),
                            ],
                          ),
                          10.height,
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Gaji',
                                      style: Get.textTheme.bodySmall
                                          ?.copyWith(color: grey)),
                                  Text(
                                      controller.setRupiah(controller
                                          .listAllSlipGaji[index].gajiPokok
                                          .toInt()),
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          color: grey,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tambahan',
                                      style: Get.textTheme.bodySmall
                                          ?.copyWith(color: grey)),
                                  Text(controller.setRupiah(tambahan.toInt()),
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          color: grey,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Potongan',
                                      style: Get.textTheme.bodySmall
                                          ?.copyWith(color: grey)),
                                  Text(controller.setRupiah(potongan.toInt()),
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          color: grey,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                            ],
                          ),
                        ],
                      ).onTap(() {
                        controller.getSlipGajiById(
                            controller.listAllSlipGaji[index].id.toInt());
                      });
                    },
                  ),
          ),
        ));
  }
}
