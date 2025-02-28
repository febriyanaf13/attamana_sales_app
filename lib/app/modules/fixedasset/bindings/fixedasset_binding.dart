import 'package:get/get.dart';

import '../controllers/fixedasset_controller.dart';

class FixedassetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FixedassetController>(
      () => FixedassetController(),
    );
  }
}
