import 'package:attamana_salles_app/app/modules/slip_gaji/controllers/slip_gaji_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../style/colors.dart';

class DetailSlipGajiView extends GetView<SlipGajiController> {
  const DetailSlipGajiView({super.key});

  @override
  Widget build(BuildContext context) {
    int totalPendapatan =
        int.parse(controller.slipGajiById!.tunjangan.toString()) +
            int.parse(controller.slipGajiById!.homeBase.toString()) +
            int.parse(controller.slipGajiById!.bonus.toString()) +
            int.parse(controller.slipGajiById!.lembur.toString()) +
            int.parse(controller.slipGajiById!.revisi.toString());

    int totalPotongan =
        int.parse(controller.slipGajiById!.potonganAbsensi.toString()) +
            int.parse(controller.slipGajiById!.terlambat.toString()) +
            int.parse(controller.slipGajiById!.bpjsKes.toString()) +
            int.parse(controller.slipGajiById!.jht.toString()) +
            int.parse(controller.slipGajiById!.jkk.toString()) +
            int.parse(controller.slipGajiById!.jkm.toString()) +
            int.parse(controller.slipGajiById!.jp.toString()) +
            int.parse(controller.slipGajiById!.pinjaman.toString()) +
            int.parse(controller.slipGajiById!.lainLain.toString());

    int bpjsKetenagakerjaan =
        int.parse(controller.slipGajiById!.jht.toString()) +
            int.parse(controller.slipGajiById!.jkk.toString()) +
            int.parse(controller.slipGajiById!.jkm.toString()) +
            int.parse(controller.slipGajiById!.jp.toString());

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
            SizedBox(
              height: 10,
            ),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gaji Pokok :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.gajiPokok.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tunjangan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.tunjangan.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Home Base :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.homeBase.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bonus :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.bonus.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lembur :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.lembur.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Revisi :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.revisi.toString())),
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
                            controller.setRupiah(
                                int.parse(totalPendapatan.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
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
                        'Potongan',
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Potongan Absensi :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(controller
                                .slipGajiById!.potonganAbsensi
                                .toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Potongan Terlambat :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.terlambat.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BPJS Ketenagakerjaan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(
                                int.parse(bpjsKetenagakerjaan.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BPJS Kesehatan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.bpjsKes.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pinjaman :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.pinjaman.toString())),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lain lain :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(int.parse(
                                controller.slipGajiById!.lainLain.toString())),
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
                            controller
                                .setRupiah(int.parse(totalPotongan.toString())),
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
                            controller.setRupiah(0),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gross Setahun :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(0),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PPH21 Setahun :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(0),
                            style: Get.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PPH21 Sebulan :',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            controller.setRupiah(0),
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
                            controller.setRupiah(int.parse(controller
                                .slipGajiById!.gajiDiterima
                                .toString())),
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
