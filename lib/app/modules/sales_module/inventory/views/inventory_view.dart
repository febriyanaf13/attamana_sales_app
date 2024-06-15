import 'package:attamana_salles_app/app/components/custom_lottie_loading.dart';
import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/custom_dropdown_search.dart';
import '../../../../style/colors.dart';
import '../controllers/inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
        child: Column(
          children: [
            Obx(
              () => CustomDropDownSearch(
                controller: controller.textEditingControllerGudang,
                title: 'Gudang',
                labelSpace: true,
                isRequired: true,
                withTitle: true,
                hint: 'Search list gudang...',
                dataList: controller.listGudang.value,
                onSubmit: (value) {
                  print(value);
                },
                onSave: (value) {},
                onSelectedItem: (value) {
                  controller.gudangId.value = value.item!;
                  controller.postRequestlistStockBarang(value.item!);
                },
                validator: (x) {
                  if (controller.listGudang
                          .map((element) => element['text']
                              ?.replaceAll(RegExp('[^A-Za-z0-9]'), ''))
                          .where((value) => value!.contains(x!))
                          .contains(x) ||
                      x!.isEmpty) {
                    return 'Please Enter a valid Data';
                  }

                  return null;
                },
              ),
            ),
            20.height,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future<void>.delayed(
                    const Duration(seconds: 3),
                    () {
                      controller.postRequestlistStockBarang(
                          controller.gudangId.value);
                    },
                  );
                },
                child: Obx(
                  () => controller.isLoadingListStockBarang.isTrue
                      ? const CustomLottieLoading()
                      : controller.listStockBarang.isEmpty
                          ? const CustomLottieNotFound()
                          : ListView.separated(
                              itemCount: controller.listStockBarang.length,
                              padding: const EdgeInsets.only(bottom: 20),
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        controller
                                                            .listStockBarang[
                                                                index]
                                                            .namaProduk,
                                                        style: Get.textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      5.height,
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.home_work,
                                                            color: grey,
                                                            size: 20,
                                                          ),
                                                          5.width,
                                                          Text(
                                                            controller
                                                                .listStockBarang[
                                                                    index]
                                                                .namaGudang,
                                                            style: Get.textTheme
                                                                .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .category_rounded,
                                                            color: grey,
                                                            size: 20,
                                                          ),
                                                          5.width,
                                                          Text(
                                                            '${controller.listStockBarang[index].jumlahStok} - ${controller.listStockBarang[index].satuan}',
                                                            style: Get.textTheme
                                                                .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                      // Row(
                                                      //   children: [
                                                      //     const Icon(
                                                      //       Icons.assignment_late_rounded,
                                                      //       color: grey,
                                                      //       size: 20,
                                                      //     ),
                                                      //     5.width,
                                                      //     Text(
                                                      //       controller
                                                      //           .listStockBarang[index]
                                                      //           .action,
                                                      //       style: Get.textTheme.bodySmall,
                                                      //     ),
                                                      //   ],
                                                      // ),
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
                                            borderRadius:
                                                BorderRadius.horizontal(
                                              left: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return 10.height;
                              },
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
