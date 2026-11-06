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
import '../controllers/cuti_controller.dart';

class AjukanCutiView extends GetView<CutiController> {
  const AjukanCutiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Cuti'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset('bg_cuti'.jpg),
          Expanded(
            child: Form(
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
                                      child: CustomDateTimePickerDialog(
                                        title: 'Mulai',
                                        onDataChange: (value) {
                                          if (value != null) {
                                            controller.tglMulai.value = value;
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
                                    ),
                                    const SizedBox(width: kElementPadding),
                                    Expanded(
                                      child: CustomTextField(
                                        title: 'Lama Cuti',
                                        hint: 'Lama cuti?',
                                        isRequired: true,
                                        suffixText: 'Hari',
                                        inputType: TextInputType.number,
                                        controller:
                                            controller.controllerLamaCuti,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: kElementPadding,
                                ),
                                Obx(
                                  () => CustomDropdownButton(
                                    title: 'Jenis Cuti',
                                    isRequired: true,
                                    height: 60,
                                    items: controller.listTipeCuti.value,
                                    onChangeValue: (value) {
                                      controller.jenisCuti.value =
                                          value.toString();
                                    },
                                    validator: 'Jenis ijin harus dipilih...!',
                                  ),
                                ),
                                const SizedBox(
                                  height: kElementPadding,
                                ),
                                CustomTextField(
                                  title: 'Alasan',
                                  hint: 'Tuliskan alasan permohonan cuti...',
                                  isRequired: true,
                                  maxLine: 5,
                                  controller: controller.controllerAlasan,
                                ),
                                const SizedBox(
                                  height: kElementPadding,
                                ),
                                Obx(() => CustomImagePicker(
                                      title: 'Bukti',
                                      isRequired: false,
                                      boolImage: controller.boolImageCuti,
                                      image: controller.boolImageCuti.isTrue
                                          ? controller.imageCuti
                                          : null,
                                      onTap: controller.getImageCuti,
                                    )),
                                SizedBox(
                                  height: 50,
                                ),
                                CustomButton(
                                  onTap: controller.postAjukanCuti,
                                  text: 'Simpan',
                                  border: 30,
                                  color: kAccentColor,
                                )
                              ],
                            ),
                          ))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
