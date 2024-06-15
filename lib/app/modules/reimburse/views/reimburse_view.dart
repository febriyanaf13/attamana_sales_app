import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_datepicker_dialog.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_image_picker.dart';
import '../../../components/custom_text_field.dart';
import '../../../style/paddings.dart';
import '../controllers/reimburse_controller.dart';

class ReimburseView extends GetView<ReimburseController> {
  const ReimburseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Reimburse'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset('bg_reimburse'.jpg),
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
                                CustomDateTimePickerDialog(
                                  title: 'Pengajuan',
                                  onDataChange: (value) {
                                    if (value != null) {
                                      // controller.controllerFrom.value =
                                      //     value;
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
                                CustomDropdownButton(
                                  title: 'Jenis Reimburse',
                                  isRequired: true,
                                  height: 60,
                                  items: const [
                                    {'text': 'Bensin', 'value': 'I'},
                                    {'text': 'Kesehatan', 'value': 'C'}
                                  ],
                                  onChangeValue: (value) {
                                    // controller.controllerJenis.text == value;
                                  },
                                  validator: 'Jenis ijin harus dipilih...!',
                                ),
                                const SizedBox(
                                  height: kElementPadding,
                                ),
                                CustomTextField(
                                  title: 'Expenses',
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
                                  controller: TextEditingController(),
                                ),
                                const SizedBox(
                                  height: kElementPadding,
                                ),
                                CustomTextField(
                                  title: 'Deskripsi',
                                  hint:
                                      'Tuliskan Deskripsi permohonan Reimburse...',
                                  isRequired: false,
                                  maxLine: 5,
                                  controller: TextEditingController(),
                                ),
                                const SizedBox(
                                  height: kElementPadding,
                                ),
                                Obx(() => CustomImagePicker(
                                      title: 'Bukti',
                                      isRequired: false,
                                      boolImage: controller.boolImageReimburse,
                                      image:
                                          controller.boolImageReimburse.isTrue
                                              ? controller.imageReimburse
                                              : null,
                                      onTap: controller.getImageReimburse,
                                    )),
                                50.height,
                                CustomButton(
                                  onTap: () {},
                                  text: 'Ajukan',
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
