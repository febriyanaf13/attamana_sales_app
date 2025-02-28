import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';

class DashboardProvider extends GetConnect {
  var token = storage.read('token');
}
