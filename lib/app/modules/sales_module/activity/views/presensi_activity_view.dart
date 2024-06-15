import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_dialog.dart';
import '../../../../components/custom_lottie.dart';
import '../../../../style/colors.dart';
import '../../../../style/paddings.dart';
import '../controllers/activity_controller.dart';

class PresensiActivityView extends StatefulWidget {
  const PresensiActivityView({super.key});

  @override
  State<PresensiActivityView> createState() => _PresensiActivityState();
}

class _PresensiActivityState extends State<PresensiActivityView> {
  @override
  var controller = Get.put(ActivityController());
  GoogleMapController? mapController;
  final Map<String, Marker> markers = {};
  final Map<String, Polygon> polygons = {};

  var loadingLocation = false;
  var locationServiceEnabled = true;
  var locationPermissionAllowed = true;
  var reloadMaps = false;

  LatLng? centerPosition;
  String? namaGedung;
  late LocationPermission permission;

  Widget _buildLoadingCurrentLocation(BuildContext context) => Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customLottie('loading_location'),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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

  Widget _buildLocationDisable(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Mohon aktfikan lokasi Anda dan izinkan aplikasi untuk mengakses lokasi Anda. Aplikasi harus memastikan apakah Anda berada dalam lokasi yang sudah ditentukan atau tidak. Presensi kehadiran hanya bisa dilakukan di dalam lokasi area hijau.',
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _buildGoogleMaps(BuildContext context) => GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: centerPosition!,
          zoom: 16,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: false,
        markers: markers.values.toSet(),
        polygons: polygons.values.toSet(),
      );

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    googleMapsInitilization();
  }

  googleMapsInitilization() {
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
        // for (var gedung in listGedungDanKoordinat!) {
        // print('pol ${controller.listKoorPolygonGedung}');
        // polygons[namaGedung!] = Polygon(
        //   polygonId: PolygonId(namaGedung!),
        //   points: controller.listKoorPolygonGedung,
        //   fillColor: kPrimaryColor.withOpacity(0.3),
        //   strokeColor: kPrimaryColor,
        //   strokeWidth: 1,
        // );
        // }
      });
    }

    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: centerPosition!,
        zoom: 20,
      )),
    );
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
    }
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
      desiredAccuracy: LocationAccuracy.low,
    );

    if (position.isMocked) {
      controller.showDilarangMenggunakanMockLocaton();
    } else {
      setState(() {
        centerPosition = LatLng(position.latitude, position.longitude);
        loadingLocation = false;
      });
    }
  }

  getPrefs() async {
    if (mounted) {
      setState(() {
        // listStringLatLngGedung = storage.read(kGeometryAbsen);
      });
    }
    // print('sini ${storage.read(kGeometryAbsen)}');

    // prosesStringLatLang();
    // presensiHariIniController.loadDataHariIni(nomorInduk!);
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    getPrefs();

    checkLocationService();
    // controller.getKoorPolygonArea();

    namaGedung = 'Semarang';

    super.initState();
  }

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
                : _buildGoogleMaps(context),
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
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {},
                      child: Container(
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kPrimaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Text(
                              'F',
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
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: kPrimaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Center(
                          child: Text(
                            'Datang',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: kSuccessColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .005,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Center(
                            child:
                                //   Obx(
                                // () =>
                                Text(
                                    // controller.jamMasuk.value == ''
                                    //     ?
                                    '--:--'
                                    // : controller.jamMasuk.value
                                    ,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                          )),
                      // ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .02,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Center(
                          child: Text(
                            'Pulang',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .005,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Center(
                            child:
                                //   Obx(
                                // () =>
                                Text(
                                    // controller.jamPulang.value == '' ?
                                    '--:--'
                                    // : controller.jamPulang.value
                                    ,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                          )),
                      // ),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
        Obx(
          () => Positioned(
            bottom: 50,
            right: Get.width / 10,
            left: Get.width / 10,
            child: Row(
              children: [
                Expanded(
                  child:
                      // Obx(
                      //   () =>
                      controller.loadingAbsenPulang.isTrue
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            )
                          : CustomButton(
                              onTap: () {
                                if (locationServiceEnabled &&
                                    locationPermissionAllowed) {
                                  // onTapPresensiButton('Pulang');
                                } else {
                                  dialogWarning('Peringatan',
                                      'Layanan lokasi device anda tidak aktif atau aplikasi tidak diizinkan mengakses lokasi Anda.');
                                  // controller.loadingAbsen.toggle();
                                }
                              },
                              text: "Pulang",
                              border: 30,
                            ),
                ),
                // ),
                const SizedBox(
                  width: kElementPadding,
                ),
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      if (locationServiceEnabled && locationPermissionAllowed) {
                        // onTapPresensiButton('Masuk');
                      } else {
                        dialogWarning('Peringatan',
                            'Layanan lokasi device anda tidak aktif atau aplikasi tidak diizinkan mengakses lokasi Anda.');
                        // controller.loadingAbsen.toggle();
                      }
                    },
                    text:
                        // controller.loadingAbsenMasuk.isTrue
                        //     ? "Loading..."
                        //     :
                        "Masuk",
                    border: 30,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
