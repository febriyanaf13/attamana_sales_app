import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../components/custom_lottie_not_found.dart';
import '../../../style/colors.dart';
import '../controllers/fixedasset_controller.dart';

class FixedassetView extends GetView<FixedassetController> {
  const FixedassetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixedasset'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future<void>.delayed(
            const Duration(seconds: 3),
            () {
              controller.getFixedasset();
            },
          );
        },
        child: Obx(
          () => controller.listFixedasset.isEmpty
              ? const CustomLottieNotFound()
              : ListView.separated(
                  itemCount: controller.listFixedasset.length,
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
                                          Text(
                                            '${controller.listFixedasset[index].kodeAsset} - ${controller.listFixedasset[index].namaAsset}',
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  'Metode :',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                controller.listFixedasset[index]
                                                    .metode
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
                                                  'Tanggal Beli :',
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
                                                        .listFixedasset[index]
                                                        .tglBeli),
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
                                                  'Umur :',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${controller.listFixedasset[index].umur} (Tahun)',
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
                                                  'Harga beli :',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${controller.listFixedasset[index].hargaBeli} ${controller.listFixedasset[index].matauang}',
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
                                                  'Status :',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${controller.listFixedasset[index].statusAktif}',
                                                style: Get.textTheme.bodySmall,
                                              ),
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
