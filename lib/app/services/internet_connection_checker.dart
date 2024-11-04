import 'dart:async';
import 'package:attamana_salles_app/app/data/api/my_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionChecker extends GetxController {
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;

  var isConnectedToInternet = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    checkConnectionChanged();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _subscription.cancel();
    _listener.dispose();
    super.onClose();
  }

  final connection = InternetConnection.createInstance(
    customCheckOptions: [
      InternetCheckOption(uri: Uri.parse(Api.baseUrl)),
    ],
  );

  void checkConnectionChanged() {
    _subscription = connection.onStatusChange.listen((status) {
      // Handle internet status changes
      switch (status) {
        case InternetStatus.connected:
          isConnectedToInternet.value = true;
          break;
        case InternetStatus.disconnected:
          isConnectedToInternet.value = false;
          break;
        default:
          isConnectedToInternet.value = false;
          break;
      }
    });
    _listener = AppLifecycleListener(
      onResume: _subscription.resume,
      onHide: _subscription.pause,
      onPause: _subscription.pause,
    );
  }
}
