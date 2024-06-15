import 'package:attamana_salles_app/app/modules/account/providers/account_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_dialog.dart';
import '../../../routes/app_pages.dart';
import '../../../style/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

class AccountController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordLamaController = TextEditingController();
  TextEditingController passwordBaruController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  var isObscurePasswordLama = true.obs;
  var isObscurePasswordBaru = true.obs;
  var isObscurePasswordConfirm = true.obs;

  var isLoadingUpdatePassword = false.obs;

  var version = ''.obs;
  var nama = storage.read(kUserNama);
  var userId = storage.read(kUserId);
  var email = storage.read(kUserEmail);

  @override
  void onInit() {
    getVersionApp();
    super.onInit();
  }

  void getVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version.value = packageInfo.version;
  }

  void onTapLogout() {
    Get.dialog(CupertinoAlertDialog(
      title: const Text("Logout"),
      actions: [
        CupertinoDialogAction(
            onPressed: () {
              Get.back();
            },
            child: const Text("Batal")),
        CupertinoDialogAction(
            onPressed: () async {
              await storage.remove('session');
              storage.remove('userData');

              Get.offAllNamed(
                Routes.LOGIN,
              );
            },
            child: const Text("Ya")),
      ],
      content: const Text("Yakin ingin keluar?"),
    ));
  }

  void onTapUpdatePassword() {
    Get.bottomSheet(SizedBox(
        width: Get.width,
        child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Ganti Password',
                      style: Get.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    Obx(
                      () => TextFormField(
                        controller: passwordLamaController,
                        obscureText: isObscurePasswordLama.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_open),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscurePasswordLama.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              isObscurePasswordLama.value =
                                  !isObscurePasswordLama.value;
                            },
                          ),
                          hintText: 'Password Lama',
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

                    /// password

                    Obx(
                      () => TextFormField(
                        controller: passwordBaruController,
                        obscureText: isObscurePasswordBaru.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_open),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscurePasswordBaru.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              isObscurePasswordBaru.value =
                                  !isObscurePasswordBaru.value;
                            },
                          ),
                          hintText: 'Password Baru',
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
                    Obx(
                      () => TextFormField(
                        controller: passwordConfirmController,
                        obscureText: isObscurePasswordConfirm.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_open),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscurePasswordConfirm.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              isObscurePasswordConfirm.value =
                                  !isObscurePasswordConfirm.value;
                            },
                          ),
                          hintText: 'Confirm Password',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter confirm password';
                          } else if (value != passwordBaruController.text) {
                            return 'Password not match';
                          }
                          // else if (value.length > 13) {
                          //   return 'maximum character is 13';
                          // }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(
                      height: Get.height * 0.05,
                    ),

                    Obx(
                      () => isLoadingUpdatePassword.isTrue
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomButton(
                              onTap: postUpdatePassword,
                              text: "Save",
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
            ))));
  }

  void postUpdatePassword() {
    if (formKey.currentState!.validate()) {
      isLoadingUpdatePassword.toggle();
      var body = {
        'userid': userId,
        'password_lama': passwordLamaController.text,
        'password_baru': passwordBaruController.text,
        'confirm': passwordConfirmController.text,
      };
      AccountProvider().postUpdatePassword(body).then((value) {
        isLoadingUpdatePassword.toggle();

        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          print(success);
          if (success) {
            dialogSuccess('Berhasil', message);
            Get.offAllNamed(Routes.DASHBOARD);
          } else {
            dialogWarning('Ops...', message);
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
  }
}
