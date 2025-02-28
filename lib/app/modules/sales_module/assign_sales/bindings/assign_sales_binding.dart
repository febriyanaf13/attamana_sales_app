import 'package:get/get.dart';

import '../controllers/assign_sales_controller.dart';

class AssignSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignSalesController>(
      () => AssignSalesController(),
    );
  }
}
