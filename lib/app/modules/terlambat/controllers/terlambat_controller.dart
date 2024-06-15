import 'dart:io';

import 'package:attamana_salles_app/app/modules/terlambat/models/terlambat.dart';
import 'package:attamana_salles_app/app/modules/terlambat/providers/terlambat_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/custom_dialog.dart';

class TerlambatController extends GetxController {
  //TODO: Implement TerlambatController
  File? imageTerlambat;
  var boolImageTerlambat = false.obs;
  var validatorImage = false.obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerStartDate = TextEditingController();
  TextEditingController controllerNotes = TextEditingController();

  //loadng
  var isLoadingSimpanterlambat = false.obs;
  var startDate =
      '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}'
          .obs;

  var listTerlambatSaya = <Terlambat>[].obs;

  @override
  void onInit() {
    getAllTerlambatSaya();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future getImageTerlambat() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo == null) return;

      final image = File(photo.path);
      boolImageTerlambat.value = true;
      imageTerlambat = image;
      validatorImage(false);
    } catch (e) {
      toast('Gagal mengambil gambar : $e');
    }
    update();
  }

  void getAllTerlambatSaya() {
    TerlambatProvider().getAllPengajuanTerlambat().then((value) {
      if (value.status.isOk) {
        var success = value.body['success'];
        if (success) {
          var data = value.body['data'];
          listTerlambatSaya.value = terlambatFromJson(data);
          // dialogSuccess('Sukses', message);
        } else {
          var message = value.body['message'];
          dialogWarning('Warning', message);
        }
      } else {
        dialogError('Error ${value.statusCode}', '${value.statusText}');
      }
    });
  }

  void postAjukanTerlambat() {
    if (formKey.currentState!.validate()) {
      if (imageTerlambat == null) {
        validatorImage(true);
      } else {
        isLoadingSimpanterlambat.toggle();
        validatorImage(false);
        var body = FormData({
          'start_date': startDate.value.toString(),
          'note': controllerNotes.text.toString(),
          'bukti': MultipartFile(
            imageTerlambat,
            filename: 'imageTerlambat ${DateTime.now()}',
          ),
        });
        print(body);
        TerlambatProvider().postPengajuanTerlambat(body).then((value) {
          isLoadingSimpanterlambat.toggle();
          print(value.body);

          // var success = value.body['success'];
          if (value.status.isOk) {
            var message = value.body['message'];
            // if (success) {
            dialogSuccess('Sukses', message);
            // } else {
            //   dialogWarning('Warning', message);
            // }
          } else if (value.status.isServerError) {
            dialogError('Terjadi Kesalahan',
                'Terjadi masalah pada server / koneksi internet lambat');
          } else if (value.status.connectionError) {
            dialogError('Tidak ada koneksi',
                'Jaringan internet bermasalah, silahkan cek koneksi internet!');
          }
        });
      }
    } else {
      validatorImage(true);
    }
  }
}
