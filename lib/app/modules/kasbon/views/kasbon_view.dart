import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_datepicker_dialog.dart';
import '../../../components/custom_text_field.dart';
import '../../../style/colors.dart';
import '../../../style/paddings.dart';
import '../controllers/kasbon_controller.dart';

class KasbonView extends GetView<KasbonController> {
  const KasbonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Kasbon'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Container(
          //     width: Get.width,
          //     height: Get.height / 3,
          //     color: kWhiteColor,
          //     child: Image.asset('bg_kasbon'.jpg)),
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
                                // CustomDropdownButton(
                                //   title: 'Jenis Reimburse',
                                //   isRequired: true,
                                //   height: 60,
                                //   items: const [
                                //     {'text': 'Bensin', 'value': 'I'},
                                //     {'text': 'Kesehatan', 'value': 'C'}
                                //   ],
                                //   onChangeValue: (value) {
                                //     // controller.controllerJenis.text == value;
                                //   },
                                //   validator: 'Jenis ijin harus dipilih...!',
                                // ),
                                // const SizedBox(
                                //   height: kElementPadding,
                                // ),
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
                                      'Tuliskan Deskripsi Permohonan Kasbon...',
                                  isRequired: false,
                                  maxLine: 5,
                                  controller: TextEditingController(),
                                ),
                                // const SizedBox(
                                //   height: kElementPadding,
                                // ),
                                // Obx(() => CustomImagePicker(
                                //   title: 'Bukti',
                                //   isRequired: false,
                                //   boolImage: controller.boolImageReimburse,
                                //   image:
                                //   controller.boolImageReimburse.isTrue
                                //       ? controller.imageReimburse
                                //       : null,
                                //   onTap: controller.getImageReimburse,
                                // )),
                                SizedBox(
                                  height: 50,
                                ),
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
