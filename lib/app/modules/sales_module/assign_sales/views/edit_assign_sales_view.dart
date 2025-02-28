import 'dart:ffi';
import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:attamana_salles_app/app/components/custom_dropdown_sales_model_search.dart';
import 'package:attamana_salles_app/app/modules/sales_module/assign_sales/controllers/assign_sales_controller.dart';
import 'package:attamana_salles_app/app/modules/sales_module/assign_sales/models/customer_sales_update.dart';
import 'package:attamana_salles_app/app/style/paddings.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_dropdown_search.dart';
import '../../../../style/colors.dart';
import '../../report_visit/models/sales.dart';

class EditAssignSalesView extends GetView<AssignSalesController> {
  const EditAssignSalesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final index = Get.arguments;
    var pegawaiId = ''.obs;
    int selectedIndex = 0;
    var isModified = false.obs;

    controller.dataListCustomerSalesUpdate.clear();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Assign Sales'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(controller.dataListCustomerAssign[index].nama,
                        style: Get.textTheme.titleLarge),
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(3)),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.add_box_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    onPressed: () {
                      isModified(true);
                      controller.listLength + 1;
                      controller.dataListCustomerSalesUpdate.add(
                          controller.dataListAllSales[0].pegawaiId.toString());
                    },
                  ),
                  IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(3)),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.indeterminate_check_box_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    onPressed: () {
                      isModified(true);
                      if (controller.listLength != 0) {
                        controller.listLength - 1;
                        controller.dataListCustomerSalesUpdate.length - 1;
                        controller.dataListCustomerSalesUpdate.removeLast();
                      }
                    },
                  )
                ],
              ),
              20.height,
              Obx(
                () => Expanded(
                    child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    var listAllSales = <Sales>[];
                    listAllSales = controller.dataListAllSales.value;

                    int intSales() {
                      print(
                          'object ${controller.dataListCustomerSales[index].nama}');
                      var ind = 0;
                      listAllSales.mapIndexed((idx, element) {
                        bool i = element.nama.contains(
                            controller.dataListCustomerSales[index].nama);
                        if (i == true) {
                          ind = idx;
                        }
                      }).toList();

                      return ind;
                    }

                    // controller.dataListCustomerSalesUpdate.clear();

                    if (controller.dataListCustomerSales.length <= index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sales ${index + 1}',
                            style: Get.textTheme.bodyLarge,
                          ),
                          10.height,
                          CustomDropdown<Sales>.search(
                            hintText: 'Select Sales',
                            headerBuilder: (context, selectedItem, enable) =>
                                Text(selectedItem.nama),
                            listItemBuilder:
                                (context, item, isModified, onItemSelect) {
                              return Text(item.nama);
                            },
                            items: listAllSales,
                            initialItem: listAllSales[0],
                            excludeSelected: false,
                            onChanged: (value) {
                              var id = value!.pegawaiId;
                              if (id !=
                                  controller
                                      .dataListCustomerSalesUpdate[index]) {
                                controller.dataListCustomerSalesUpdate[index] =
                                    id.toString();
                              }
                              pegawaiId.value = value!.pegawaiId.toString();
                              // controller.dataListCustomerSalesUpdate
                              //     .add(value.pegawaiId.toString());
                              log('changing value to: ${value!.nama}');
                            },
                            validator: (p0) {
                              if (p0?.pegawaiId == null) {
                                return 'harus diisi';
                              }
                              return null;
                            },
                          )
                        ],
                      );
                    } else {
                      print('list Lengt ${controller.listLength}');
                      print(
                          'customer Lengt ${controller.dataListCustomerSales.length}');
                      if (isModified.isFalse) {
                        if (controller.listLength <
                            controller.dataListCustomerSales.length) {
                          controller.dataListCustomerSalesUpdate.clear();
                          controller.dataListCustomerSalesUpdate.add(controller
                              .dataListCustomerSales[index].pegawaiId
                              .toString());
                        } else if (controller.listLength ==
                            controller.dataListCustomerSales.length) {
                          controller.dataListCustomerSalesUpdate.add(controller
                              .dataListCustomerSales[index].pegawaiId
                              .toString());
                        }
                      }

                      return Obx(() => controller.isLoadingListDropdown.isTrue
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sales ${index + 1}',
                                  style: Get.textTheme.bodyLarge,
                                ),
                                10.height,
                                CustomDropdown<Sales>.search(
                                  hintText: 'Select Sales',
                                  headerBuilder:
                                      (context, selectedItem, enable) =>
                                          Text(selectedItem.nama),
                                  listItemBuilder: (context, item, isModified,
                                      onItemSelect) {
                                    return Text(item.nama);
                                  },
                                  initialItem: listAllSales[intSales()],
                                  items: listAllSales,
                                  excludeSelected: false,
                                  onChanged: (value) {
                                    isModified(true);
                                    var id = value!.pegawaiId.toString();
                                    if (id !=
                                        controller.dataListCustomerSalesUpdate[
                                            index]) {
                                      controller.dataListCustomerSalesUpdate[
                                          index] = id.toString();
                                    }
                                    log('changing value to: ${value!.nama}');
                                  },
                                  validator: (p0) {
                                    if (p0!.pegawaiId == null) {
                                      return 'harus diisi';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ));
                    }
                  },
                  itemCount: controller.listLength.value,
                  separatorBuilder: (BuildContext context, int index) {
                    return 15.height;
                  },
                )),
              ),
              20.height,
              controller.isLoadingUpdateAssignSales.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ))
                  : CustomButton(
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          print('Masuk Sini');
                          controller.updateDataAssignSales(controller
                              .dataListCustomerAssign[index].customerId
                              .toString());
                        }
                        // controller.dataListCustomerSalesUpdate
                        //     .add(pegawaiId.value);
                      },
                      text: 'Update',
                      border: 10,
                      color: kPrimaryColor,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
