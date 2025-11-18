// ignore_for_file: prefer_const_constructors

import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_dialog.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_lottie.dart';
import '../../../style/colors.dart';
import '../../../style/paddings.dart';
import '../../sales_module/activity/controllers/activity_controller.dart';
import '../controllers/cek_lokasi.dart';
import '../controllers/maps_controller.dart';
import '../models/gedung.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> with WidgetsBindingObserver {
  var controller = Get.put(MapsController());
  var controllerJobVisit = Get.put(ActivityController());
  var loadingLocation = false;
  var locationServiceEnabled = true;
  bool reloadMaps = false;
  var locationPermissionAllowed = true;
  List<dynamic>? listStringLatLngGedung;
  List<String>? listNamaGedung;
  List<LatLng>? listLatLngGedungSegment;
  List<Gedung>? listGedungDanKoordinat;

  GoogleMapController? mapController;
  final Map<String, Marker> markers = {};
  final Map<String, Polygon> polygons = {};
  final Map<String, Circle> circle = {};

  late BitmapDescriptor pinLocationIconCheckIn;
  late BitmapDescriptor pinLocationIconCheckOut;

  LatLng? checkInPostion;
  LatLng? checkOutPostion;

  Map<MarkerId, Marker> setmarkersCheckInOut = {};
  List listMarkerIds = []; // For store data of your markers

  activityCompleted() async {
    checkInPostion = stringlatlngsplitted(argument['lokasiCheckIn']);
    checkOutPostion = stringlatlngsplitted(argument['lokasiCheckOut']);

    MarkerId markerId1 = MarkerId("1");
    MarkerId markerId2 = MarkerId("2");

    listMarkerIds.add(markerId1);
    listMarkerIds.add(markerId2);

    Marker marker1 = Marker(
      markerId: markerId1,
      position: checkInPostion!,
      infoWindow: InfoWindow(
        title: 'Check In',
        snippet: argument['waktuCheckin'].toString(),
      ),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)), 'checkin'.png),
    );

    Marker marker2 = Marker(
      markerId: markerId2,
      position: checkOutPostion!,
      infoWindow: InfoWindow(
        title: 'Check Out',
        snippet: argument['waktuCheckout'].toString(),
      ),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'checkout'.png), // you can change the color of marker
    );

    setmarkersCheckInOut[markerId1] =
        marker1; // I Just added here markers on the basis of marker id
    setmarkersCheckInOut[markerId2] = marker2;
  }

  LatLng? centerPosition;
  LatLng? centerCircle;

  String? namaGedung;

  late LocationPermission permission;

  var argument = Get.arguments;
  var routeArgument = '';
  var role = storage.read(kRoleName);
  var userName = storage.read(kUserNama);
  var statusKaryawan = storage.read(kStatusKaryawan);

  Widget _buildGoogleMapsPolygon(BuildContext context) => GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: centerPosition!,
          zoom: 10,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        markers: markers.values.toSet(),
        polygons: polygons.values.toSet(),
      );

  Widget _buildGoogleMapsCircle(BuildContext context) => GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: centerPosition!,
          zoom: 10,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        markers: markers.values.toSet(),
        // polygons: polygons.values.toSet(),
        circles: circle.values.toSet(),
      );

  Widget _buildGoogleMapsCircleActivityCompleted(BuildContext context) =>
      GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: centerPosition!,
          zoom: 10,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        markers: setmarkersCheckInOut.values.toSet(),
        // polygons: polygons.values.toSet(),
        circles: circle.values.toSet(),
      );

  Widget _buildLocationDisable(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Mohon aktfikan lokasi Anda dan izinkan aplikasi untuk mengakses lokasi Anda. Aplikasi harus memastikan apakah Anda berada dalam lokasi yang sudah ditentukan atau tidak. Presensi kehadiran hanya bisa dilakukan di dalam lokasi area hijau.',
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _buildLoadingCurrentLocation(BuildContext context) => Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customLottie('loading_location'),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Loading Lokasi Terkini',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  getPrefs() async {
    if (mounted) {
      setState(() {
        listStringLatLngGedung = storage.read(kGeometryAbsen);
      });
    }
    print(
        'ini list polygon gedung saat pertama peta dibuka ${storage.read(kGeometryAbsen)}');

    prosesStringLatLang();
    // presensiHariIniController.loadDataHariIni(nomorInduk!);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    googleMapsInitilization();
  }

  prosesStringLatLang() {
    if (mounted) {
      setState(() {
        reloadMaps = true;
      });
    }

    int idx = 0;
    List<Gedung> listGedungData = [];
    for (var koordinatGedung in listStringLatLngGedung!) {
      debugPrint('ini koordinat gedung $koordinatGedung');
      List<String> stringlatlngsplitted = koordinatGedung.split(");(");
      List<LatLng> listLatLngGedung = [];

      for (var latlng in stringlatlngsplitted) {
        String removeSquareBracket = latlng.replaceAll("(", "");
        String removeSquareBracket2 = removeSquareBracket.replaceAll(")", "");
        String removeSpace = removeSquareBracket2.replaceAll(" ", "");
        List<String> strLatLngSplitted = removeSpace.split(",");

        listLatLngGedung.add(LatLng(
          double.parse(strLatLngSplitted[0]),
          double.parse(strLatLngSplitted[1]),
        ));
      }

      listGedungData.add(Gedung(
        // namaGedung: listNamaGedung![idx],
        listLatLng: listLatLngGedung,
      ));
      debugPrint('ini list latlng gedung $listLatLngGedung');
      idx++;
    }

    if (mounted) {
      setState(() {
        listGedungDanKoordinat = listGedungData;
        reloadMaps = false;
      });
    }
  }

  googleMapsInitilization() {
    debugPrint('masuk ke google maps initilization');
    if (mounted) {
      setState(() {
        markers.clear();
        markers['Semarang'] = Marker(
          markerId: const MarkerId('Semarang'),
          position: centerPosition!,
          infoWindow: const InfoWindow(
            title: 'Lokasi Anda',
            snippet: 'Lokasi anda terkini',
          ),
        );

        polygons.clear();
        if (argument == null) {
          // for (var gedung in listGedungDanKoordinat!) {
          //   polygons[gedung.namaGedung ?? 'Gedung'] = Polygon(
          //     polygonId: PolygonId(gedung.namaGedung ?? 'Gedung'),
          //     points: gedung.listLatLng!,
          //     fillColor: kPrimaryColor.withOpacity(0.3),
          //     strokeColor: kPrimaryColor,
          //     strokeWidth: 1,
          //   );
          //   debugPrint('ini list polygon gedung maps initilization ${gedung}');
          // }
          for (int i = 0; i < listGedungDanKoordinat!.length; i++) {
            polygons["Gedung_${i + 1}"] = Polygon(
              polygonId: PolygonId("Gedung_${i + 1}"),
              points: listGedungDanKoordinat![i].listLatLng!,
              fillColor: kPrimaryColor.withOpacity(0.3),
              strokeColor: kPrimaryColor,
              strokeWidth: 1,
            );
            debugPrint(
                'ini list polygon gedung maps initilization ${listGedungDanKoordinat![i].listLatLng!}');
          }

          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
              target: centerPosition!,
              zoom: 13,
            )),
          );
        } else {
          var lokasiRadius = argument['lokasiRadius'];

          // print('ini data argument ' + argument);
          print('ini lokasi radius ' + lokasiRadius);
          centerCircle = stringlatlngsplitted(lokasiRadius);

          if (kDebugMode) {
            print('latlangGedung $centerCircle');
          }

          // controller.listKoorPolygonGedung.value = listLatLngGedung;
          // }
          circle[''] = Circle(
              circleId: CircleId('1'),
              center: centerCircle!,
              radius: 1000,
              strokeWidth: 1,
              fillColor: kPrimaryColor.withOpacity(0.5));

          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
              target: centerCircle!,
              zoom: 13,
            )),
          );
        }
      });
    }
  }

  // LatLng? stringlatlngsplitted(stringLatLng) {
  //   for (var koordinat in stringLatLng!) {
  //     List<String> stringlatlngsplitted = koordinat.split(");(");
  //     var hasilLatLng;
  //
  //     for (var latlng in stringlatlngsplitted) {
  //       String removeSquareBracket = latlng.replaceAll("(", "");
  //       String removeSquareBracket2 = removeSquareBracket.replaceAll(")", "");
  //       String removeSpace = removeSquareBracket2.replaceAll(" ", "");
  //       List<String> strLatLngSplitted = removeSpace.split(",");
  //
  //       hasilLatLng = LatLng(
  //         double.parse(strLatLngSplitted[0]),
  //         double.parse(strLatLngSplitted[1]),
  //       );
  //     }
  //     return hasilLatLng;
  //   }
  // }

  LatLng stringlatlngsplitted(String stringLatLng) {
    // Buang tanda kurung
    String cleaned = stringLatLng.replaceAll("(", "").replaceAll(")", "");

    // Split menjadi [lat, lng]
    List<String> parts = cleaned.split(",");

    return LatLng(
      double.parse(parts[0]),
      double.parse(parts[1]),
    );
  }

  checkLocationService() async {
    loadingLocation = true;

    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationServiceEnabled = false;
        loadingLocation = false;
      });
    } else {
      checkLocationPermission();
    }
  }

  checkLocationPermission() async {
    permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        await Geolocator.requestPermission().then((value) {
          if (value == LocationPermission.denied ||
              value == LocationPermission.deniedForever) {
            setState(() {
              locationPermissionAllowed = false;
              loadingLocation = false;
            });
          } else {
            getLokasiTerkini();
          }
        });
        break;
      case LocationPermission.deniedForever:
        await Geolocator.requestPermission().then((value) {
          if (value == LocationPermission.denied ||
              value == LocationPermission.deniedForever) {
            setState(() {
              locationPermissionAllowed = false;
              loadingLocation = false;
            });
          } else {
            getLokasiTerkini();
          }
        });
        break;
      default:
        getLokasiTerkini();
        break;
    }
  }

  getLokasiTerkini() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (position.isMocked) {
      controller.showDilarangMenggunakanMockLocaton();
    } else {
      setState(() {
        centerPosition = LatLng(position.latitude, position.longitude);
        loadingLocation = false;
      });
    }
    // setState(() {
    //   centerPosition = LatLng(position.latitude, position.longitude);
    //   loadingLocation = false;
    // });
    // debugPrint('masuk ke lokasi terkini : $position');
    // centerPosition = LatLng(position.latitude, position.longitude);
    // loadingLocation = false;
  }

  lokasiTerkiniOnResumed() async {
    if (locationServiceEnabled && locationPermissionAllowed) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      if (position.isMocked) {
        controller.showDilarangMenggunakanMockLocaton();
      } else {
        setState(() {
          centerPosition = LatLng(position.latitude, position.longitude);
          reloadMaps = false;
          loadingLocation = false;
        });
      }
      debugPrint('masuk ke lokasi terkini on resume');

      // setState(() {
      //   centerPosition = LatLng(position.latitude, position.longitude);
      //   reloadMaps = false;
      //   loadingLocation = false;
      // });
    }
  }

  mapsOnResumed() async {
    bool serviceEnabled;

    if (mounted) {
      setState(() {
        loadingLocation = true;
        reloadMaps = true;
      });
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          reloadMaps = false;
          locationServiceEnabled = false;
          loadingLocation = false;
        });
      }
    } else {
      LocationPermission permission;
      if (mounted) {
        setState(() {
          locationServiceEnabled = true;
        });
      }
      permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.denied:
          await Geolocator.requestPermission().then((value) {
            if (value == LocationPermission.denied ||
                value == LocationPermission.deniedForever) {
              if (mounted) {
                setState(() {
                  reloadMaps = false;
                  locationPermissionAllowed = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  locationPermissionAllowed = true;
                });
              }
              lokasiTerkiniOnResumed();
            }
          });

          break;
        case LocationPermission.deniedForever:
          await Geolocator.requestPermission().then((value) {
            if (value == LocationPermission.denied ||
                value == LocationPermission.deniedForever) {
              if (mounted) {
                setState(() {
                  reloadMaps = false;
                  locationPermissionAllowed = false;
                  loadingLocation = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  locationPermissionAllowed = true;
                });
              }
              lokasiTerkiniOnResumed();
            }
          });
          break;
        default:
          if (mounted) {
            setState(() {
              locationPermissionAllowed = true;
            });
          }
          lokasiTerkiniOnResumed();
          break;
      }
    }
  }

  onTapPresensiButton(String jenis) async {
    if (mounted) setState(() {});

    bool isInsideAnyPolygon = false;

    for (var i = 0; i < listGedungDanKoordinat!.length; i++) {
      List<double> listLat = [];
      List<double> listLng = [];

      for (var latlng in listGedungDanKoordinat![i].listLatLng!) {
        listLat.add(latlng.latitude);
        listLng.add(latlng.longitude);
      }

      debugPrint("listLat : $listLat");
      debugPrint("listLng : $listLng");
      debugPrint("titik sekarang lat : ${centerPosition!.latitude}");
      debugPrint("titik sekarang lng : ${centerPosition!.longitude}");

      CekLokasi cekLokasi = CekLokasi(
        latTitikSekarang: centerPosition!.latitude,
        lngTitikSekarang: centerPosition!.longitude,
        listLatPolygon: listLat,
        listLngPolygon: listLng,
      );

      if (cekLokasi.apakahLokasiDalamPolygon()) {
        isInsideAnyPolygon = true;
        break; // cukup satu polygon true, langsung boleh presensi
      }
    }

    // 🧭 Setelah loop semua polygon
    if (isInsideAnyPolygon) {
      debugPrint('✅ Lokasi di dalam salah satu area presensi');

      switch (jenis) {
        case 'Masuk':
          if (statusKaryawan == 'STAFF') {
            controller.postSimpanAbsensiMasuk(
                centerPosition!.latitude, centerPosition!.longitude);
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.infoReverse,
              animType: AnimType.rightSlide,
              dismissOnBackKeyPress: false,
              dismissOnTouchOutside: false,
              title: 'Pilih Shift',
              body: Column(
                children: [
                  Text('Pilih Shift', style: Get.textTheme.titleLarge),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomDropdownButton(
                      title: '',
                      withTitle: false,
                      isRequired: false,
                      height: 60,
                      items: controller.listAllShiftsUntukDipilih,
                      onChangeValue: (value) {
                        controller.shiftId.value = value.toString();
                      },
                      validator: 'Shift harus dipilih...!',
                    ),
                  ),
                ],
              ),
              btnCancelOnPress: () {
                Get.back();
                controller.loadingAbsenMasuk.toggle();
                controller.shiftId.value = '';
              },
              btnOkOnPress: () {
                controller.postSimpanAbsensiMasuk(
                    centerPosition!.latitude, centerPosition!.longitude);
              },
            ).show();
          }
          break;

        case 'Pulang':
          controller.postSimpanAbsensiPulang(
              centerPosition!.latitude, centerPosition!.longitude);
          break;
      }
    } else {
      debugPrint('❌ Tidak dalam area presensi mana pun');
      dialogWarning('Ops...', 'Maaf, anda tidak dalam wilayah presensi');
    }
  }

  void onTapCheckInOutButton(status) {
    CekLokasi cekLokasi = CekLokasi(
      latTitikSekarang: centerPosition!.latitude,
      lngTitikSekarang: centerPosition!.longitude,
      latTitikCircle: centerCircle!.latitude,
      lngTitikCircle: centerCircle!.longitude,
      listLatPolygon: [],
      listLngPolygon: [],
    );
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

    // proteksi absen
    // if (listButuhLokasi.contains(argument['action'].toString())) {
    //   if (cekLokasi.apakahLokasiDalamCircle()) {
    //     print('iya didalam');
    //     controllerJobVisit.postPresensiActivity(argument['idKunjungan'], status,
    //         '(${centerCircle!.latitude}, ${centerCircle!.longitude})');
    //   } else {
    //     dialogWarning('Ops...', 'Maaf, anda tidak dalam wilayah presensi');
    //   }
    // } else if (listTidakButuhLokasi.contains(argument['action'].toString())) {
    //   controllerJobVisit.postPresensiActivity(argument['idKunjungan'], status,
    //       '(${centerCircle!.latitude}, ${centerCircle!.longitude})');
    // }
    controllerJobVisit.postPresensiActivity(
        argument['idKunjungan'],
        status,
        '(${centerPosition!.latitude}, ${centerPosition!.longitude})',
        argument['notulen']);
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    getPrefs();

    checkLocationService();

    namaGedung = 'Semarang';
    if (argument != null) {
      routeArgument = argument['route'];
    }
    routeArgument == 'COMPLETED' ? activityCompleted() : null;

    super.initState();
  }

  @override
  void dispose() {
    mapController!.dispose();
    markers.clear();
    polygons.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        loadingLocation
            ? _buildLoadingCurrentLocation(context)
            : !locationServiceEnabled || !locationPermissionAllowed
                ? _buildLocationDisable(context)
                : argument == null
                    ? _buildGoogleMapsPolygon(context)
                    : routeArgument == 'COMPLETED'
                        ? _buildGoogleMapsCircleActivityCompleted(context)
                        : _buildGoogleMapsCircle(context),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.onTapAccount(),
                      child: Container(
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kPrimaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Text(
                              userName.substring(0, 1),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Center(
                            child: Text(
                              DateFormat('HH:mm:ss').format(DateTime.now()),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontFamily: 'TickingTimebombBB',
                                      letterSpacing: 10,
                                      fontWeight: FontWeight.bold),
                            ),
                          );
                        }),
                    Center(
                      child: GestureDetector(
                        onTap: () => mapsOnResumed(),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: kPrimaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: Get.height * 0.01,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: Container(
              //         height: 40,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.rectangle,
              //           borderRadius: BorderRadius.circular(25),
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.5),
              //               spreadRadius: 1,
              //               blurRadius: 1,
              //               offset: Offset(0, 1), // changes position of shadow
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 5),
              //           child: Center(
              //             child: Text(
              //               'Datang',
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .bodyLarge
              //                   ?.copyWith(color: kSuccessColor),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: Get.width * .005,
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Container(
              //         height: 40,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.rectangle,
              //           borderRadius: BorderRadius.circular(25),
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.5),
              //               spreadRadius: 1,
              //               blurRadius: 1,
              //               offset: Offset(0, 1), // changes position of shadow
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 5),
              //           child: Center(
              //               child: Obx(
              //             () => Text(
              //                 controller.jamMasuk.value == ''
              //                     ? '--:--'
              //                     : controller.jamMasuk.value,
              //                 style: Theme.of(context).textTheme.bodyLarge),
              //           )),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: Get.width * .02,
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Container(
              //         height: 40,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.rectangle,
              //           borderRadius: BorderRadius.circular(25),
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.5),
              //               spreadRadius: 1,
              //               blurRadius: 1,
              //               offset: Offset(0, 1), // changes position of shadow
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 5),
              //           child: Center(
              //             child: Text(
              //               'Pulang',
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .bodyLarge
              //                   ?.copyWith(color: kPrimaryColor),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: Get.width * .005,
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Container(
              //         height: 40,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.rectangle,
              //           borderRadius: BorderRadius.circular(25),
              //           color: Colors.white,
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey.withOpacity(0.5),
              //               spreadRadius: 1,
              //               blurRadius: 1,
              //               offset: Offset(0, 1), // changes position of shadow
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 5),
              //           child: Center(
              //               child: Obx(
              //             () => Text(
              //                 controller.jamPulang.value == ''
              //                     ? '--:--'
              //                     : controller.jamPulang.value,
              //                 style: Theme.of(context).textTheme.bodyLarge),
              //           )),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          )),
        ),
        routeArgument == 'COMPLETED'
            ? SizedBox()
            : Positioned(
                bottom: 50,
                right: Get.width / 10,
                left: Get.width / 10,
                child: argument == null
                    ? Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => controller.loadingAbsenPulang.isTrue
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.red,
                                      ),
                                    )
                                  : CustomButton(
                                      onTap: () {
                                        if (locationServiceEnabled &&
                                            locationPermissionAllowed) {
                                          onTapPresensiButton('Pulang');
                                        } else {
                                          dialogWarning('Peringatan',
                                              'Layanan lokasi device anda tidak aktif atau aplikasi tidak diizinkan mengakses lokasi Anda.');
                                          // controller.loadingAbsen.toggle();
                                        }
                                      },
                                      text: 'Pulang',
                                      border: 30,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: kElementPadding,
                          ),
                          Expanded(
                            child: Obx(
                              () => controller.loadingAbsenMasuk.isTrue
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                      ),
                                    )
                                  : CustomButton(
                                      onTap: () {
                                        if (locationServiceEnabled &&
                                            locationPermissionAllowed) {
                                          onTapPresensiButton('Masuk');
                                        } else {
                                          dialogWarning('Peringatan',
                                              'Layanan lokasi device anda tidak aktif atau aplikasi tidak diizinkan mengakses lokasi Anda.');
                                          // controller.loadingAbsen.toggle();
                                        }
                                      },
                                      text: 'Masuk',
                                      border: 30,
                                      color: Colors.green,
                                    ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => controllerJobVisit.loadingAbsenPulang.isTrue
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.red,
                                      ),
                                    )
                                  : CustomButton(
                                      onTap: () {
                                        if (locationServiceEnabled &&
                                            locationPermissionAllowed) {
                                          onTapCheckInOutButton('CHECK OUT');
                                        } else {
                                          dialogWarning('Peringatan',
                                              'Layanan lokasi device anda tidak aktif atau aplikasi tidak diizinkan mengakses lokasi Anda.');
                                          // controller.loadingAbsen.toggle();
                                        }
                                      },
                                      text: 'Check Out',
                                      border: 30,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: kElementPadding,
                          ),
                          Expanded(
                            child: Obx(
                              () => controllerJobVisit.loadingAbsenMasuk.isTrue
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                      ),
                                    )
                                  : CustomButton(
                                      onTap: () {
                                        if (locationServiceEnabled &&
                                            locationPermissionAllowed) {
                                          onTapCheckInOutButton('CHECK IN');
                                        } else {
                                          dialogWarning('Peringatan',
                                              'Layanan lokasi device anda tidak aktif atau aplikasi tidak diizinkan mengakses lokasi Anda.');
                                          // controller.loadingAbsen.toggle();
                                        }
                                      },
                                      text: 'Check In',
                                      border: 30,
                                      color: Colors.green,
                                    ),
                            ),
                          ),
                        ],
                      ),
              ),
      ],
    ));
  }
}
