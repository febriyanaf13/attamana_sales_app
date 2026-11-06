import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../style/colors.dart';
import '../components/custom_button.dart'; // Import CustomButton agar konsisten

class BiometricHelper {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> isBiometricSupported() async => auth.isDeviceSupported();

  Future<bool> canCheckBiometrics() async => await auth.canCheckBiometrics;

  void openBiometricSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.security);
  }

  /// Dialog dengan desain "Premium Floating Card"
  void showBiometricSetupDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bagian Atas: Ikon dengan Background Lembut
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Lingkaran Dekoratif
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Ikon Fingerprint Utama
                    Icon(
                      Icons.fingerprint_rounded,
                      size: 60,
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Text(
                      "Keamanan Biometrik",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B), // Slate 900
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Aktifkan fitur biometrik untuk akses yang lebih cepat, praktis, dan aman ke akun Attamana Anda.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tombol Aksi Utama menggunakan CustomButton yang sudah ada
                    CustomButton(
                      onTap: () {
                        Get.back();
                        openBiometricSettings();
                      },
                      text: "PENGATURAN SEKARANG",
                      border: 15,
                      height: 55,
                      gradient: LinearGradient(
                        colors: [kPrimaryColor, const Color(0xFF1E3C72)],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tombol Batal
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: Text(
                        "Mungkin Nanti",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.6),
      transitionCurve: Curves.easeInOut,
    );
  }

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Gunakan biometrik untuk memverifikasi identitas Anda',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
