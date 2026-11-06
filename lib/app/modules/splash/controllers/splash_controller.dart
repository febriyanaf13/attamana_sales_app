import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:package_info_plus/package_info_plus.dart';

// import '../../../utils/constants.dart';
import '../../../components/custom_dialog.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper.dart';
import '../../../utils/string.dart';
import '../../login/providers/login_provider.dart';

class SplashController extends GetxController {
  var user = storage.read('userData');
  var session = storage.read('session');
  var version = ''.obs;
  final bio = BiometricHelper();
  RxBool isBiomatric = false.obs;


  @override
  void onInit() {
    getVersionApp();


    super.onInit();
  }

  Future<void> reqToken() async {
    LoginProvider()
        .reqToken('attamanacrm', 'febrimobile150708', version.value)
        .then((value) {
      if (kDebugMode) {
        print('status_code token : ${value.statusCode}');
      }

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

  void autoLogin() async {
    bool tokenValid = await getValidToken();
    if (session != null && session) {
      if (user != null) {
        switch (true) {
          case true when tokenValid && isBiomatric.isTrue:
            bool success = await bio.authenticate();
            if (success) {
              Get.offAllNamed(Routes.DASHBOARD);
            } else {
              Get.offAllNamed(Routes.LOGIN);
            }
            break;

          case true when tokenValid && !isBiomatric.isTrue:
            Get.offAllNamed(Routes.DASHBOARD);
            break;

          default:
            Get.offAllNamed(Routes.LOGIN);
            break;
        }
      } else {
        Get.offNamed(Routes.LOGIN);
      }
    }
  }

  Future<bool> getValidToken() async {
    String? token = storage.read(kToken);

    // Token kosong → invalid
    if (token == null) {
      if (kDebugMode) print('Token tidak valid, login ulang...');
      return false;
    }

    // Cek apakah token expired
    bool isExpired = JwtDecoder.isExpired(token);
    if (isExpired) {
      if (kDebugMode) print('Token expired, refresh token...');
      await reqToken();
      token = storage.read(kToken);

      // Jika setelah refresh token masih null → invalid
      return token != null;
    }
    return true;
  }

  void onTapLogin() {
    Get.offNamed(Routes.LOGIN);
  }

  void getVersionApp() async {
    isBiomatric.value = storage.read(kBiomatricAuth) ?? false;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version.value = packageInfo.version;
    reqToken();
    Future.delayed(const Duration(seconds: 3), () => autoLogin());
  }
}
