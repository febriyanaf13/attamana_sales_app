import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:attamana_salles_app/app/components/custom_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart' as awd;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/custom_lottie_loading.dart';
import '../../../../components/custom_lottie_not_found.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
import '../../report_visit/models/sales.dart';
import '../controllers/assign_sales_controller.dart';
import '../models/customer_not_assign_ischecked.dart';

class AssignSalesView extends GetView<AssignSalesController> {
  const AssignSalesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Assign Sales'),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return Future<void>.delayed(
                const Duration(seconds: 3),
                () {
                  // controller.getKendaraan();
                },
              );
            },
            child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(children: [
                  PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: TabBar(
                          dividerHeight: 0,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabAlignment: TabAlignment.fill,
                          labelColor: kWhiteColor,
                          labelStyle: Get.textTheme.titleSmall,
                          unselectedLabelColor: kPrimaryColor,
                          indicatorColor: kWhiteColor,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryColor,
                          ),
                          padding: const EdgeInsets.all(5),
                          tabs: const [
                            Tab(
                              text: 'Not Assign',
                            ),
                            Tab(
                              text: 'Assign',
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      ListCustomerNotAssign(controller: controller),
                      ListCustomerAssign(controller: controller),
                    ]),
                  ),
                ]))));
  }
}

class ListCustomerAssign extends StatelessWidget {
  const ListCustomerAssign({
    super.key,
    required this.controller,
  });

  final AssignSalesController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future<void>.delayed(
          const Duration(seconds: 3),
          () {
            controller.getDataCustomerAsign();
          },
        );
      },
      child: Obx(
        () => controller.isLoadingCustomerAssign.isTrue
            ? const CustomLottieLoading()
            : controller.dataListCustomerAssign.isEmpty
                ? const CustomLottieNotFound()
                : ListView.separated(
                    itemCount: controller.dataListCustomerAssign.length,
                    padding: const EdgeInsets.all(10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                        .dataListCustomerAssign[
                                                            index]
                                                        .nama,
                                                    style: Get
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.edit_document,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ).onTap(() {
                                                  controller
                                                      .dataListCustomerSalesUpdate
                                                      .clear();
                                                  controller
                                                      .dataListCustomerSalesUpdate
                                                      .canUpdate;
                                                  Get.toNamed(
                                                      Routes.EDIT_ASSIGN_SALES,
                                                      arguments: index);
                                                  controller.getDataCustomerSales(
                                                      controller
                                                          .dataListCustomerAssign[
                                                              index]
                                                          .customerId);
                                                }),
                                              ],
                                            ),
                                            5.height,
                                            const Divider(),
                                            5.height,
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.corporate_fare_outlined,
                                                  color: grey,
                                                  size: 20,
                                                ),
                                                5.width,
                                                Expanded(
                                                  child: Text(
                                                    'Corporate Id',
                                                    style:
                                                        Get.textTheme.bodySmall,
                                                  ),
                                                ),
                                                Text(
                                                  ' : ',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    controller
                                                        .dataListCustomerAssign[
                                                            index]
                                                        .corporate,
                                                    style:
                                                        Get.textTheme.bodySmall,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            5.height,
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.share_location_rounded,
                                                  color: grey,
                                                  size: 20,
                                                ),
                                                5.width,
                                                Expanded(
                                                  child: Text(
                                                    'Alamat',
                                                    style:
                                                        Get.textTheme.bodySmall,
                                                  ),
                                                ),
                                                Text(
                                                  ' : ',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    controller
                                                        .dataListCustomerAssign[
                                                            index]
                                                        .address,
                                                    style:
                                                        Get.textTheme.bodySmall,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            5.height,
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.person_3_outlined,
                                                  color: grey,
                                                  size: 20,
                                                ),
                                                5.width,
                                                Expanded(
                                                  child: Text(
                                                    'Sales',
                                                    style:
                                                        Get.textTheme.bodySmall,
                                                  ),
                                                ),
                                                Text(
                                                  ' : ',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    controller
                                                        .dataListCustomerAssign[
                                                            index]
                                                        .sales,
                                                    style:
                                                        Get.textTheme.bodySmall,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  color: kPrimaryColor,
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
                      return 10.height;
                    },
                  ),
      ),
    );
  }
}

class ListCustomerNotAssign extends StatelessWidget {
  const ListCustomerNotAssign({
    super.key,
    required this.controller,
  });

  final AssignSalesController controller;

  @override
  Widget build(BuildContext context) {
    var cekIsChecked = false.obs;

    return Obx(
      () => controller.dataListAllSales.isEmpty
          ? const CustomLottieNotFound()
          : Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomDropdown<Sales>.search(
                      hintText: 'Select Sales',
                      headerBuilder: (context, selectedItem, enabled) =>
                          Text(selectedItem.nama),
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        return Text(item.nama);
                      },
                      items: controller.dataListAllSales.value,
                      excludeSelected: false,
                      onChanged: (value) {
                        controller.pegawaiId.value =
                            value!.pegawaiId.toString();
                      },
                    )),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return Future<void>.delayed(
                        const Duration(seconds: 3),
                        () {
                          controller.getDataCustomerNotAsign();
                        },
                      );
                    },
                    child: controller.isLoadingCustomerAssign.isTrue
                        ? const CustomLottieLoading()
                        : controller.dataListCustomerNotAssign.isEmpty
                            ? const CustomLottieNotFound()
                            : ListView.separated(
                                itemCount:
                                    controller.dataListCustomerNotAssign.length,
                                padding: const EdgeInsets.all(10),
                                itemBuilder: (context, index) {
                                  var isChecked = false.obs;

                                  controller.dataListCustomerNotAssignIsChecked
                                      .add(CustomerNotAssignIsChecked(
                                          customerId: controller
                                              .dataListCustomerNotAssign[index]
                                              .customerId
                                              .toString(),
                                          isChecked: false.obs));

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
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                controller
                                                                    .dataListCustomerNotAssign[
                                                                        index]
                                                                    .nama,
                                                                style: Get
                                                                    .textTheme
                                                                    .titleMedium
                                                                    ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              ),
                                                            ),
                                                            Obx(
                                                              () => controller
                                                                          .pegawaiId ==
                                                                      ''
                                                                  ? const SizedBox()
                                                                  : SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child:
                                                                          Checkbox(
                                                                        checkColor:
                                                                            Colors.blue,
                                                                        value: controller
                                                                            .dataListCustomerNotAssignIsChecked[index]
                                                                            .isChecked
                                                                            .value,
                                                                        onChanged:
                                                                            (value) {
                                                                          cekIsChecked.value =
                                                                              true;
                                                                          controller
                                                                              .dataListCustomerNotAssignIsChecked[index]
                                                                              .isChecked
                                                                              .value = value!;
                                                                          // .toggle();
                                                                        },
                                                                      ),
                                                                    ),
                                                            )
                                                          ],
                                                        ),
                                                        5.height,
                                                        const Divider(),
                                                        5.height,
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .corporate_fare_outlined,
                                                              color: grey,
                                                              size: 20,
                                                            ),
                                                            5.width,
                                                            Expanded(
                                                              child: Text(
                                                                'Corporate Id',
                                                                style: Get
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' : ',
                                                              style: Get
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                controller
                                                                    .dataListCustomerNotAssign[
                                                                        index]
                                                                    .corporate,
                                                                style: Get
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        5.height,
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .share_location_rounded,
                                                              color: grey,
                                                              size: 20,
                                                            ),
                                                            5.width,
                                                            Expanded(
                                                              child: Text(
                                                                'Alamat',
                                                                style: Get
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' : ',
                                                              style: Get
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                controller
                                                                    .dataListCustomerNotAssign[
                                                                        index]
                                                                    .address,
                                                                style: Get
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                              color: kPrimaryColor,
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
                cekIsChecked.isTrue
                    ? controller.isLoadingSubmitAssignSales.isTrue
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ))
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: CustomButton(
                              onTap: controller.postDataAssignSales,
                              text: 'Submit',
                              border: 10,
                              color: kPrimaryColor,
                            ),
                          )
                    : const SizedBox()
              ],
            ),
    );
  }
}
