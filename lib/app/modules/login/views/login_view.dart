// ignore_for_file: must_be_immutable

library login;

import 'dart:async';
import 'dart:ui'; // Diperlukan untuk ImageFilter (Glassmorphism)

// --- IMPORT UNTUK CONTROLLER (WAJIB ADA DI VIEW KARENA PART OF) ---
import 'package:package_info_plus/package_info_plus.dart';
import 'package:awesome_dialog/awesome_dialog.dart' as awd;
import 'package:get_storage/get_storage.dart';
import 'package:flutter/gestures.dart'; // Untuk DragStartBehavior

// --- IMPORT INTERNAL APP ---
import 'package:attamana_salles_app/app/services/internet_connection_checker.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_dialog.dart'; // Untuk dialogWarning & dialogError
import '../../../data/models/user.dart'; // Untuk userFromJson
import '../../../routes/app_pages.dart'; // Untuk Routes
import '../../../style/colors.dart';
import '../../../utils/constants.dart';
import '../providers/login_provider.dart'; // Untuk LoginProvider

// bindings
part '../bindings/login_binding.dart';

//controllers
part '../controllers/login_controller.dart';

// Inisialisasi storage global agar bisa dibaca controller
final storage = GetStorage();

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var internetConnectionChecker = Get.put(InternetConnectionChecker());

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient & Pattern
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryColor,
                  kPrimaryColor.withOpacity(0.8),
                  Colors.blue.shade900,
                ],
              ),
            ),
          ),

          // 2. Decorative Background Shapes (Optional for modern feel)
          Positioned(
            top: -100,
            right: -50,
            child: _buildCircle(250, Colors.white.withOpacity(0.05)),
          ),

          // 3. Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.08),

                  // Logo Section with Soft Animation/Shadow
                  Hero(
                    tag: 'logo',
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Image.asset(
                        'logo_attamana'.png,
                        height: 80,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'ATTAMANA',
                    style: Get.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),

                  Obx(() => Text(
                        'v${controller.version}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      )),

                  SizedBox(height: Get.height * 0.06),

                  // 4. Glassmorphism Login Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Welcome Back",
                                style: Get.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Please sign in to continue",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 30),

                              // Username Field
                              _buildTextField(
                                controller: controller.nameController,
                                hint: "Username",
                                icon: Icons.person_outline_rounded,
                              ),

                              const SizedBox(height: 20),

                              // Password Field
                              Obx(() => _buildTextField(
                                    controller: controller.passwordController,
                                    hint: "Password",
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                    obscureText: controller.isObscure.value,
                                    onSuffixTap: () =>
                                        controller.isObscureActive(),
                                  )),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: kPrimaryColor.withOpacity(0.7),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Login Button
                              Obx(() => controller.isLoadingLogin.isTrue
                                  ? Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(kPrimaryColor),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              "Authenticating...",
                                              style: TextStyle(
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [
                                            kPrimaryColor,
                                            const Color(0xFF1E3C72),
                                            // Navy Blue modern
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                kPrimaryColor.withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: CustomButton(
                                        onTap: controller.onTapLogin,
                                        text: "LOGIN",
                                        border: 15,
                                        height: 55,
                                        color: Colors
                                            .transparent, // Gunakan dekorasi container di atas
                                      ),
                                    )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Internet Indicator - Made more subtle
          Obx(() => Positioned(
                top: 50,
                right: 20,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          internetConnectionChecker.isConnectedToInternet.isTrue
                              ? Colors.greenAccent
                              : Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: (internetConnectionChecker
                                      .isConnectedToInternet.isTrue
                                  ? Colors.greenAccent
                                  : Colors.redAccent)
                              .withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]),
                ),
              )),
        ],
      ),
    );
  }

  // Helper Widget for Modern TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style:
          const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon: Icon(icon, color: kPrimaryColor),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: onSuffixTap,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
              BorderSide(color: kPrimaryColor.withOpacity(0.5), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
