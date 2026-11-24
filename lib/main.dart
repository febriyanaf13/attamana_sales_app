import 'package:attamana_salles_app/app/services/internet_connection_checker.dart';
import 'package:attamana_salles_app/app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/app_pages.dart';
import 'app/themes/app_theme.dart';
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  await GetStorage.init();
  ui.PlatformDispatcher.instance.onPlatformMessage = null; // Disable Impeller
  Get.put(InternetConnectionChecker());
  initializeDateFormatting('id_ID', null).then((_) => runApp(
        GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Attamana Salles App",
          theme: AppTheme.basic,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        ),
      ));
}
