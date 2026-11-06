import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_datepicker_dialog.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_image_picker.dart';
import '../../../components/custom_text_field.dart';
import '../../../style/colors.dart';
import '../../../style/paddings.dart';
import '../controllers/terlambat_controller.dart';

class AddTerlambatView extends GetView<TerlambatController> {
  const AddTerlambatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Ijin Terlambat'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset('bg_terlambat'.jpg),
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
                                            controller.startDate.value = value;
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
                                  ],
                                ),
                                // const SizedBox(
                                //   height: kElementPadding,
                                // ),
                                // Obx(
                                //       () =>
                                //       CustomDropdownButton(
                                //         title: 'Jenis Cuti',
                                //         isRequired: true,
                                //         height: 60,
                                //         items: controller.listTipeCuti.value,
                                //         onChangeValue: (value) {
                                //           controller.controllerJenisCuti.text ==
                                //               value;
                                //         },
                                //         validator: 'Jenis ijin harus dipilih...!',
                                //       ),
                                // ),
                                const SizedBox(
                                  height: kElementPadding,
                                ),
                                CustomTextField(
                                  title: 'Alasan',
                                  hint: 'Tuliskan alasan permohonan cuti...',
                                  isRequired: true,
                                  maxLine: 5,
                                  controller: controller.controllerNotes,
                                ),
                                const SizedBox(
                                  height: kElementPadding,
                                ),
                                Obx(() => CustomImagePicker(
                                      title: 'Bukti',
                                      isRequired: true,
                                      boolImage: controller.boolImageTerlambat,
                                      image:
                                          controller.boolImageTerlambat.isTrue
                                              ? controller.imageTerlambat
                                              : null,
                                      onTap: controller.getImageTerlambat,
                                      validator: controller.validatorImage,
                                    )),
                                SizedBox(
                                  height: 50,
                                ),
                                Obx(() => controller
                                        .isLoadingSimpanterlambat.isTrue
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                        color: kPrimaryColor,
                                      ))
                                    : CustomButton(
                                        onTap: controller.postAjukanTerlambat,
                                        text: 'Simpan',
                                        border: 30,
                                        color: kAccentColor,
                                      ))
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
