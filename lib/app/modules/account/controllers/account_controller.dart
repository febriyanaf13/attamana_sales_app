import 'package:attamana_salles_app/app/services/notifikasi_service.dart';
import 'package:attamana_salles_app/app/modules/account/providers/account_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_dialog.dart';
import '../../../components/custom_dropdown_search2.dart';
import '../../../data/models/user.dart';
import '../../../routes/app_pages.dart';
import '../../../style/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper.dart';
import '../../../utils/string.dart';
import '../models/list_user.dart';
import '../views/account_view.dart';

class AccountController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordLamaController = TextEditingController();
  TextEditingController passwordBaruController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  var isObscurePasswordLama = true.obs;
  var isObscurePasswordBaru = true.obs;
  var isObscurePasswordConfirm = true.obs;
  RxBool isBiomatric = false.obs;

  var isLoadingUpdatePassword = false.obs;
  var isLoadingCekUser = false.obs;

  var version = ''.obs;
  var nama = storage.read(kUserNama);
  var userId = storage.read(kUserId);
  var email = storage.read(kUserEmail);
  var role = storage.read(kRoleName);

  var listUser = <ListUser>[].obs;
  ListUser? selectedUser;
  List<Role> roles = [];

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
              // VERSI 51: HP berhenti menerima notifikasi user ini
              if (Get.isRegistered<NotifikasiService>()) {
                await NotifikasiService.to.hapusToken();
              }
              await storage.remove('session');
              // storage.remove('userData');

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
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Text(
                  'Ganti Password',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B), // Slate 900
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pastikan password baru Anda aman dan mudah diingat',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const SizedBox(height: 30),

                // Password Lama
                Obx(() => _buildModernPasswordField(
                      controller: passwordLamaController,
                      hint: 'Password Saat Ini',
                      isObscure: isObscurePasswordLama.value,
                      onToggle: () => isObscurePasswordLama.toggle(),
                    )),
                const SizedBox(height: 16),

                // Password Baru
                Obx(() => _buildModernPasswordField(
                      controller: passwordBaruController,
                      hint: 'Password Baru',
                      isObscure: isObscurePasswordBaru.value,
                      onToggle: () => isObscurePasswordBaru.toggle(),
                    )),
                const SizedBox(height: 16),

                // Konfirmasi Password
                Obx(() => _buildModernPasswordField(
                      controller: passwordConfirmController,
                      hint: 'Konfirmasi Password Baru',
                      isObscure: isObscurePasswordConfirm.value,
                      onToggle: () => isObscurePasswordConfirm.toggle(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        } else if (value != passwordBaruController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    )),

                const SizedBox(height: 30),

                // Tombol Simpan
                Obx(() => isLoadingUpdatePassword.isTrue
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onTap: postUpdatePassword,
                        text: "SIMPAN PERUBAHAN",
                        border: 15,
                        height: 55,
                        gradient: LinearGradient(
                          colors: [kPrimaryColor, const Color(0xFF1E3C72)],
                        ),
                      )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

// Helper untuk styling TextField yang modern (Clean Soft Style)
  Widget _buildModernPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        // Slate 50
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon:
            Icon(Icons.lock_outline_rounded, color: kPrimaryColor, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade100, width: 1),
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

  void showAboutApp() {
    Get.dialog(
      AboutAppPopup(version: version.value),
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void onTapLoginAs() async {
    isLoadingCekUser.toggle();

    AccountProvider().getIdFromListUser().then((value) {
      isLoadingCekUser.toggle();
      if (value.status.isOk) {
        var success = value.body['success'];
        var message = value.body['message'];
        var data = value.body['data'];

        if (success) {
          listUser.value = listUserFromList(data);

          Get.bottomSheet(
            // --- TAMPILAN MODERN CONTAINER ---
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Handle Bar (Garis atas panel)
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      Text(
                        'Mode Simulasi',
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cari dan pilih user untuk login sebagai mereka',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13),
                      ),
                      const SizedBox(height: 30),

                      // --- DROPDOWN SEARCH (Tetap Menggunakan Logic Anda) ---
                      CustomDropDownSearch<ListUser>(
                        controller: nameController,
                        title: 'Pilih Nama User',
                        labelSpace: true,
                        isRequired: true,
                        withTitle: true,
                        hint: 'Ketik nama user...',
                        dataList: listUser,
                        itemLabel: (item) => item.nama,
                        onSelectedItem: (value) {
                          // LOGIC ASLI ANDA
                          selectedUser = value;
                          roles = value?.roles ?? [];
                          print("Selected user: ${value?.nama}");
                        },
                        validator: (x) {
                          if (x == null || x.trim().isEmpty) {
                            return 'Silahkan pilih user terlebih dahulu';
                          }
                          return null;
                        },
                        onSubmit: (value) {},
                        onSave: (value) {},
                      ),

                      const SizedBox(height: 30),

                      // --- BUTTON LOGIN (Gaya Modern Navy) ---
                      CustomButton(
                        onTap: () {
                          // Logic Pengecekan Sebelum Dialog
                          if (selectedUser == null) {
                            dialogWarning('Oops', 'User belum dipilih');
                            return;
                          }

                          // LOGIC ASLI ANDA (AwesomeDialog)
                          AwesomeDialog(
                            context: Get.context!,
                            dialogType: DialogType.noHeader,
                            // Ubah ke noHeader agar lebih clean
                            animType: AnimType.scale,
                            body: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text('PILIH ROLE',
                                    style: Get.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2)),
                                const SizedBox(height: 10),
                                const Divider(),
                                MediaQuery.removePadding(
                                  removeTop: true,
                                  context: Get.context!,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: roles.length,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                kPrimaryColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(Icons.person_outline,
                                              color: kPrimaryColor),
                                        ),
                                        title: Text(
                                          roles[index].roleName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        trailing: const Icon(
                                            Icons.chevron_right,
                                            size: 20),
                                        onTap: () {
                                          // LOGIC ASLI ANDA UNTUK SIMPAN KE STORAGE
                                          final user = selectedUser;
                                          final selectedRole = roles[index];

                                          storage.write(kUserId, user!.userid);
                                          storage.write(kUserNama, user.nama);
                                          storage.write(kUserEmail, user.email);
                                          storage.write(
                                              kRoleName, selectedRole.roleName);
                                          storage.write(
                                              kUserTelp, user.telepon);
                                          storage.write(
                                              kPegawaiId, user.pegawaiId);
                                          storage.write(kStatusKaryawan,
                                              user.statusKaryawan);
                                          storage.write(kGeometryLokasi,
                                              user.geometryLokasi);
                                          storage.write(kGeometryAbsen,
                                              user.geometryAbsen);
                                          storage.write(
                                              'role_id', selectedRole.roleId);
                                          storage.write('role_name',
                                              selectedRole.roleName);

                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            Get.offAllNamed(Routes.DASHBOARD);
                                          });
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 1),
                                  ),
                                ),
                              ],
                            ),
                          ).show();
                        },
                        text: "LANJUTKAN",
                        border: 15,
                        height: 55,
                        // Menggunakan gradient Navy yang kita buat di CustomButton
                        gradient: LinearGradient(
                          colors: [kPrimaryColor, const Color(0xFF1E3C72)],
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            isScrollControlled: true,
          );
        } else {
          dialogWarning('Ops...', message);
        }
      } else {
        dialogError('Gagal', 'Terjadi kesalahan saat mengambil data');
      }
    });
  }

  getIdFromListUser() {}

  void aktifkanBiomatric(value) async {
    bool biomatricSuport = await BiometricHelper().isBiometricSupported();
    bool canCheckBiometrics = await BiometricHelper().canCheckBiometrics();
    isBiomatric.value = value;
    if (kDebugMode) {
      print(value);
    }
    if (value == true) {
      if (biomatricSuport) {
        if (canCheckBiometrics) {
          if (kDebugMode) {
            print('Biometric sudah siap digunakan');
          }
          bool success = await BiometricHelper().authenticate();

          if (success) {
            storage.write(kBiomatricAuth, true);
            isBiomatric.value = true;
          } else {
            isBiomatric.value = false;
            storage.write(kBiomatricAuth, false);
          }
        } else {
          if (kDebugMode) {
            print('Biometric belum diatur, buka pengaturan');
          }
          BiometricHelper().showBiometricSetupDialog(Get.context!);
        }
      } else {
        Get.snackbar('Biomatric', 'Perangkat tidak mendukung biometric');
      }
    } else {
      if (kDebugMode) {
        print('Biometric Non Aktif');
      }
      storage.write(kBiomatricAuth, value);
    }
  }
}
