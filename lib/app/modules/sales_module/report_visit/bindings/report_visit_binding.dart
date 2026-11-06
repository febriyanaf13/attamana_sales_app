import 'package:get/get.dart';

import '../../activity/controllers/activity_controller.dart';
import '../controllers/report_visit_controller.dart';

class ReportVisitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityController>(() => ActivityController());
    Get.lazyPut<ReportVisitController>(
      () => ReportVisitController(),
    );
  }
}
