import 'package:attamana_salles_app/app/modules/dashboard/providers/dashboard_provider.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';

class DashboardController extends GetxController {
  //TODO: Implement DashboardController
  var role = storage.read(kRoleName);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
