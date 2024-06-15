// ignore_for_file: must_be_immutable

library login;

import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:awesome_dialog/awesome_dialog.dart' as awd;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_dialog.dart';
import '../../../data/models/user.dart';
import '../../../routes/app_pages.dart';
import '../../../style/colors.dart';
import '../../../utils/constants.dart';
import '../providers/login_provider.dart';

// bindings
part '../bindings/login_binding.dart';

//controllers
part '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

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
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height,
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
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
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

                        Obx(
                          () => Text(
                            'Version : ${controller.version}',
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: kSecondaryTextColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// username or Gmail
                          TextFormField(
                            style: kTextFormFieldStyle(),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Username',
                            ),
                            controller: controller.nameController,
                            // The validator receives the text that the user has entered.
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter username';
                            //   } else if (value.length < 3) {
                            //     return 'at least enter 4 characters';
                            //   } else if (value.length > 13) {
                            //     return 'maximum character is 13';
                            //   }
                            //   return null;
                            // },
                          ),

                          SizedBox(
                            height: Get.height * 0.02,
                          ),

                          // password
                          Obx(
                            () => TextFormField(
                              style: kTextFormFieldStyle(),
                              controller: controller.passwordController,
                              obscureText: controller.isObscure.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_open),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isObscure.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    controller.isObscureActive();
                                  },
                                ),
                                hintText: 'Password',
                              ),
                              // The validator receives the text that the user has entered.
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter password';
                              //   } else if (value.length < 3) {
                              //     return 'at least enter 6 characters';
                              //   } else if (value.length > 13) {
                              //     return 'maximum character is 13';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Text(
                            'Forgot Password?',
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: kSecondaryTextColor),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            height: Get.height * 0.05,
                          ),

                          /// Login Button
                          Obx(
                            () => controller.isLoadingLogin.isTrue
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CustomButton(
                                    onTap: controller.onTapLogin,
                                    text: "Login",
                                    border: 30,
                                    height: 50,
                                  ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Scaffold(
    //   backgroundColor: Colors.white,
    //   resizeToAvoidBottomInset: false,
    //   body: SafeArea(
    //       child: ScreenTypeLayout(
    //     mobile: _buildMobileScreen(controller),
    //     tablet: _buildTabletScreen(controller),
    //     desktop: Container(color: Colors.red),
    //     watch: Container(color: Colors.purple),
    //   )));
  }

  /// For Small screens
  Widget _buildMobileScreen(
    LoginController controller,
  ) {
    return Center(
      child: _buildMainBody(
        controller,
      ),
    );
  }

  Widget _buildTabletScreen(LoginController controller) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/coin.json',
              height: Get.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: Get.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(
            controller,
          ),
        ),
      ],
    );
  }

  /// Main Body
  Widget _buildMainBody(
    LoginController simpleUIController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          Get.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Get.width > 600
            ? Container()
            : Image.asset(
                'logo_login'.png,
                height: Get.height * 0.3,
                width: Get.width,
                fit: BoxFit.scaleDown,
              ),
        SizedBox(
          height: Get.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Login',
            style: Get.textTheme.displaySmall
                ?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Welcome Back',
            style: Get.textTheme.headlineSmall?.copyWith(color: kAccentColor),
          ),
        ),
        SizedBox(
          height: Get.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                /// username or Gmail
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username',
                  ),
                  controller: controller.nameController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    } else if (value.length < 3) {
                      return 'at least enter 4 characters';
                    } else if (value.length > 13) {
                      return 'maximum character is 13';
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: Get.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: controller.passwordController,
                    obscureText: controller.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isObscure.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          controller.isObscureActive();
                        },
                      ),
                      hintText: 'Password',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value.length < 3) {
                        return 'at least enter 6 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                  style: Get.textTheme.bodyMedium
                      ?.copyWith(color: kSecondaryTextColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),

                /// Login Button
                Obx(
                  () => controller.isLoadingLogin.isTrue
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          onTap: controller.onTapLogin,
                          text: "Login",
                          border: 30,
                          height: 50,
                        ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Login Button
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
        },
        child: const Text('Login'),
      ),
    );
  }

  TextStyle kLoginTitleStyle(Size size) => TextStyle(
        fontSize: size.height * 0.060,
        fontWeight: FontWeight.bold,
      );

  TextStyle kLoginSubtitleStyle(Size size) => TextStyle(
        fontSize: size.height * 0.030,
      );

  TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
      const TextStyle(fontSize: 15, color: Colors.grey, height: 1.5);

  TextStyle kHaveAnAccountStyle(Size size) =>
      TextStyle(fontSize: size.height * 0.022, color: Colors.black);

  TextStyle kLoginOrSignUpTextStyle(
    Size size,
  ) =>
      TextStyle(
        fontSize: size.height * 0.022,
        fontWeight: FontWeight.w500,
        color: Colors.deepPurpleAccent,
      );

  TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);
}
