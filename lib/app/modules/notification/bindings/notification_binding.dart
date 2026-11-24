import 'package:get/get.dart';

import '../controllers/notification_controller.dart';

/// VERSI 51: halaman notifikasi (rute /notification sudah ada di app_pages, modulnya dulu belum ada)
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
