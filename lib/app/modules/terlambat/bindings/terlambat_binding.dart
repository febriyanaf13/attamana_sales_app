import 'package:get/get.dart';

import '../controllers/terlambat_controller.dart';

class TerlambatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TerlambatController>(
      () => TerlambatController(),
    );
  }
}
