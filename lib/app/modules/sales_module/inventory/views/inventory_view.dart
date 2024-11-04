import 'package:attamana_salles_app/app/components/custom_lottie_loading.dart';
import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../../../components/custom_dropdown_search.dart';
import '../../../../style/colors.dart';
import '../controllers/inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => controller.isSearchInventory.isFalse
              ? const Text('Inventory')
              : SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: controller.controllerSearch,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: Get.textTheme.bodyMedium?.copyWith(
                          letterSpacing: 1, fontStyle: FontStyle.italic),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: kInputBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: kInputBorderColor),
                      ),
                    ),
                    onChanged: (value) {
                      controller.page.value = 1;
                      controller.getListStockBarang(controller.gudangId.value);
                      // controller.getlistSCustomerSearch(value);
                    },
                  ),
                ),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.isSearchInventory.toggle();
              },
              icon: const Icon(Icons.search_rounded))
        ],
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
                  controller.getListStockBarang(value.item);
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
                      controller.getListStockBarang(controller.gudangId.value);
                    },
                  );
                },
                child: Obx(
                  () => controller.isLoadingListStockBarang.isTrue
                      ? const CustomLottieLoading()
                      : controller.listStockBarangSearch.isEmpty
                          ? const CustomLottieNotFound()
                          : ListView.separated(
                              itemCount:
                                  controller.listStockBarangSearch.length,
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
                                                            .listStockBarangSearch[
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
                                                                .listStockBarangSearch[
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
                                                            '${controller.listStockBarangSearch[index].jumlahStok} - ${controller.listStockBarangSearch[index].satuan}',
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
                                                      //           .listStockBarangSearch[index]
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
                                                //         '${controller.listStockBarangSearch[index].namaGudang}')),
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
            Obx(() => NumberPagination(
                  // by default, the paginator shows numbers as center content
                  totalPages: controller.numberPage.value,
                  currentPage: controller.page.value,
                  selectedButtonColor: kPrimaryColor,
                  // controlButtonSize: Size(40, 40),
                  buttonRadius: 10,

                  visiblePagesCount: controller.visiblePage.value,
                  onPageChanged: (int index) {
                    controller.page.value = index;
                    controller.getListStockBarang(controller.gudangId.value);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
