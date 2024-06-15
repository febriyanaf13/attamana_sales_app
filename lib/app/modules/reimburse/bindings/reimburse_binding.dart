import 'package:get/get.dart';

import '../controllers/reimburse_controller.dart';

class ReimburseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReimburseController>(
      () => ReimburseController(),
    );
  }
}
