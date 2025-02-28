import 'package:attamana_salles_app/app/components/custom_datepicker_dialog.dart';
import 'package:attamana_salles_app/app/components/custom_dropdown.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_dropdown_search.dart';
import '../../../../components/custom_text_field.dart';
import '../../../../style/colors.dart';
import '../../../../style/paddings.dart';
import '../controllers/activity_controller.dart';

class AddActivityView extends GetView<ActivityController> {
  const AddActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var visitId = Get.arguments;
    var customerType = CustomerType.newcustomer.obs;
    if (visitId != null) {
      customerType = CustomerType.existingcustomer.obs;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(visitId == null ? 'Buat Job Visit' : 'Edit Job Visit'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Expanded(
          //     flex: 1,
          //     child: SizedBox(
          //       width: Get.width,
          //       child: Image.asset(
          //         'peta'.jpg,
          //         fit: BoxFit.fitWidth,
          //       ),
          //     )),
          Expanded(
              flex: 2,
              child: Obx(() => Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 15,
                            child: SizedBox(
                                width: Get.size.width,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RadioListTile<CustomerType>(
                                              title: const Text("New Customer"),
                                              value: CustomerType.newcustomer,
                                              groupValue: customerType.value,
                                              onChanged: (CustomerType? value) {
                                                customerType.value = value!;
                                                controller
                                                    .clearTextEditingController();
                                                controller.ketcustomer.value =
                                                    'NEW';
                                                controller.customerId.value =
                                                    '0';
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: RadioListTile<CustomerType>(
                                              title: const Text(
                                                  "Existing Customer"),
                                              value:
                                                  CustomerType.existingcustomer,
                                              groupValue: customerType.value,
                                              onChanged: (CustomerType? value) {
                                                customerType.value = value!;
                                                controller
                                                    .getCustomerExisting();
                                                controller.ketcustomer.value =
                                                    'EXISTING';
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 1),
                                      20.height,
                                      Obx(
                                        () => customerType.value ==
                                                CustomerType.newcustomer
                                            ? CustomDropDownSearch(
                                                controller: controller
                                                    .textEditingControllerNama,
                                                title: 'New Customer Name',
                                                labelSpace: true,
                                                isRequired: true,
                                                withTitle: true,
                                                hint: 'Search lead customer...',
                                                dataList: controller
                                                    .listExistingCustomer.value,
                                                onSubmit: (value) {
                                                  print(value);
                                                },
                                                onSave: (value) {},
                                                onSelectedItem: (value) {
                                                  controller.customerId.value =
                                                      '0';
                                                },
                                                validator: (x) {
                                                  if (controller
                                                          .listExistingCustomer
                                                          .map((element) =>
                                                              element['text']
                                                                  ?.replaceAll(
                                                                      RegExp(
                                                                          '[^A-Za-z0-9]'),
                                                                      ''))
                                                          .where((value) =>
                                                              value!
                                                                  .contains(x!))
                                                          .contains(x) ||
                                                      x!.isEmpty) {
                                                    return 'Please Enter a valid Data';
                                                  }

                                                  return null;
                                                },
                                              )
                                            : CustomDropDownSearch(
                                                controller: controller
                                                    .textEditingControllerNama,
                                                title: 'Existing Customer Name',
                                                labelSpace: true,
                                                isRequired: true,
                                                withTitle: true,
                                                hint:
                                                    'Search existing customer...',
                                                dataList: controller
                                                    .listExistingCustomer.value,
                                                onSubmit: (value) {
                                                  print(value);
                                                },
                                                onSave: (value) {},
                                                onSelectedItem: (value) {
                                                  controller.customerId.value =
                                                      value.item!;
                                                },
                                                validator: (x) {
                                                  if (controller
                                                          .listExistingCustomer
                                                          .map((element) =>
                                                              element['text']
                                                                  ?.replaceAll(
                                                                      RegExp(
                                                                          '[^A-Za-z0-9]'),
                                                                      ''))
                                                          .where((value) =>
                                                              value!
                                                                  .contains(x!))
                                                          .contains(x) ||
                                                      x!.isEmpty) {
                                                    return 'Please Enter a valid Data';
                                                  }

                                                  return null;
                                                },
                                              ),
                                      ),
                                      const SizedBox(
                                        height: kElementPadding,
                                      ),
                                      // SizedBox(
                                      //   height: 200,
                                      //   width: Get.width,
                                      //   child: GoogleMap(
                                      //     onMapCreated: controller.onMapCreated,
                                      //     initialCameraPosition:
                                      //         const CameraPosition(
                                      //       target: LatLng(-6.954510669253717,
                                      //           110.46628139888527),
                                      //       zoom: 16,
                                      //     ),
                                      //     // markers: _markers.values.toSet(),
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   height: kElementPadding,
                                      // ),
                                      CustomDropdownButton(
                                        title: 'Action',
                                        initialValue: controller.action.value,
                                        isRequired: true,
                                        height: 60,
                                        items: controller.listAction.value,
                                        onChangeValue: (value) {
                                          controller.action.value =
                                              value.toString();
                                        },
                                        validator: 'Action harus dipilih...!',
                                      ),
                                      const SizedBox(
                                        height: kElementPadding,
                                      ),
                                      Column(
                                        children: [
                                          // CustomTextField(
                                          //   title: 'Alamat',
                                          //   hint: 'Tuliskan alamat...',
                                          //   isRequired: true,
                                          //   maxLine: 2,
                                          //   controller: controller
                                          //       .textEditingControllerAlamat,
                                          // ),
                                          // const SizedBox(
                                          //   height: kElementPadding,
                                          // ),
                                          CustomDateTimePickerDialog(
                                            title: 'Visit',
                                            setDateValue:
                                                controller.tglVisit.value,
                                            onDataChange: (value) {
                                              if (value != null) {
                                                controller.tglVisit.value =
                                                    value;
                                              }
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Pilih tanggal...!';
                                              }
                                              return null;
                                            },
                                            isRequired: true,
                                          ),
                                          const SizedBox(
                                            height: kElementPadding,
                                          ),
                                          CustomTextField(
                                            title: 'Deskripsi',
                                            hint: 'Tuliskan deskripsi...',
                                            isRequired: true,
                                            maxLine: 5,
                                            controller: controller
                                                .textEditingControllerDeskripsi,
                                          ),
                                        ],
                                      ),
                                      50.height,
                                      controller.isLoadingSimpanActivity.isTrue
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: kAccentColor,
                                              ),
                                            )
                                          : CustomButton(
                                              onTap: () {
                                                if (visitId != null) {
                                                  controller
                                                      .updateActivity(visitId);
                                                } else {
                                                  controller
                                                      .postSimpanActivity();
                                                }
                                              },
                                              text: visitId == null
                                                  ? 'Simpan'
                                                  : 'Update',
                                              border: 30,
                                              color: kAccentColor,
                                            )
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }
}

enum CustomerType { newcustomer, existingcustomer }
