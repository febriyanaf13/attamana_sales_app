import 'dart:convert';
import 'dart:io';

import 'package:attamana_salles_app/app/components/custom_dialog.dart';
import 'package:attamana_salles_app/app/modules/customer/models/customer.dart';
import 'package:attamana_salles_app/app/modules/maps/controllers/maps_controller.dart';
import 'package:attamana_salles_app/app/modules/sales_module/activity/models/jenis_kunjungan.dart';
import 'package:attamana_salles_app/app/modules/splash/controllers/splash_controller.dart';

import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:awesome_dialog/awesome_dialog.dart' as awd;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_field.dart';
import '../../../../style/colors.dart';
import '../../../../utils/constants.dart';
import '../../../maps/models/lokasi_absen.dart';
import '../models/activity.dart';
import '../models/existing_customer.dart';
import '../models/lead.dart';
import '../models/pendamping.dart';
import '../providers/activity_provider.dart';

class ActivityController extends GetxController {
  //TODO: Implement ActivityController

  final formKey = GlobalKey<FormState>();
  final formKeyCatatanCheckOut = GlobalKey<FormState>();

  //text editing controller
  var textEditingControllerNama = TextEditingController();
  var textEditingControllerAlamat = TextEditingController();
  var textEditingControllerDeskripsi = TextEditingController();
  var textEditingControllerCatatan = TextEditingController();
  var textEditingControllerAction = TextEditingController();

  // VERSI 53: pendamping
  var textEditingControllerPendamping = TextEditingController();
  var listPendamping = <Pendamping>[].obs;
  var pendampingId = ''.obs;
  var isLoadingUbahLokasi = false.obs;

  //variable list
  var listActivity = <Activity>[].obs;
  var listExistingCustomer = <Map<String, String>>[].obs;
  var listExistingCustomer2 = <ExistingCustomer>[].obs;
  var listNewCustomer = <Map<String, String>>[].obs;
  var listActivityOpenProgress = <Activity>[].obs;
  var listActivityCompleted = <Activity>[].obs;
  var listLokasiAbsen = <LokasiAbsen?>[].obs;

  var listKoorPolygonGedung = <LatLng>[].obs;
  var listLeadData = <Lead>[].obs;
  var listMyLead = <Lead>[].obs;
  var listOpportunities = <Lead>[].obs;
  var listDone = <Lead>[].obs;
  var listJunk = <Lead>[].obs;

  //variable
  var ketcustomer = 'EXISTING'.obs;
  var customerId = ''.obs;
  var action = ''.obs;
  var selectedLatitude = 0.0.obs;
  var selectedLongitude = 0.0.obs;

  // var listAction = [
  //   {'text': 'OFFERING PRODUCT', 'value': 'OFFERING PRODUCT'},
  //   {'text': 'VISIT CUSTOMER', 'value': 'VISIT CUSTOMER'},
  //   {'text': 'MEETING', 'value': 'MEETING'},
  //   {'text': 'AMBIL SAMPLE', 'value': 'AMBIL SAMPLE'},
  //   {'text': 'CHAT / EMAIL', 'value': 'CHAT / EMAIL'},
  //   {'text': 'EVENT', 'value': 'EVENT'},
  //   {'text': 'OTHER', 'value': 'OTHER'},
  //   {'text': 'SALES CALL / WHATSAPP', 'value': 'SALES CALL / WHATSAPP'},
  // ].obs;
  var listAction = <Map<String, Object>>[].obs;

  var listButuhLokasi = [
    'OFFERING PRODUCT',
    'VISIT CUSTOMER',
    'MEETING',
    'AMBIL SAMPLE',
  ];
  var listTidakButuhLokasi = [
    'CHAT / EMAIL',
    'EVENT',
    'OTHER',
    'SALES CALL / WHATSAPP',
  ];
  var locationCheckIn = ''.obs;
  var locationCheckOut = ''.obs;
  var tglVisit =
      '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}'
          .obs;
  late var detailActivity;

  //data user
  var userId = storage.read(kUserId);

  //isLoading
  var isLoadingSimpanActivity = false.obs;
  var isLoadingSimpanCatatanCheckout = false.obs;
  var loadingAbsenMasuk = false.obs;
  var loadingAbsenPulang = false.obs;

  // image
  var boolImage = false.obs;
  var isLoadingUploadFotoCheckIn = false.obs;
  File? imageBukti;

  var listCustomerVisit = [
    {
      'nama': 'Hotel Grand Edge',
      'alamat': 'Jl. Semarang Indah No 13',
      'desc': 'Melakukan Negosiasi'
    },
    {
      'nama': 'Hotel Pandanaran',
      'alamat': 'Jl. Pandanaran Indah No 10',
      'desc': 'Melakukan Kerjasama Proyek Baru'
    },
    {
      'nama': 'Hotel Loise Kiene',
      'alamat': 'Jl. Semarang Selatan No 09',
      'desc': 'Melakukan Kunjungan Dengan Bos Hotel Semarang indah'
    },
  ].obs;

  final count = 0.obs;

  RxString? customer;

  //google maps
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  void onInit() {
    // TODO: implement onInit
    getListActivity();
    getCustomerExisting();
    getJenisKunjungan();
    getLead();
    getListPendamping();

    super.onInit();
  }

  void resetForm() {
    customerId.value = '';
    action.value = '';
    tglVisit.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // VERSI 53
    pendampingId.value = '';
    textEditingControllerPendamping.clear();
    selectedLatitude.value = 0.0;
    selectedLongitude.value = 0.0;

    // Bersihkan semua text controller
    textEditingControllerDeskripsi.clear();
    textEditingControllerAction.clear();
    textEditingControllerNama.clear();
    textEditingControllerAlamat.clear();
  }

  void getListActivity() {
    listActivityOpenProgress.clear();
    listActivityCompleted.clear();
    DateTime now = DateTime.now(); // Tanggal saat ini
    DateTime lastWeek =
        now.subtract(const Duration(days: 7)); // Kurangi 1 minggu
    String formattedDate = DateFormat('yyyy-MM-dd').format(lastWeek);
    print(formattedDate);
    var body = {'userid': userId, 'filter_tanggal': formattedDate.toString()};
    ActivityProvider().postReqListVisit(body).then((value) {
      if (kDebugMode) {
        print(value.body);
      }
      if (value.status.isOk) {
        var data = value.body['data'];
        print("data list activity $data");
        listActivity.value = activityFromJson(data);
        // VERSI 53: hanya CHECK OUT yang selesai. Activity dari web (MENUNGGU APPROVAL / APPROVE) tetap di tab Open
        // agar bisa check-in; activity REJECT juga di Open supaya bisa diperbaiki (dulu semuanya masuk Completed).
        for (var list in listActivity) {
          if (list.status == 'CHECK OUT') {
            listActivityCompleted.add(list);
          } else {
            listActivityOpenProgress.add(list);
          }
        }
      }
    });
  }

  void getDetailActivity(visitId, route, perluAbsen) {
    ActivityProvider().getDetailVisit(visitId).then((value) {
      if (kDebugMode) {
        print(value.body);
      }
      if (value.status.isOk) {
        var data = value.body['data'];
        // VERSI 53: tombol "MULAI KUNJUNGAN" mengirim route OPEN (dulu tidak ditangani -> tidak terjadi apa-apa)
        if (route == 'MAPS' || route == 'OPEN' || route == 'COMPLETED') {
          Get.toNamed(Routes.MAPS_VIEW, arguments: {
            'idKunjungan': data['id'],
            'action': data['action'],
            'lokasiRadius': data['lokasi_radius'] ?? '',
            'route': route,
            'lokasiCheckIn': data['lokasi_checkin'],
            'lokasiCheckOut': data['lokasi_checkout'],
            'waktuCheckin': data['waktu_checkin'],
            'waktuCheckout': data['waktu_checkout'],
            'notulen': data['notulen'],
            // VERSI 53: lokasi bertemu terbaru & hak ubah lokasi
            'lokasi': data['lokasi'] ?? '',
            'statusLokasi': data['status_lokasi'] ?? '',
            'bisaUbahLokasi': data['bisa_ubah_lokasi'] == true,
            'pesanUbahLokasi': data['pesan_ubah_lokasi'] ?? '',
            'radiusMeter':
                int.tryParse('${data['radius_meter'] ?? 500}') ?? 500,
            'statusLabel': data['status_label'] ?? '',
            'bisaAbsen': data['bisa_absen'] != false,
            'alasanTolak': data['alasan_tolak'] ?? '',
          });
        } else if (route == 'EDIT') {
          // VERSI 53: isi form dengan data activity (dulu form edit kosong)
          customerId.value = '${data['customer_id'] ?? ''}';
          final cust = listExistingCustomer2.firstWhereOrNull(
              (e) => e.customerId.toString() == customerId.value);
          textEditingControllerNama.text = cust?.namaHotel ?? '';
          tglVisit.value = '${data['tgl_awal'] ?? ''}'.split(' ').first;
          action.value = '${data['action'] ?? ''}';
          textEditingControllerDeskripsi.text = '${data['notulen'] ?? ''}';
          textEditingControllerAlamat.text = '${data['lokasi'] ?? ''}';
          selectedLatitude.value = 0.0;
          selectedLongitude.value = 0.0;
          pendampingId.value = '${data['sales_id2'] ?? ''}';
          Get.toNamed(Routes.ADD_ACTIVITY, arguments: data['id']);
        }
        print(value.bodyString!);
      }
    });
  }

  Future<void> getCustomerExisting() async {
    ActivityProvider().getExistingCustomer().then((value) {
      if (kDebugMode) {
        print("ini custommer existing ${value.body['data']}");
      }
      if (value.status.isOk) {
        var data = value.body['data'];
        listExistingCustomer.value = existingCustomerFromJson(data)
            .map((e) => {'text': e.namaHotel, 'value': e.customerId.toString()})
            .toList();
        listExistingCustomer2.value = existingCustomerFromJson(data);
      }
    });
  }

  void getJenisKunjungan() {
    ActivityProvider().getJenisKunjungan().then((value) {
      if (kDebugMode) {
        print(value.body);
      }
      if (value.status.isOk) {
        var data = value.body['data'];
        listAction.value = jenisKunjunganFromJson(data)
            .map((e) => {'text': e.nama, 'value': e.nama.toString()})
            .toList();
      }
    });
  }

  void getDataCustomerVisit(namaCustomer) {
    for (var element in listCustomerVisit) {
      if (element['nama'] == namaCustomer) {
        textEditingControllerNama.text = element['nama']!;
        textEditingControllerAlamat.text = element['alamat']!;
        textEditingControllerDeskripsi.text = element['desc']!;
      }
    }
  }

  void postSimpanActivity() {
    SplashController().reqToken();
    if (formKey.currentState!.validate()) {
      isLoadingSimpanActivity.toggle();
      var body = {
        'ketcustomer': ketcustomer.value,
        'customer_id': customerId.value,
        'sales_id': userId,
        'tgl_awal': tglVisit.value,
        'action': action.value,
        'lokasi': textEditingControllerNama.text,
        'notulen': textEditingControllerDeskripsi.text,
        // VERSI 53: pendamping & titik lokasi bertemu yang dipilih di peta
        'sales_id2': pendampingId.value,
        if (selectedLatitude.value != 0.0 &&
            selectedLongitude.value != 0.0) ...{
          'alamat_lokasi': textEditingControllerAlamat.text,
          'latitude': selectedLatitude.value.toString(),
          'longitude': selectedLongitude.value.toString(),
        },
      };
      if (kDebugMode) {
        print(body);
      }
      print('coba cek error');

      // ActivityProvider().postSimpanActivity(body).then((value) {
      //   isLoadingSimpanActivity.toggle();
      //
      //   if (kDebugMode) {
      //     print(value.body);
      //   }
      //
      //   if (value.status.isOk) {
      //     var success = value.body['success'];
      //     var message = value.body['message'];
      //     print(success);
      //     if (success) {
      //       Get.back();
      //       getListActivity();
      //       dialogSuccess('Success', message);
      //     } else {
      //       dialogWarning('Ops...', message);
      //     }
      //   } else if (value.status.isServerError) {
      //     dialogError('Terjadi Kesalahan',
      //         'Terjadi masalah pada server / koneksi internet lambat');
      //   } else if (value.status.connectionError) {
      //     dialogError('Koneksi Gagal',
      //         'Tidak dapat terhubung ke server. Silakan periksa koneksi internet Anda dan coba lagi!');
      //   }
      // });

      ActivityProvider().postSimpanActivity(body).then((value) {
        isLoadingSimpanActivity.toggle();

        if (kDebugMode) {
          print(value.body);
          print(value.status.code); // debug status
        }

        if (value.status.isOk) {
          final success = value.body['success'] ?? false;
          final message = value.body['message'] ?? '';

          if (success) {
            Get.until((route) => route.settings.name == Routes.ACTIVITY);
            getListActivity();
            dialogSuccess('Success', message);
          } else {
            dialogWarning('Ops...', message);
          }
        } else if (value.status.isServerError) {
          dialogError(
            'Terjadi Kesalahan',
            'Terjadi masalah pada server / koneksi internet lambat',
          );
        } else if (value.status.connectionError) {
          // dialogError('Koneksi Gagal',
          //     'Tidak dapat terhubung ke server. Silakan periksa koneksi internet Anda dan coba lagi!');

          awd.AwesomeDialog(
                  context: Get.context!,
                  dialogType: awd.DialogType.error,
                  animType: awd.AnimType.topSlide,
                  title: 'Koneksi Gagal',
                  desc:
                      'Tidak dapat terhubung ke server. Silakan periksa koneksi internet Anda dan coba lagi!',
                  btnOkText: 'Refresh Page',
                  btnOkOnPress: () async {
                    final SplashController splashC =
                        Get.find<SplashController>();
                    await splashC.reqToken();
                    await Get.offNamed(Routes.ACTIVITY);
                  },
                  btnCancelText: 'Re-login',
                  btnCancelOnPress: () async {
                    await storage.remove('session');
                    // storage.remove('userData');

                    Get.offAllNamed(
                      Routes.LOGIN,
                    );
                  },
                  btnOkIcon: Icons.refresh,
                  btnOkColor: Colors.blue,
                  btnCancelIcon: Icons.login,
                  btnCancelColor: Colors.green)
              .show();
        } else {
          dialogError(
            'Gagal',
            'Kode error: ${value.status.code}',
          );
        }
      }).catchError((e) {
        isLoadingSimpanActivity.toggle();
        dialogError(
          'Error',
          e.toString(),
        );
      });
    }
  }

  void updateActivity(visitId) {
    if (formKey.currentState!.validate()) {
      isLoadingSimpanActivity.toggle();
      var body = {
        'kunjungan_id': visitId,
        'ketcustomer': ketcustomer.value,
        'customer_id': customerId.value,
        'sales_id': userId,
        'tgl_awal': tglVisit.value,
        'action': action.value,
        'lokasi': textEditingControllerNama.text,
        'notulen': textEditingControllerDeskripsi.text,
        // VERSI 53: '' = hapus pendamping. Lokasi bertemu tidak diubah dari form edit (pakai "Ubah lokasi bertemu")
        'sales_id2': pendampingId.value,
        if (selectedLatitude.value != 0.0 &&
            selectedLongitude.value != 0.0) ...{
          'alamat_lokasi': textEditingControllerAlamat.text,
          'latitude': selectedLatitude.value.toString(),
          'longitude': selectedLongitude.value.toString(),
        },
      };
      if (kDebugMode) {
        print(body);
      }

      ActivityProvider().updateActivity(body).then((value) {
        isLoadingSimpanActivity.toggle();

        if (kDebugMode) {
          print(value.body);
        }

        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          print(success);
          if (success) {
            Get.back();
            getListActivity();
            dialogSuccess('Success', message);
          } else {
            dialogWarning('Ops...', message);
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

  void postPresensiActivity(activityId, status, lokasi, notulen) {
    var body = {
      'kunjungan_id': activityId,
      'status': status,
      'lokasi': lokasi,
    };

    textEditingControllerCatatan.text = notulen;
    print("notulen1 : $notulen");
    print("notulen2 : ${textEditingControllerCatatan.text}");

    if (status == 'CHECK IN') {
      boolImage(false);
      loadingAbsenMasuk.toggle();

      getDialogPostImage(activityId, body, 'YA');
    } else {
      Get.dialog(
        AlertDialog(
          title: Center(child: const Text("Notulen")),
          content: Form(
            key: formKeyCatatanCheckOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomTextField(
                  title: 'Notulen',
                  hint: 'Tuliskan notulen...',
                  isRequired: true,
                  maxLine: 5,
                  inputType: TextInputType.text,
                  controller: textEditingControllerCatatan,
                ),
                SizedBox(
                  height: 30,
                ),
                Obx(
                  () => isLoadingSimpanCatatanCheckout.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kAccentColor,
                          ),
                        )
                      : CustomButton(
                          onTap: () {
                            Get.back();
                            isLoadingSimpanCatatanCheckout.toggle();
                            loadingAbsenPulang.toggle();

                            var body = {
                              'kunjungan_id': activityId,
                              'status': status,
                              'lokasi': lokasi,
                              'notulen': textEditingControllerCatatan.text,
                            };
                            ActivityProvider()
                                .postPresensiActivity(body)
                                .then((value) {
                              loadingAbsenPulang.toggle();
                              isLoadingSimpanCatatanCheckout.toggle();

                              if (kDebugMode) {
                                print(value.body);
                              }
                              if (value.status.isOk) {
                                print('test body catatan : $body');
                                var message = value.body['message'];
                                // print(object)
                                // if (status == 'CHECK IN') {
                                //   boolImage(false);
                                //   var success = value.body['success'];
                                //   if (success == true) {
                                //     // dialogSuccess('Success', message);
                                //     // getDialogPostImage(activityId, 'YA');
                                //   } else {
                                //     dialogWarning('Ops...', message);
                                //   }
                                // } else {
                                var success = value.body['success'];
                                if (success == true) {
                                  Get.back();
                                  dialogSuccess('Success', message);
                                  getListActivity();
                                } else {
                                  dialogWarning('Ops...', message);
                                }
                                // }
                              } else if (value.status.isServerError) {
                                dialogError('Terjadi Kesalahan',
                                    'Terjadi masalah pada server / koneksi internet lambat');
                              } else if (value.status.connectionError) {
                                dialogError('Tidak ada koneksi',
                                    'Jaringan internet bermasalah, silahkan cek koneksi internet!');
                              }
                            });
                          },
                          text: 'Kirim',
                          border: 30,
                          color: kAccentColor,
                        ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  showDilarangMenggunakanMockLocaton() {
    return dialogError('Error',
        'Anda dideteksi menggunakan mock lockator, mohon dinonaktifkan.');
  }

  void clearTextEditingController() {
    textEditingControllerNama.clear();
    textEditingControllerAlamat.clear();
    textEditingControllerDeskripsi.clear();
  }

  void getLead() {
    ActivityProvider().getLead(userId).then((value) {
      if (kDebugMode) {
        print(value.body);
      }
      var data = value.body['data'];
      if (value.status.isOk) {
        listLeadData.value = leadFromJson(data);
        listMyLead.value = listLeadData
            .where((element) =>
                element.status.toUpperCase().contains('NULL') ||
                element.status.toUpperCase().contains('NEW') ||
                element.status.toUpperCase().contains('OPEN') ||
                element.status.toUpperCase().contains('REPLIED'))
            .toList();
        print(listMyLead.length);
        listOpportunities.value = listLeadData
            .where((element) =>
                element.status.toUpperCase().contains('OPPORTUNITY') ||
                element.status.toUpperCase().contains('SET TO QUOTATION') ||
                element.status.toUpperCase().contains('CONVERTED') ||
                element.status.toUpperCase().contains('COLD CALL'))
            .toList();
        print(listOpportunities.length);
        listJunk.value = listLeadData
            .where((element) => element.status.toUpperCase().contains('JUNK'))
            .toList();
        print(listJunk.length);

        listDone.value = listLeadData
            .where(
                (element) => element.status.toUpperCase().contains('SELESAI'))
            .toList();
        print(listDone.length);
      }

      listNewCustomer.value = listLeadData
          .map((e) => {
                'text': '${e.kode} (${e.namaHotel})',
                'value': e.leadId.toString()
              })
          .toList();

      print(listOpportunities.length);
    });
  }

  Future getDialogPostImage(activityId, bodyCheckIn, perluAbsen) {
    isLoadingUploadFotoCheckIn(false);
    return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        // Disables tapping outside to dismiss the dialog
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false; // Prevents the back button from dismissing the dialog
            },
            child: CupertinoAlertDialog(
                title: const Text("Upload Foto"),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        Get.back();
                        getImageBukti(
                            'Gallery', activityId, perluAbsen, bodyCheckIn);
                      },
                      child: const Text("Gallery")),
                  CupertinoDialogAction(
                      onPressed: () async {
                        Get.back();
                        getImageBukti(
                            'Camera', activityId, perluAbsen, bodyCheckIn);
                      },
                      child: const Text("Camera")),
                  Obx(() => boolImage.isTrue
                      ? CupertinoDialogAction(
                          onPressed: () async {
                            if (perluAbsen.contains('YA')) {
                              postImageCheckIn(activityId, bodyCheckIn);
                              print('masuk perlu lokasi :$perluAbsen');
                            } else if (perluAbsen.contains('TIDAK')) {
                              print('masuk tidak perlu lokasi :$perluAbsen');
                              getLokasiTerkini(activityId);
                            }
                          },
                          child: const Text("Kirim"))
                      : const SizedBox())
                ],
                content: SizedBox(
                  height: 200,
                  width: Get.width,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kInputBorderColor)),
                      child: Obx(
                        () => boolImage.isFalse
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 50,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Ambil Foto Bukti',
                                    style: Get.textTheme.bodyMedium
                                        ?.copyWith(color: kSecondaryTextColor),
                                  )
                                ],
                              )
                            : Obx(() => isLoadingUploadFotoCheckIn.isTrue
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      imageBukti!,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )),
                      )),
                )),
          );
        });
  }

  Future getImageBukti(String type, activityId, perluAbsen, bodyCheckIn) async {
    try {
      final photo = await ImagePicker().pickImage(
          source: type == 'Camera' ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50);
      if (photo == null) return;

      final image = File(photo.path);
      boolImage.value = true;
      imageBukti = image;
      getDialogPostImage(activityId, bodyCheckIn, perluAbsen);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengambil gambar: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    update();
  }

  getLokasiTerkini(activityId) async {
    LatLng? centerPosition;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (position.isMocked) {
      MapsController().showDilarangMenggunakanMockLocaton();
    } else {
      centerPosition = LatLng(position.latitude, position.longitude);
      // '(${centerPosition!.latitude}, ${centerPosition!.longitude})'
      postKunjunganAutoCheckOutActivity(activityId,
          '(${centerPosition.latitude}, ${centerPosition.longitude})');
    }
  }

  void postImageCheckIn(activityId, bodyCheckIn) {
    isLoadingUploadFotoCheckIn.toggle();
    var body = FormData({
      'kunjungan_id': activityId,
      'file_foto': imageBukti == null
          ? ""
          : MultipartFile(imageBukti,
              filename: '${DateTime.now().toString()}.png'),
    });
    if (bodyCheckIn == "TIDAK") {
      ActivityProvider().postImageCheckIn(body).then((value) {
        isLoadingUploadFotoCheckIn.toggle();
        print(value.body);
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          if (success == true) {
            dialogSuccess('Success', message);
          } else {
            dialogWarning('Ops...', message);
          }
          Get.offNamed(Routes.ACTIVITY);
        } else if (value.status.isServerError) {
          dialogError('Terjadi Kesalahan',
              'Terjadi masalah pada server / koneksi internet lambat');
        } else if (value.status.connectionError) {
          dialogError('Tidak ada koneksi',
              'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        }
      });
    } else {
      ActivityProvider().postImageCheckIn(body).then((value) {
        isLoadingUploadFotoCheckIn.toggle();
        print(value.body);
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          if (success == true) {
            dialogSuccess('Success', message);
          } else {
            dialogWarning('Ops...', message);
          }
          Get.offNamed(Routes.ACTIVITY);
        } else if (value.status.isServerError) {
          // dialogError('Terjadi Kesalahan',
          //     'Terjadi masalah pada server / koneksi internet lambat');
        } else if (value.status.connectionError) {
          // dialogError('Tidak ada koneksi',
          //     'Jaringan internet bermasalah, silahkan cek koneksi internet!');
        }
      });
      ActivityProvider().postPresensiActivity(bodyCheckIn).then((value) {
        loadingAbsenMasuk.toggle();

        if (kDebugMode) {
          print(value.body);
        }
        if (value.status.isOk) {
          var message = value.body['message'];

          var success = value.body['success'];
          if (success == true) {
            Get.back();
            dialogSuccess('Success', message);
            getListActivity();
          } else {
            dialogWarning('Ops...', message);
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

  void postKunjunganAutoCheckOutActivity(activityId, lokasi) {
    var body = {
      'kunjungan_id': activityId,
      'lokasi': lokasi,
    };

    ActivityProvider().postKunjunganAutoCheckOutActivity(body).then((value) {
      if (kDebugMode) {
        print(value.body);
      }
      var message = value.body['message'];
      if (value.status.isOk) {
        // print(object)
        var success = value.body['success'];
        if (success == true) {
          // dialogSuccess('Success', message);
          // Get.back();
          // dialogSuccess('Success', message);
          postImageCheckIn(activityId, 'TIDAK');
          getListActivity();
          Get.back();
        } else {
          dialogWarning('Ops...', message);
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

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

// void button() {
//   listActivity.value = [
//     {
//       'nama': 'Hotel Grand Edge',
//       'alamat': 'Jl. Semarang Indah No 13',
//       'tgl': '13-10-2023',
//       'status': 'Open',
//       'desc': 'Melakukan Negosiasi'
//     },
//     {
//       'nama': 'Hotel Pandanaran',
//       'alamat': 'Jl. Semarang Indah No 13',
//       'tgl': '13-10-2023',
//       'status': 'In Progress',
//       'desc': 'Melakukan Negosiasi'
//     },
//     {
//       'nama': 'Hotel Loise Kiene',
//       'alamat': 'Jl. Semarang Indah No 13',
//       'tgl': '13-10-2023',
//       'status': 'Completed',
//       'desc': 'Melakukan Negosiasi'
//     },
//   ];
//   for (var job in listActivity) {
//     if (job['status'] == 'Completed') {
//       listActivityCompleted.add(job);
//     } else {
//       listActivityOpenProgress.add(job);
//     }
//   }
//
//   Get.back();
//
//   // if (formKey.currentState!.validate()) {}
// }

  // ===================================================================================
  // VERSI 53: pendamping & ubah lokasi bertemu
  // ===================================================================================

  void getListPendamping() {
    ActivityProvider().getListPendamping().then((value) {
      if (value.status.isOk &&
          value.body is Map &&
          value.body['success'] == true) {
        final data = (value.body['data'] as List)
            .map((e) => Pendamping.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        listPendamping.value = [Pendamping.tanpa, ...data];
      }
    }).catchError((e) {
      if (kDebugMode) print('list pendamping: $e');
    });
  }

  String _alamatDariPlacemark(Placemark place) {
    final bagian = [
      place.name,
      place.street,
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
    ]
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!.trim())
        .toList();
    final unik = <String>[];
    for (final b in bagian) {
      if (!unik.contains(b)) unik.add(b);
    }
    return unik.join(', ');
  }

  /// Client minta pindah tempat bertemu: pilih titik di peta + alasan. Lokasi baru langsung dipakai untuk
  /// check-in / check-out (tanpa menunggu persetujuan); status lokasi menjadi PERUBAHAN LOKASI dan disetujui
  /// sales manager di web, boleh setelah kunjungan. Mengembalikan data lokasi baru dari server, atau null.
  Future<Map<String, dynamic>?> ubahLokasiBertemu(dynamic kunjunganId,
      {LatLng? lokasiAwal}) async {
    final titik = await Get.dialog(
      MapPickerPopup(lokasiAwal: lokasiAwal),
      barrierDismissible: false,
    );
    if (titik == null) return null;
    final double lat = (titik['lat'] as num).toDouble();
    final double lng = (titik['lng'] as num).toDouble();
    String alamat = '${titik['alamat'] ?? ''}'.trim();
    if (alamat.isEmpty) {
      try {
        final pm = await placemarkFromCoordinates(lat, lng);
        if (pm.isNotEmpty) alamat = _alamatDariPlacemark(pm.first);
      } catch (_) {}
    }

    final alamatC = TextEditingController(text: alamat);
    final alasanC = TextEditingController();
    final kunci = GlobalKey<FormState>();
    final simpan = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Ubah lokasi bertemu',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Form(
          key: kunci,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lokasi baru langsung dipakai untuk check-in / check-out. '
                  'Status menjadi PERUBAHAN LOKASI dan disetujui sales manager di web (boleh setelah kunjungan).',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: alamatC,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      labelText: 'Nama tempat / alamat',
                      border: OutlineInputBorder()),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: alasanC,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Alasan',
                      hintText: 'mis. client minta bertemu di rumah makan A',
                      border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? 'Alasan wajib diisi'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor, foregroundColor: Colors.white),
            onPressed: () {
              if (kunci.currentState!.validate()) Get.back(result: true);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (simpan != true) return null;

    isLoadingUbahLokasi.value = true;
    try {
      final r = await ActivityProvider().postUbahLokasi({
        'userid': '$userId',
        'kunjungan_id': '$kunjunganId',
        'lokasi': alamatC.text.trim(),
        'latitude': lat.toString(),
        'longitude': lng.toString(),
        'alasan': alasanC.text.trim(),
      });
      if (r.status.isOk && r.body is Map && r.body['success'] == true) {
        getListActivity();
        dialogSuccess('Lokasi diubah', '${r.body['message']}');
        return Map<String, dynamic>.from(r.body['data']);
      }
      if (r.status.connectionError) {
        dialogError('Tidak ada koneksi',
            'Jaringan internet bermasalah, silahkan cek koneksi internet!');
      } else {
        dialogWarning(
            'Ops...',
            r.body is Map
                ? '${r.body['message']}'
                : 'Gagal mengubah lokasi (${r.statusCode})');
      }
    } catch (e) {
      dialogError('Error', e.toString());
    } finally {
      isLoadingUbahLokasi.value = false;
    }
    return null;
  }

  Future<void> pickAddressFromMap() async {
    // ✅ GUNAKAN GET.DIALOG UNTUK POPUP
    final result = await Get.dialog(
      const MapPickerPopup(), // Widget Popup yang akan kita buat di bawah
      barrierDismissible: false, // User harus klik tombol untuk menutup
    );

    if (result != null) {
      selectedLatitude.value = result['lat'];
      selectedLongitude.value = result['lng'];

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          result['lat'],
          result['lng'],
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];

          String fullAddress =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.postalCode}";
          fullAddress = fullAddress
              .replaceAll(", ,", ",")
              .replaceAll(RegExp(r'^,\s*'), '');

          textEditingControllerAlamat.text = fullAddress;
        }
      } catch (e) {
        Get.snackbar("Error", "Gagal mendapatkan nama alamat: $e");
      }
    }
  }
}

class MapPickerPopup extends StatefulWidget {
  /// VERSI 53: titik awal peta (mis. lokasi bertemu sekarang)
  final LatLng? lokasiAwal;

  const MapPickerPopup({Key? key, this.lokasiAwal}) : super(key: key);

  @override
  State<MapPickerPopup> createState() => _MapPickerPopupState();
}

class _MapPickerPopupState extends State<MapPickerPopup> {
  late GoogleMapController mapController;
  LatLng _selectedLocation = const LatLng(-6.200000, 106.816666);
  final TextEditingController _searchController = TextEditingController();

  // State untuk Autocomplete
  List<PlaceSuggestion> _suggestions = [];
  bool _isLoadingSuggestions = false;

  // Ganti dengan API KEY Google Maps Anda (yang ada Places API)
  final String _apiKey = 'AIzaSyD2xvFq92XW4_jYTpPJ8DdCjeac-AUE4Qc';

  @override
  void initState() {
    super.initState();
    if (widget.lokasiAwal != null) {
      _selectedLocation = widget.lokasiAwal!;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// VERSI 53: pakai posisi HP sekarang sebagai lokasi bertemu
  Future<void> _pakaiLokasiSaya() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final p = LatLng(pos.latitude, pos.longitude);
      mapController.animateCamera(CameraUpdate.newLatLngZoom(p, 17.0));
      setState(() {
        _selectedLocation = p;
        _searchController.clear();
      });
    } catch (e) {
      Get.snackbar('Lokasi', 'Lokasi HP tidak bisa dibaca: $e');
    }
  }

  // --- FUNGSI MENCARI REKOMENDASI ALAMAT ---
  Future<void> _getPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    setState(() => _isLoadingSuggestions = true);

    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey&language=id');

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        setState(() {
          _suggestions = (data['predictions'] as List).map((e) {
            return PlaceSuggestion(
              description: e['description'],
              placeId: e['place_id'],
            );
          }).toList();
        });
      } else {
        setState(() => _suggestions = []);
      }
    } catch (e) {
      print("Error fetch suggestions: $e");
    } finally {
      setState(() => _isLoadingSuggestions = false);
    }
  }

  // --- FUNGSI MEMILIH REKOMENDASI & PINDAH KAMERA ---
  Future<void> _onSuggestionSelected(PlaceSuggestion suggestion) async {
    // Sembunyikan keyboard & hapus list rekomendasi
    FocusScope.of(context).unfocus();
    setState(() {
      _searchController.text = suggestion.description;
      _suggestions = [];
    });

    try {
      // Dapatkan koordinat dari Place ID menggunakan Geocoding (atau Place Details API)
      // Karena place_id tidak bisa langsung ke koordinat via package geocoding, kita pakai getLocationFromAddress sementara.
      // *Sebaiknya gunakan Place Details API untuk hasil paling akurat.
      List<Location> locations =
          await locationFromAddress(suggestion.description);

      if (locations.isNotEmpty) {
        final loc = locations.first;
        LatLng newLocation = LatLng(loc.latitude, loc.longitude);

        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(newLocation, 16.0),
        );

        setState(() {
          _selectedLocation = newLocation;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan titik koordinat alamat.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        height: 600, // Tinggi ditambah untuk search bar
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // --- HEADER POPUP ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  const Icon(Icons.map_rounded, color: kPrimaryColor),
                  const SizedBox(width: 10),
                  const Text(
                    'Pilih Lokasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // --- SEARCH BAR & REKOMENDASI ALAMAT ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      // Panggil API setiap kali user mengetik (bisa ditambahkan debounce)
                      _getPlaceSuggestions(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Ketik alamat untuk mencari...',
                      hintStyle:
                          TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: kPrimaryColor, size: 20),
                      suffixIcon: _isLoadingSuggestions
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: kPrimaryColor),
                              ),
                            )
                          : _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 20, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _suggestions = []);
                                  },
                                )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),

                  // --- DAFTAR REKOMENDASI (MUNCUL SAAT MENGETIK) ---
                  if (_suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.location_on_rounded,
                                size: 18, color: Colors.grey),
                            title: Text(
                              suggestion.description,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF1E293B)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _onSuggestionSelected(suggestion),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- PETA ---
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 15.0,
                  ),
                  onTap: (LatLng position) {
                    setState(() {
                      _selectedLocation = position;
                    });
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: _selectedLocation,
                    ),
                  },
                ),
              ),
            ),

            // VERSI 53: pakai lokasi HP sekarang
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pakaiLokasiSaya,
                  icon: const Icon(Icons.my_location_rounded, size: 18),
                  label: const Text('Pakai lokasi saya sekarang'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                    side: BorderSide(color: kPrimaryColor.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),

            // --- TOMBOL PILIH ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                onTap: () {
                  Get.back(result: {
                    'lat': _selectedLocation.latitude,
                    'lng': _selectedLocation.longitude,
                    // VERSI 53: nama tempat dari pencarian (bila ada)
                    'alamat': _searchController.text,
                  });
                },
                text: 'PILIH LOKASI INI',
                border: 15,
                height: 55,
                gradient: LinearGradient(
                  colors: [kPrimaryColor, const Color(0xFF1E3C72)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MODEL UNTUK MENAMPUNG REKOMENDASI ---
class PlaceSuggestion {
  final String description;
  final String placeId;

  PlaceSuggestion({required this.description, required this.placeId});
}
