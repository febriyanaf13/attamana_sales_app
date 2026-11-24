import 'package:attamana_salles_app/app/modules/cuti/controllers/cuti_controller.dart';
import 'package:attamana_salles_app/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:attamana_salles_app/app/modules/staff_home/models/announcement.dart';
import 'package:attamana_salles_app/app/modules/staff_home/providers/staff_home_provider.dart';
import 'package:attamana_salles_app/app/modules/terlambat/controllers/terlambat_controller.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:attamana_salles_app/app/services/notifikasi_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';

class StaffHomeController extends GetxController {
  //TODO: Implement StaffHomeController

  //user data
  var nama = storage.read(kUserNama);
  var roles = storage.read(kRoleName);
  var foto = storage.read(kUserFoto);

  //controller
  var terlambatC = Get.put(TerlambatController());

  var currentIndexNews = 0.obs;
  var laporanController = Get.put(LaporanController());
  var cutiController = Get.put(CutiController());

  // final CarouselController controllerNews = CarouselController();
  List<int> list = [1, 2, 3, 4, 5];
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408440-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1940&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca40&auto=format&fit=crop&w=1940&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1408704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  // var listAnnounchement = [
  //   {
  //     'title': 'Inspeksi Mendadak',
  //     'desc': 'Kepada semua staff, akan diadakan inspeksi mendadak'
  //   },
  //   {
  //     'title': 'Inspeksi Mendadak',
  //     'desc': 'Kepada semua staff, akan diadakan inspeksi mendadak'
  //   },
  //   {
  //     'title': 'Inspeksi Mendadak',
  //     'desc': 'Kepada semua staff, akan diadakan inspeksi mendadak'
  //   },
  // ].obs;
  //
  var listAnnounchement = <Announcement>[].obs;

  var checkPresensiHariIni = ''.obs;
  var waktuIn = ''.obs;
  var waktuOut = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    checkAbsenHariIni();
    getAnnouncement();
    // VERSI 51: daftarkan HP untuk push notification & muat jumlah notifikasi belum dibaca
    if (Get.isRegistered<NotifikasiService>()) {
      NotifikasiService.to.daftarkanToken();
      NotifikasiService.to.muatJumlah();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // VERSI 51: notifikasi yang diketuk saat aplikasi masih tertutup dibuka setelah beranda tampil
    if (Get.isRegistered<NotifikasiService>()) {
      NotifikasiService.to.prosesTertunda();
    }
  }

  void checkAbsenHariIni() {
    StaffHomeProvider().checkPresensiHariIni().then((value) {
      if (value.status.isOk) {
        var message = value.body['message'];
        var data = value.body['data'];
        checkPresensiHariIni.value = message.toString();
        print('ini $checkPresensiHariIni');
        if (data['waktu_in'] != null) {
          waktuIn.value =
              DateFormat('HH:mm').format(DateTime.parse(data['waktu_in']));
        }
        if (data['waktu_out'] != null) {
          waktuOut.value =
              DateFormat('HH:mm').format(DateTime.parse(data['waktu_out']));
        }
      }
    });
  }

  void getAnnouncement() {
    StaffHomeProvider().getAnnouncement().then((value) {
      if (value.status.isOk) {
        // var message = value.body['message'];
        var data = value.body['data'];
        listAnnounchement.value = announcementFromJson(data);
      }
    });
  }
}
