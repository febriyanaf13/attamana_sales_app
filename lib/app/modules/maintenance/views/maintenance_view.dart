import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_lottie_not_found.dart';
import '../../../style/colors.dart';
import '../controllers/maintenance_controller.dart';

class MaintenanceView extends GetView<MaintenanceController> {
  const MaintenanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADD_MAINTENANCE);
              },
              icon: const Icon(Icons.add_box))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future<void>.delayed(
            const Duration(seconds: 3),
            () {
              controller.getMaintenance();
            },
          );
        },
        child: Obx(
          () => controller.listMaintenance.isEmpty
              ? const CustomLottieNotFound()
              : ListView.separated(
                  itemCount: controller.listMaintenance.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    return Card(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${controller.listMaintenance[index].namaFixedasset} - (${controller.listMaintenance[index].nomorMaintenance})',
                                                  style: Get
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Colors.blue,
                                                  ),
                                                  SizedBox(height: 10),
                                                  const Icon(
                                                    Icons
                                                        .delete_forever_rounded,
                                                    size: 20,
                                                    color: Colors.red,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Tanggal Service :',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                DateFormat("EEE, dd MMM yyyy",
                                                        "id_ID")
                                                    .format(controller
                                                        .listMaintenance[index]
                                                        .serviceDate),
                                                style: Get.textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Nama Service Agent :',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                controller
                                                    .listMaintenance[index]
                                                    .namaService
                                                    .toString(),
                                                style: Get.textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Komentar :',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                controller
                                                    .listMaintenance[index]
                                                    .comment,
                                                style: Get.textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'bukti :',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.defaultDialog(
                                                      title:
                                                          'Bukti Pengisian Bensin',
                                                      content: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        // Image border
                                                        child:
                                                            SizedBox.fromSize(
                                                          // Image radius
                                                          child: Image.network(
                                                            controller
                                                                .listMaintenance[
                                                                    index]
                                                                .bukti,
                                                            fit: BoxFit.fill,
                                                            width: 50,
                                                            height: 50,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                              'maintenance'.png,
                                                              fit: BoxFit
                                                                  .contain,
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
                                                      ?.copyWith(
                                                          color: Colors.blue),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //     padding: const EdgeInsets.all(5),
                                    //     decoration: BoxDecoration(
                                    //         color: Colors.grey,
                                    //         borderRadius:
                                    //             BorderRadius.circular(5)),
                                    //     child: Text(
                                    //         '${controller.listStockBarang[index].namaGudang}')),
                                  ],
                                ),
                                // const Divider(
                                //   thickness: 1,
                                // ),
                                // Text(
                                //   'Desc :',
                                //   style: Get.textTheme.bodySmall,
                                // ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 5,
                              decoration: const BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
