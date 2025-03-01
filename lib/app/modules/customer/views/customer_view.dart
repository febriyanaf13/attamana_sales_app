import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../../style/colors.dart';
import '../controllers/customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => controller.isSearchCustomer.isFalse
              ? const Text('Customer')
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
                      controller.curretPage == 1;
                      controller.getCustomer();
                    },
                  ),
                ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADD_CUSTOMER);
              },
              icon: const Icon(Icons.person_add)),
          IconButton(
              onPressed: () {
                controller.isSearchCustomer.toggle();
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return Future<void>.delayed(
                  const Duration(seconds: 3),
                  () {
                    controller.getCustomer();
                  },
                );
              },
              child: Obx(
                () => controller.listCustomerSearch.isEmpty
                    ? const CustomLottieNotFound()
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          itemCount: controller.listCustomerSearch.length,
                          padding: const EdgeInsets.all(20),
                          itemBuilder: (context, index) {
                            var isDetailCustomer = false.obs;

                            return SizedBox(
                              width: Get.width,
                              child: Card(
                                color: kCardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                    ),
                                                  ))),
                                          10.width,
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                  '${controller.listCustomerSearch[index].nama} (${controller.listCustomerSearch[index].corporate})',
                                                  style:
                                                      Get.textTheme.bodyMedium,
                                                  maxLines: 2),
                                              AutoSizeText(
                                                  controller
                                                      .listCustomerSearch[index]
                                                      .phone1,
                                                  style: Get
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          color:
                                                              kSecondaryTextColor)),
                                            ],
                                          )),
                                          SizedBox(
                                            height: 40,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Icon(
                                                  Icons.edit,
                                                  size: 10,
                                                  color: Colors.blue,
                                                ).onTap(() {
                                                  Get.toNamed(
                                                      Routes.EDIT_CUSTOMER,
                                                      arguments: index);
                                                }),
                                                Obx(() => Icon(
                                                      isDetailCustomer.isTrue
                                                          ? Icons
                                                              .keyboard_arrow_up_rounded
                                                          : Icons
                                                              .keyboard_arrow_down_rounded,
                                                      size: 20,
                                                    ).onTap(() {
                                                      isDetailCustomer.toggle();
                                                    })),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Obx(() => isDetailCustomer.isTrue
                                          ? Column(
                                              children: [
                                                const Divider(
                                                  thickness: 1,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Company Name :',
                                                      style: Get
                                                          .textTheme.bodySmall
                                                          ?.copyWith(),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                            .listCustomerSearch[
                                                                index]
                                                            .companyName,
                                                        style: Get
                                                            .textTheme.bodySmall
                                                            ?.copyWith(),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                10.height,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Address :',
                                                      style: Get
                                                          .textTheme.bodySmall
                                                          ?.copyWith(),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                            .listCustomerSearch[
                                                                index]
                                                            .address,
                                                        style: Get
                                                            .textTheme.bodySmall
                                                            ?.copyWith(),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                10.height,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'City :',
                                                      style: Get
                                                          .textTheme.bodySmall
                                                          ?.copyWith(),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                            .listCustomerSearch[
                                                                index]
                                                            .city,
                                                        style: Get
                                                            .textTheme.bodySmall
                                                            ?.copyWith(),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                10.height,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Country :',
                                                      style: Get
                                                          .textTheme.bodySmall
                                                          ?.copyWith(),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller
                                                            .listCustomerSearch[
                                                                index]
                                                            .country,
                                                        style: Get
                                                            .textTheme.bodySmall
                                                            ?.copyWith(),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const SizedBox())
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
          Obx(() => NumberPagination(
                // by default, the paginator shows numbers as center content
                totalPages: controller.totalPages.value,
                currentPage: controller.curretPage.value,
                selectedButtonColor: kPrimaryColor,
                // controlButtonSize: Size(40, 40),
                buttonRadius: 10,
                visiblePagesCount: controller.visiblePage.value,
                onPageChanged: (int index) {
                  controller.curretPage.value = index;
                  controller.getCustomer();
                },
              ))
        ],
      ),
    );
  }
}
