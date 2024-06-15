import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_datepicker_dialog.dart';
import '../../../../components/custom_lottie.dart';
import '../../../../components/custom_lottie_not_found.dart';
import '../../../../style/colors.dart';
import '../controllers/sales_order_controller.dart';

class SalesOrderView extends GetView<SalesOrderController> {
  const SalesOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => controller.rangeTanggal.value == ''
                      ? const SizedBox()
                      : Text(
                          controller.rangeTanggal.value.toString(),
                          style: Get.textTheme.bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                ),
                10.height,
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: controller.textEditingControllerSearch,
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
                          borderSide:
                              const BorderSide(color: kInputBorderColor),
                        ),
                        suffixIcon: const Icon(Icons.search_rounded).onTap(() {
                          controller.getlistSalesOrderSearch(
                              controller.textEditingControllerSearch.text);
                        })),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: const Text('Sales Order'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: showBottomSheetFilter,
              icon: const Icon(Icons.filter_list))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future<void>.delayed(
            const Duration(seconds: 3),
            () {
              controller.reqPostSalesOrder();
              controller.textEditingControllerTglFilterMulai.clear();
              controller.textEditingControllerTglFilterSelesai.clear();
              controller.rangeTanggal.value = '';
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => controller.isLoadingSalesOrder.isTrue
                ? const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  )
                : controller.listSalesOrderSearch.isEmpty
                    ? const CustomLottieNotFound()
                    : ListView.separated(
                        separatorBuilder: (context, index) => 10.height,
                        itemCount: controller.listSalesOrderSearch.length,
                        itemBuilder: (context, index) {
                          var seeProduct = false.obs;

                          return Card(
                              child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'SO NUMBER',
                                                style: Get.textTheme.bodySmall,
                                              ),
                                              Expanded(
                                                child: AutoSizeText(
                                                  controller
                                                      .listSalesOrderSearch[
                                                          index]
                                                      .noTransaksi
                                                      .toString(),
                                                  style:
                                                      Get.textTheme.bodyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const VerticalDivider(thickness: 1),
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(
                                              controller
                                                  .listSalesOrderSearch[index]
                                                  .status
                                                  .toString(),
                                              style: Get.textTheme.titleSmall
                                                  ?.copyWith(color: orange),
                                            ))),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'DATE',
                                          style: Get.textTheme.bodySmall,
                                        ),
                                        Text(
                                          DateFormat("dd-MM-yyyy").format(
                                              controller
                                                  .listSalesOrderSearch[index]
                                                  .tglTransaksi),
                                          style: Get.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    10.width,
                                    const Icon(Icons.arrow_forward_rounded),
                                    10.width,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'DUE DATE',
                                          style: Get.textTheme.bodySmall,
                                        ),
                                        Text(
                                          DateFormat("dd-MM-yyyy").format(
                                              controller
                                                  .listSalesOrderSearch[index]
                                                  .dueDate),
                                          style: Get.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'CUSTOMER',
                                            style: Get.textTheme.bodySmall,
                                          ),
                                          Text(
                                            controller
                                                .listSalesOrderSearch[index]
                                                .namaCustomer
                                                .toString(),
                                            style: Get.textTheme.bodyLarge,
                                          ),
                                          10.height
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: const BoxDecoration(
                                        color: kGreyColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'See Product',
                                            style: Get.textTheme.bodyLarge,
                                          ),
                                          10.width,
                                          Obx(() => Icon(seeProduct.isTrue
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons
                                                  .keyboard_arrow_down_rounded))
                                        ],
                                      ).onTap(() {
                                        seeProduct.toggle();
                                      }),
                                    )
                                  ],
                                ),
                                Obx(
                                  () => seeProduct.isTrue
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          primary: true,
                                          child: Container(
                                              // height: 200,
                                              width: 600,
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                color: kGreyColor,
                                              ),
                                              child: ListView.separated(
                                                itemCount: controller
                                                        .listSalesOrderSearch[
                                                            index]
                                                        .detail
                                                        .length +
                                                    1,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                separatorBuilder:
                                                    (context, idx) =>
                                                        const Divider(),
                                                itemBuilder: (context, idx) {
                                                  return idx == 0
                                                      ? SizedBox(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    'PRODUCT',
                                                                    style: Get
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    'REQUEST',
                                                                    style: Get
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    'IN PROGRESS',
                                                                    style: Get
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    'DONE',
                                                                    style: Get
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    'DELIVERED',
                                                                    style: Get
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: Text(
                                                                    'OUTSTANDING',
                                                                    style: Get
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  '${idx}. ${controller.listSalesOrderSearch[index].detail[idx - 1].namaProduk}',
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  controller
                                                                      .listSalesOrderSearch[
                                                                          index]
                                                                      .detail[
                                                                          idx -
                                                                              1]
                                                                      .request
                                                                      .toString(),
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  controller
                                                                      .listSalesOrderSearch[
                                                                          index]
                                                                      .detail[
                                                                          idx -
                                                                              1]
                                                                      .inProgress
                                                                      .toString(),
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  controller
                                                                      .listSalesOrderSearch[
                                                                          index]
                                                                      .detail[
                                                                          idx -
                                                                              1]
                                                                      .done
                                                                      .toString(),
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodySmall,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  controller
                                                                      .listSalesOrderSearch[
                                                                          index]
                                                                      .detail[
                                                                          idx -
                                                                              1]
                                                                      .delivered
                                                                      .toString(),
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: Text(
                                                                  controller
                                                                      .listSalesOrderSearch[
                                                                          index]
                                                                      .detail[
                                                                          idx -
                                                                              1]
                                                                      .outstanding
                                                                      .toString(),
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                },
                                              )),
                                        )
                                      : const SizedBox(),
                                )
                              ],
                            ),
                          ));
                        },
                      ),
          ),
        ),
      ),
    );
  }

  void showBottomSheetFilter() {
    Get.bottomSheet(SizedBox(
      height: 250,
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomDateTimePickerDialog(
                          title: 'Mulai',
                          onDataChange: (value) {
                            if (value != null) {
                              controller.textEditingControllerTglFilterMulai
                                  .text = value;
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih tanggal ...!';
                            }
                            return null;
                          },
                          isRequired: true,
                          firstDate: '1000-01-01',
                        ),
                      ),
                      10.width,
                      Expanded(
                        child: CustomDateTimePickerDialog(
                          title: 'Selesai',
                          onDataChange: (value) {
                            if (value != null) {
                              controller.textEditingControllerTglFilterSelesai
                                  .text = value;
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih tanggal ...!';
                            }
                            return null;
                          },
                          isRequired: true,
                          firstDate: '1000-01-01',
                        ),
                      ),
                    ],
                  ),
                  30.height,
                  Obx(() => controller.isLoadingSalesOrder.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        )
                      : CustomButton(
                          onTap: () {
                            controller.reqPostSalesOrder();
                            Get.back();
                          },
                          text: 'Cari',
                          border: 10,
                          color: kPrimaryColor,
                        ))
                ],
              ))),
    ));
  }
}
