import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/custom_button.dart';
import '../../../style/colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            ),
            image: DecorationImage(
                image: AssetImage('bg'.png), repeat: ImageRepeat.repeat)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kPrimaryColor.withOpacity(0.9),
                kPrimaryColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie.asset(
                        //   'logo_splash'.json,
                        //   width: Get.width * 0.5,
                        // ),
                        Card(
                            elevation: 2,
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(150),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                'logo_attamana'.png,
                                scale: 5,
                              ),
                            )),
                        20.height,
                        RichText(
                            text: TextSpan(
                                text: 'ATTAMANA',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2),
                                children: [
                              TextSpan(
                                text: '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ])),
                      ],
                    ),
                  ),
                  Obx(
                    () => Text(
                      'Version ${controller.version}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: kSecondaryTextColor),
                    ),
                  ),
                  controller.session == null
                      ? Expanded(
                          flex: 1,
                          child: Center(
                            child: CustomButton(
                                onTap: controller.onTapLogin,
                                width: 200,
                                height: 50,
                                border: 30,
                                color: Colors.red,
                                text: 'Login'),
                          ))
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
