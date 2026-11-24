import 'package:get/get.dart';

import '../controllers/sample_and_pricing_controller.dart';

class SampleAndPricingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SampleAndPricingController>(() => SampleAndPricingController());
  }
}
