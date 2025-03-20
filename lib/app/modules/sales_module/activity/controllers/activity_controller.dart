import 'dart:io';

import 'package:attamana_salles_app/app/components/custom_dialog.dart';
import 'package:attamana_salles_app/app/modules/customer/models/customer.dart';
import 'package:attamana_salles_app/app/modules/maps/controllers/maps_controller.dart';
import 'package:attamana_salles_app/app/modules/sales_module/activity/models/jenis_kunjungan.dart';

import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_field.dart';
import '../../../../style/colors.dart';
import '../../../../utils/constants.dart';
import '../../../maps/models/lokasi_absen.dart';
import '../models/activity.dart';
import '../models/existing_customer.dart';
import '../models/lead.dart';
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
    super.onInit();
  }

  void getListActivity() {
    listActivityOpenProgress.clear();
    listActivityCompleted.clear();
    DateTime now = DateTime.now(); // Tanggal saat ini
    DateTime lastWeek =
        now.subtract(const Duration(days: 7)); // Kurangi 1 minggu
    String formattedDate = DateFormat('yyyy-MM-dd').format(lastWeek);
    print(formattedDate); // Output: 2025-02-28 (jika hari ini 2025-03-07)
    var body = {'userid': userId, 'filter_tanggal': formattedDate.toString()};
    ActivityProvider().postReqListVisit(body).then((value) {
      if (kDebugMode) {
        print(value.body);
      }
      if (value.status.isOk) {
        var data = value.body['data'];
        listActivity.value = activityFromJson(data);
        for (var list in listActivity) {
          print('masuk sini');
          if (list.status == null ||
              list.status == "" ||
              list.status == 'CHECK IN') {
            listActivityOpenProgress.add(list);
          } else {
            listActivityCompleted.add(list);
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
        if (route == 'MAPS' || route == 'COMPLETED') {
          Get.toNamed(Routes.MAPS_VIEW, arguments: {
            'idKunjungan': data['id'],
            'action': data['action'],
            'lokasiRadius': data['lokasi_radius'],
            'route': route,
            'lokasiCheckIn': data['lokasi_checkin'],
            'lokasiCheckOut': data['lokasi_checkout'],
            'waktuCheckin': data['waktu_checkin'],
            'waktuCheckout': data['waktu_checkout'],
            'notulen': data['notulen'],
          });
        } else if (route == 'EDIT') {
          // detailActivity = detailActivityFromJson(data);
          Get.toNamed(Routes.ADD_ACTIVITY, arguments: data['id']);
        }
        print(value.bodyString!);
      }
    });
  }

  void getCustomerExisting() {
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
      };
      if (kDebugMode) {
        print(body);
      }

      ActivityProvider().postSimpanActivity(body).then((value) {
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
                30.height,
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
      toast('Gagal mengambil gambar : $e');
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
}
