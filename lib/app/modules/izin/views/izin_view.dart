import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_datepicker_dialog.dart';
import '../../../components/custom_text_field_title.dart';
import '../../../components/custom_timepicker_dialog.dart';
import '../../../style/colors.dart';
import '../controllers/izin_controller.dart';

class IzinView extends GetView<IzinController> {
  const IzinView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Izin'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset('bg_izin'.jpg),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // CustomDropdownButton(
                //   height: 50,
                //   hint: 'Jenis Izin',
                //   items: const [
                //     {'text': 'Izin Sakit', 'value': 'Izin Sakit'},
                //     {
                //       'text': 'Izin Urusan Keluarga',
                //       'value': 'Izin Urusan Keluarga'
                //     },
                //     {'text': 'Izin Terlambar', 'value': 'Izin Terlambar'},
                //   ],
                //   validator: 'Data harus diisi...!',
                //   onChangeValue: (value) {},
                // ),
                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      const CustomDateTimePickerDialog(
                        title: 'Tanggal Izin',
                        isRequired: true,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      const CustomTimePickerDialog(
                        title: '',
                        isRequired: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 124,
                  width: Get.width,
                  child: GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: kSecondaryTextColor)),
                      child: GetBuilder<IzinController>(
                        builder: (_) {
                          return controller.imageIzin == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    Text('Ambil Foto Bukti',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.file(
                                    controller.imageIzin!,
                                    fit: BoxFit.cover,
                                  ),
                                );
                        },
                      ),
                    ),
                    onTap: () {
                      controller.getImageCuti();
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                CustomTextFieldTitle(
                  withTitle: false,
                  controller: TextEditingController(),
                  title: 'Deskripsi',
                  hint: 'Masukan Deskripsi',
                  maxLine: 4,
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: Get.width,
                  child: CustomButton(
                      onTap: () {
                        // Get.toNamed(Routes.ADD_JOB_VISIT);
                      },
                      width: 200,
                      height: 50,
                      border: 30,
                      color: kSecondaryColor,
                      text: 'Submit'),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
