import 'package:attamana_salles_app/app/components/custom_dropdown.dart';
import 'package:attamana_salles_app/app/modules/maintenance/models/maintenance.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_datepicker_dialog.dart';
import '../../../components/custom_image_picker.dart';
import '../../../components/custom_text_field.dart';
import '../../../style/paddings.dart';
import '../controllers/maintenance_controller.dart';

class AddMaintenanceView extends GetView<MaintenanceController> {
  const AddMaintenanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var argument = Get.arguments;
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.check);
        }
        return const Icon(Icons.close);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title:
            Text(argument == null ? 'Tambah Maintenance' : 'Edit Maintenance'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKeyMaintenance,
        child: SizedBox(
            width: Get.size.width,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Obx(
                    () => CustomDropdownButton(
                      title: 'Asset',
                      isRequired: true,
                      height: 60,
                      items:
                          controller.fixedassetC.listFixedassetDropdown.value,
                      onChangeValue: (value) {
                        controller.textEditingControllerAsset.text =
                            value.toString();
                      },
                      validator: 'Jenis services harus dipilih...!',
                    ),
                  ),
                  20.height,
                  Obx(
                    () => CustomDropdownButton(
                      title: 'Jenis Services',
                      isRequired: true,
                      height: 60,
                      items: controller.listServicesDropdown.value,
                      onChangeValue: (value) {
                        controller.textEditingControllerJenisServices.text =
                            value.toString();
                      },
                      validator: 'Jenis services harus dipilih...!',
                    ),
                  ),
                  const SizedBox(
                    height: kElementPadding,
                  ),
                  CustomTextField(
                    title: 'Total Biaya',
                    inputType: TextInputType.number,
                    prefix: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 20),
                          child: Text(
                            'Rp.',
                            style: Get.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    hint: '10.000',
                    isRequired: true,
                    controller: controller.textEditingControllerTotalBiaya,
                  ),
                  20.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            () => Switch(
                                thumbIcon: thumbIcon,
                                value: controller.isGantiSparePart.value,
                                onChanged: (bool value) {
                                  controller.isGantiSparePart.value = value;
                                }),
                          ),
                          10.width,
                          Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Ganti Spare Part',
                                  style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      20.width,
                      Obx(
                        () => controller.isGantiSparePart.isTrue
                            ? CustomTextField(
                                title: 'Spare Part',
                                inputType: TextInputType.number,
                                hint: 'Spare part',
                                isRequired: false,
                                controller:
                                    controller.textEditingControllerSparePart,
                              )
                            : const SizedBox(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: kElementPadding,
                  ),
                  CustomDateTimePickerDialog(
                    title: 'Maintenance',
                    onDataChange: (value) {
                      if (value != null) {
                        controller.textEditingControllerTanggalMaintenance
                            .text = value;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
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
                    title: 'No Maintenance',
                    inputType: TextInputType.number,
                    hint: 'No maintenance',
                    isRequired: true,
                    controller: controller.textEditingControllerNoMaintenance,
                  ),
                  20.height,
                  Obx(
                    () => CustomDropdownButton(
                      title: 'Vendor Service Agent',
                      isRequired: true,
                      height: 60,
                      items: controller.listVendorsDropdown.value,
                      onChangeValue: (value) {
                        controller.textEditingControllerVendors.text =
                            value.toString();
                      },
                      validator: 'Vendor harus dipilih...!',
                    ),
                  ),
                  20.height,
                  CustomTextField(
                    title: 'Notes',
                    hint: 'Tuliskan catatan...',
                    isRequired: true,
                    maxLine: 3,
                    controller: controller.textEditingControllerNotes,
                  ),
                  const SizedBox(
                    height: kElementPadding,
                  ),
                  Obx(() => CustomImagePicker(
                        title: 'Bukti',
                        isRequired: false,
                        boolImage: controller.boolImageMaintenance,
                        image: controller.boolImageMaintenance.isTrue
                            ? controller.imageMaintenance
                            : null,
                        onTap: controller.getImageBukti,
                      )),
                  50.height,
                  Obx(
                    () => controller.isLoadingSimpanMaintenance.isTrue
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            onTap: () {},
                            text: 'Simpan',
                            border: 30,
                            color: kAccentColor,
                          ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
