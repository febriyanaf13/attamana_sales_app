import 'dart:io';

import 'package:attamana_salles_app/app/components/custom_awesome_dialog.dart';
import 'package:attamana_salles_app/app/modules/kendaraan/models/bensin.dart';
import 'package:attamana_salles_app/app/modules/kendaraan/models/kendaraan.dart';
import 'package:attamana_salles_app/app/modules/kendaraan/providers/kendaraan_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/custom_dialog.dart';

class KendaraanController extends GetxController {
  //TODO: Implement KendaraanController

  final formKeyBensin = GlobalKey<FormState>();
  TextEditingController controllerJenisKendaraan = TextEditingController();
  TextEditingController controllerTanggal = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString());
  TextEditingController controllerOdometer = TextEditingController();
  TextEditingController controllerLiter = TextEditingController();
  TextEditingController controllerHargaPerLiter = TextEditingController();
  TextEditingController controllerNotes = TextEditingController();

  var listKendaraan = <Kendaraan>[].obs;
  var listBensin = <Bensin>[].obs;
  var listKendaraanDropdown = <Map<String, Object>>[].obs;

  //file image Bensin
  File? imageBensin;
  var boolImageBensin = false.obs;

  //loading
  var isLoadingSimpanBensin = false.obs;

  @override
  void onInit() {
    getKendaraan();
    getBensin();
    clearFormBensin();
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

  void clearFormBensin() {
    controllerJenisKendaraan.clear();
    controllerTanggal.clear();
    controllerLiter.clear();
    controllerOdometer.clear();
    controllerHargaPerLiter.clear();
    controllerNotes.clear();
  }

  void getKendaraan() {
    KendaraanProvider().getKendaraan().then((value) {
      if (value.status.isOk) {
        var data = value.body;
        if (kDebugMode) {
          print(data);
        }
        listKendaraan.value = kendaraanFromJson(data);
        for (var list in listKendaraan) {
          print(list.tipeFixedassetId);
          listKendaraanDropdown.add(
            {
              'text': '${list.kodeAsset} - ${list.namaAsset}',
              'value': list.id.toString()
            },
          );
        }
      }
    });
  }

  void getBensin() {
    KendaraanProvider().getBensin().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        print(data);
        listBensin.value = bensinFromJson(data);
      }
    });
  }

  void onTapSimpanCatatanBensin() {
    if (formKeyBensin.currentState!.validate()) {
      isLoadingSimpanBensin.toggle();
      var body = FormData({
        'fixedasset_id': controllerJenisKendaraan.text,
        'fill_up_date': controllerTanggal.text,
        'odometer': controllerOdometer.text,
        'liter': controllerLiter.text,
        'harga_per_liter': controllerLiter.text,
        'bukti': MultipartFile(imageBensin, filename: 'image'),
        'notes': controllerNotes.text,
      });

      KendaraanProvider().postBensin(body).then((value) {
        isLoadingSimpanBensin.toggle();

        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          if (value.status.isOk) {
            dialogSuccess('Sukses', message);
          } else {
            dialogError('Ops...', message);
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

  void deleteBensin() {
    KendaraanProvider().deleteBensin().then((value) {
      if (value.status.isOk) {
        var message = value.body['message'];
        awesomeDialogSuccess('Sukses', '$message');
      }
    });
  }

  Future getImageBukti() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo == null) return;

      final image = File(photo.path);
      boolImageBensin.value = true;
      imageBensin = image;
    } catch (e) {
      toast('Gagal mengambil gambar : $e');
    }
    update();
  }
}
