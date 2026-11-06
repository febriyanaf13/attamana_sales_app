import 'dart:ui';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custom_button.dart';
import '../../../style/colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient
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

          // 2. Pattern Overlay
          Opacity(
            opacity: 0.1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('bg'.png),
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
          ),

          // 3. Decorative Circles
          Positioned(
            top: -50,
            left: -50,
            child: _buildCircle(200, Colors.white.withOpacity(0.05)),
          ),

          // 4. Main Content
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              // Memastikan lebar penuh agar Center bekerja
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // Centering Vertikal
                crossAxisAlignment: CrossAxisAlignment.center,
                // Centering Horizontal
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Logo Container
                        Hero(
                          tag: 'logo',
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                )
                              ],
                            ),
                            child: Image.asset(
                              'logo_attamana'.png,
                              height: 120,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'ATTAMANA',
                          textAlign: TextAlign.center, // Centering Teks
                          style: Get.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'SALES MANAGEMENT SYSTEM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 5. Bottom Section (Version & Action)
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.session == null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: CustomButton(
                              onTap: controller.onTapLogin,
                              text: "GET STARTED",
                              border: 15,
                              height: 55,
                              gradient: LinearGradient(
                                colors: [
                                  kPrimaryColor,
                                  const Color(0xFF1E3C72)
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Obx(
                          () => Text(
                            'Version ${controller.version}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
