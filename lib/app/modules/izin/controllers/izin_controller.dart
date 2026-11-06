import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IzinController extends GetxController {
  //TODO: Implement IzinController

  //file image Izin
  File? imageIzin;

  Future getImageCuti() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo == null) return;

      final image = File(photo.path);

      imageIzin = image;
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
