import 'package:attamana_salles_app/app/components/custom_dropdown.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_datepicker_dialog.dart';
import '../../../components/custom_image_picker.dart';
import '../../../components/custom_text_field.dart';
import '../../../style/paddings.dart';
import '../controllers/kendaraan_controller.dart';

class AddBensinView extends GetView<KendaraanController> {
  const AddBensinView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var argument = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(argument == null ? 'Tambah Catatan Bensin' : 'Edit'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKeyBensin,
        child: SizedBox(
            width: Get.size.width,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Obx(
                    () => CustomDropdownButton(
                      title: 'Jenis Kendaraan',
                      isRequired: true,
                      height: 60,
                      items: controller.listKendaraanDropdown.value,
                      onChangeValue: (value) {
                        // controller.jenisKendaraan.value =
                        //     value.toString();
                      },
                      validator: 'Jenis kendaraan harus dipilih...!',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomDateTimePickerDialog(
                    title: '',
                    onDataChange: (value) {
                      if (value != null) {
                        controller.controllerTanggal.text = value;
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
                    title: 'Odometer',
                    hint: '1.000',
                    suffixText: 'KM',
                    isRequired: true,
                    controller: controller.controllerOdometer,
                  ),
                  const SizedBox(
                    height: kElementPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomTextField(
                          title: 'Liter',
                          hint: '0',
                          isRequired: true,
                          suffixText: 'L',
                          inputType: TextInputType.number,
                          controller: controller.controllerLiter,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          title: 'Harga/liter',
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
                          controller: controller.controllerHargaPerLiter,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: kElementPadding,
                  ),
                  CustomTextField(
                    title: 'Notes',
                    hint: 'Tuliskan catatan...',
                    isRequired: true,
                    maxLine: 3,
                    controller: controller.controllerNotes,
                  ),
                  const SizedBox(
                    height: kElementPadding,
                  ),
                  Obx(() => CustomImagePicker(
                        title: 'Bukti',
                        isRequired: false,
                        boolImage: controller.boolImageBensin,
                        image: controller.boolImageBensin.isTrue
                            ? controller.imageBensin
                            : null,
                        onTap: controller.getImageBukti,
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  Obx(
                    () => controller.isLoadingSimpanBensin.isTrue
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            onTap: controller.onTapSimpanCatatanBensin,
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
