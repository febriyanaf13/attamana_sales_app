import 'package:attamana_salles_app/app/modules/slip_gaji/controllers/slip_gaji_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../style/colors.dart';

class DetailSlipGajiView extends GetView<SlipGajiController> {
  const DetailSlipGajiView({super.key});

  @override
  Widget build(BuildContext context) {
    var totalPendapatan = controller.slipGajiById!.tunjangan.toInt() +
        controller.slipGajiById!.homeBase.toInt() +
        controller.slipGajiById!.bonus.toInt() +
        controller.slipGajiById!.lembur.toInt() +
        controller.slipGajiById!.revisi.toInt();

    var totalPotongan = controller.slipGajiById!.potonganAbsensi.toInt() +
        controller.slipGajiById!.terlambat.toInt() +
        controller.slipGajiById!.bpjsKes.toInt() +
        controller.slipGajiById!.jht.toInt() +
        controller.slipGajiById!.jkk.toInt() +
        controller.slipGajiById!.jkm.toInt() +
        controller.slipGajiById!.jp.toInt() +
        controller.slipGajiById!.pinjaman.toInt() +
        controller.slipGajiById!.lainLain.toInt();

    var bpjsKetenagakerjaan = controller.slipGajiById!.jht.toInt() +
        controller.slipGajiById!.jkk.toInt() +
        controller.slipGajiById!.jkm.toInt() +
        controller.slipGajiById!.jp.toInt();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Slip Gaji'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nama Karyawan :',
                  style: Get.textTheme.bodyMedium,
                ),
                Text(
                  controller.nama.toString(),
                  style:
                      Get.textTheme.titleSmall?.copyWith(color: kPrimaryColor),
                ),
              ],
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tanggal Slip :',
                  style: Get.textTheme.bodyMedium,
                ),
                Text(
                  DateFormat("EEE, dd MMM yyyy", "id_ID")
                      .format(controller.slipGajiById!.tanggalAwal),
                  style: Get.textTheme.titleSmall,
                ),
              ],
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hari Kerja Aktual :',
                  style: Get.textTheme.bodyMedium,
                ),
                Text(
                  controller.slipGajiById!.hariKerjaAktual.toString(),
                  style: Get.textTheme.titleSmall,
                ),
              ],
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jam Lembur :',
                  style: Get.textTheme.bodyMedium,
                ),
                Text(
                  '${controller.slipGajiById!.jamLembur} jam',
                  style: Get.textTheme.titleSmall,
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              color: kPrimaryColor,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pendapatan',
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: Colors.green),
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gaji Pokok :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.gajiPokok.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tunjangan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.tunjangan.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Home Base :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.homeBase.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bonus :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.bonus.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lembur :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.lembur.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Revisi :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.revisi.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pendapatan :',
                            style: Get.textTheme.titleSmall,
                          ),
                          Text(
                            controller.setRupiah(totalPendapatan.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            20.height,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Potongan',
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: Colors.red),
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Potongan Absensi :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(controller
                                .slipGajiById!.potonganAbsensi
                                .toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Potongan Terlambat :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.terlambat.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BPJS Ketenagakerjaan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(bpjsKetenagakerjaan.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BPJS Kesehatan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.bpjsKes.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pinjaman :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.pinjaman.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lain lain :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.lainLain.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Potongan :',
                            style: Get.textTheme.titleSmall,
                          ),
                          Text(
                            controller.setRupiah(totalPotongan.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gross Sebulan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(0.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gross Setahun :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(0.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PPH21 Setahun :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(0.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PPH21 Sebulan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(0.toInt()),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gaji Diterima :',
                            style: Get.textTheme.titleSmall,
                          ),
                          Text(
                            controller.setRupiah(
                                controller.slipGajiById!.gajiDiterima.toInt()),
                            style: Get.textTheme.titleSmall
                                ?.copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
