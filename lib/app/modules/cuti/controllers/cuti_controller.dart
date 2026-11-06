import 'dart:io';

import 'package:attamana_salles_app/app/components/custom_dialog.dart';
import 'package:attamana_salles_app/app/modules/cuti/models/cuti.dart';
import 'package:attamana_salles_app/app/modules/cuti/models/tipe_cuti.dart';
import 'package:attamana_salles_app/app/modules/cuti/providers/cuti_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CutiController extends GetxController {
  //TODO: Implement CutiController

  //file image Cuti
  File? imageCuti;
  var boolImageCuti = false.obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerFrom = TextEditingController();
  TextEditingController controllerTo = TextEditingController();

  // TextEditingController controllerJenisCuti = TextEditingController();
  TextEditingController controllerLamaCuti = TextEditingController();
  TextEditingController controllerAlasan = TextEditingController();

  //variable
  var jenisCuti = ''.obs;
  var tglMulai =
      '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}'
          .obs;

  //variable list
  var listTipeCuti = <Map<String, Object>>[
    // {'text': 'SAKIT', 'value': 'SENIN'},
    // {'text': 'MELAHIRKAN', 'value': 'SELASA'},
    // {'text': 'HOLIDAY', 'value': 'RABU'},
  ].obs;

  var listAllCutiSaya = <Cuti>[].obs;

  @override
  void onInit() {
    getTipeCuti();
    getAllPengajuanCuti();
    super.onInit();
  }

  Future getImageCuti() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo == null) return;

      final image = File(photo.path);
      boolImageCuti.value = true;
      imageCuti = image;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil gambar: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      // toast('Gagal mengambil gambar : $e');
    }
    update();
  }

  void getTipeCuti() {
    CutiProvider().getTipeCuti().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        var listData = tipeCutiFromJson(data);
        for (var list in listData) {
          listTipeCuti.add(
            {'text': list.namaTipe, 'value': list.id},
          );
        }
        print(listTipeCuti);
      } else {
        // dialogError('Error ${value.statusCode}', '${value.statusText}');
      }
    });
  }

  void getAllPengajuanCuti() {
    CutiProvider().getAllPengajuanCuti().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];

        print('getAllPengajuanCuti $data');
        listAllCutiSaya.value = cutiFromJson(data);
      } else {
        // dialogError('Error ${value.statusCode}', '${value.statusText}');
      }
    });
  }

  void getAllPengajuanCutiById(id) {
    CutiProvider().getPengajuanCutiById(id).then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];

        print('getAllPengajuanCutiById $data');
      } else {
        // dialogError('Error ${value.statusCode}', '${value.statusText}');
      }
    });
  }

  void postAjukanCuti() {
    if (formKey.currentState!.validate()) {
      var body = {
        'tipe_cuti_id': jenisCuti.value,
        'start_date': tglMulai.value,
        'days': int.parse(controllerLamaCuti.text),
        'note': controllerAlasan.text.toString(),
      };
      print(body);
      CutiProvider().postPengajuanCuti(body).then((value) {
        var success = value.body['success'];
        if (value.status.isOk) {
          var message = value.body['message'];
          if (success) {
            dialogSuccess('Sukses', message);
          } else {
            dialogWarning('Warning', message);
          }
        } else if (value.status.isServerError) {
          dialogError('Terjadi Kesalahan',
              'Terjadi masalah pada server / koneksi internet lambat');
        } else if (value.status.connectionError) {
          dialogError('Tidak ada koneksi',
              'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        }
      });
    }
  }

  void updatePengajuanCuti(id) {
    if (formKey.currentState!.validate()) {
      var body = {
        'tipe_cuti_id': jenisCuti.value,
        'start_date': controllerFrom.text.toString(),
        'days': int.parse(controllerLamaCuti.text),
        'note': controllerAlasan.text.toString(),
      };
      CutiProvider().updatePengajuanCuti(id, body).then((value) {
        var success = value.body['success'];

        if (value.status.isOk) {
          var message = value.body['message'];

          if (success) {
            var data = value.body['data'];
            dialogSuccess('Sukses', message);
          } else {
            dialogWarning('Warning', message);
          }
        } else if (value.status.isServerError) {
          dialogError('Terjadi Kesalahan',
              'Terjadi masalah pada server / koneksi internet lambat');
        } else if (value.status.connectionError) {
          dialogError('Tidak ada koneksi',
              'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        }
      });
    }
  }

  void deletePengajuanCuti(id) {
    CutiProvider().deletePengajuanCuti(id).then((value) {
      if (value.status.isOk) {
        var success = value.body['success'];
        var message = value.body['message'];
        var data = value.body['data'];

        print('deletePengajuanCuti $data');
      } else if (value.status.isServerError) {
        dialogError('Terjadi Kesalahan',
            'Terjadi masalah pada server / koneksi internet lambat');
      } else if (value.status.connectionError) {
        dialogError('Tidak ada koneksi',
            'Jaringan internet bermasalah, silahkan cek koneksi internet!');
      }
    });
  }
}
