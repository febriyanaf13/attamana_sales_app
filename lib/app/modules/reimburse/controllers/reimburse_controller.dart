import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReimburseController extends GetxController {
  //TODO: Implement ReimburseController

  //file image Reimburse
  File? imageReimburse;
  var boolImageReimburse = false.obs;
  final formKey = GlobalKey<FormState>();
  var controllerFrom = ''.obs;
  var controllerTo = ''.obs;
  TextEditingController controllerJenis = TextEditingController();
  TextEditingController controllerAlasan = TextEditingController();

  final count = 0.obs;

  void increment() => count.value++;

  Future getImageReimburse() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo == null) return;

      final image = File(photo.path);
      boolImageReimburse.value = true;
      imageReimburse = image;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil gambar: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    update();
  }
}
