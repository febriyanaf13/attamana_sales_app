import 'package:get/get.dart';

// import '../../../utils/constants.dart';
import '../../../components/custom_dialog.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../login/providers/login_provider.dart';

class SplashController extends GetxController {
  var user = storage.read('userData');
  var session = storage.read('session');

  @override
  void onInit() {
    reqToken();
    Future.delayed(const Duration(seconds: 3), () => autoLogin());
    super.onInit();
  }

  void reqToken() {
    LoginProvider().reqToken('febri', 'febrimobile150708').then((value) {
      print('status_code token : ${value.statusCode}');
     
      var success = value.body['success'];
      var message = value.body['message'];

      if (value.status.isOk) {
        if (success) {
          storage.write('token', value.body['token']);
        } else {
          dialogWarning('Gagal', message);
        }
      } else if (value.status.isServerError) {
        dialogError('Terjadi Kesalahan',
            'Terjadi masalah pada server / koneksi internet lambat');
      } else if (value.status.connectionError) {
        dialogError('Tidak ada koneksi',
            'Jaringan internet bermasalah, silahkan cek koneksi internet!');
      }
    });
  }

  void autoLogin() {
    if (session != null && session) {
      if (user != null) {
        Get.offNamed(Routes.DASHBOARD);
      } else {
        Get.offNamed(Routes.LOGIN);
      }
    }
  }

  void onTapLogin() {
    Get.offNamed(Routes.LOGIN);
  }
}
