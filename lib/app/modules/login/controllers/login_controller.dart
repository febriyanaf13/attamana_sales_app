part of login;

class LoginController extends GetxController {
  final scafoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isObscure = true.obs;

  var token = storage.read('token');
  var version = ''.obs;

  var isLoadingLogin = false.obs;

  isObscureActive() {
    isObscure.value = !isObscure.value;
  }

  @override
  void onInit() {
    getVersionApp();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> onTapLogin() async {
    if (formKey.currentState!.validate()) {
      isLoadingLogin.value = true;

      try {
        // 1. Ambil token aplikasi & base URL terbaru dari server
        String currentVersion = version.value;
        if (currentVersion.isEmpty) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          currentVersion = packageInfo.version;
          version.value = currentVersion;
        }

        final tokenRes = await LoginProvider().reqToken(
          'attamanacrm',
          'febrimobile150708',
          currentVersion,
        );

        if (!tokenRes.status.isOk) {
          isLoadingLogin.value = false;
          if (tokenRes.status.isServerError) {
            dialogError('Terjadi Kesalahan',
                'Terjadi masalah pada server / koneksi internet lambat');
          } else if (tokenRes.status.connectionError) {
            dialogError('Koneksi Gagal',
                'Tidak dapat terhubung ke server.\nPastikan internet aktif atau server dapat diakses.');
          } else {
            dialogError('Gagal', 'Gagal memverifikasi aplikasi ke server');
          }
          return;
        }

        final tokenBody = tokenRes.body;
        if (kDebugMode) {
          print('status_code token (login) : ${tokenRes.statusCode}');
          print('response token body (login) : $tokenBody');
        }

        if (tokenBody == null || tokenBody['success'] != true) {
          isLoadingLogin.value = false;
          dialogWarning(
              'Gagal', tokenBody?['message'] ?? 'Otentikasi aplikasi gagal');
          return;
        }

        final validToken = '${tokenBody['token']}';
        storage.write('token', validToken);
        token = validToken;

        // 2. Jika response memiliki base_url / url baru, alihkan base URL aplikasi
        final dynamic serverUrl = tokenBody['base_url'] ?? tokenBody['url'];
        if (serverUrl != null &&
            serverUrl is String &&
            serverUrl.trim().isNotEmpty) {
          Api.setBaseUrl(serverUrl);
        }

        if (kDebugMode) {
          print('==================================================');
          print('🌐 [LOGIN] BASE URL AKTIF SAAT INI : ${Api.baseUrl}');
          print('🌐 [LOGIN] BASE URL DARI SERVER    : $serverUrl');
          print('==================================================');
        }

        // 3. Lakukan postLogin user menggunakan base URL dan token terbaru
        final value = await LoginProvider().postLogin(
          nameController.text.trim(),
          passwordController.text.trim(),
          validToken,
        );

        isLoadingLogin.value = false;
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          var data = value.body['data'];
          if (kDebugMode) {
            print(value.body);
            print(success);
          }
          List<String>? listStringGedung = [];
          List<String> listNamaGedung = [];

          if (success == true) {
            var jsonData = userFromJson(data);
            storage.write('userData', {
              "userid": jsonData[0].userid,
              "username": jsonData[0].username,
              "nama": jsonData[0].nama,
              "email": jsonData[0].email,
              "telepon": jsonData[0].telepon,
              "initial": jsonData[0].initial
            });
            storage.write('session', true);
            storage.write(kUserNama, jsonData[0].nama);
            storage.write(kUserId, jsonData[0].userid);
            storage.write(kUserEmail, jsonData[0].email);
            storage.write(kUserTelp, jsonData[0].telepon);
            // storage.write(kUserFoto, jsonData[0].);
            storage.write(kPegawaiId, jsonData[0].pegawaiId);

            var roles = jsonData[0].roles;
            var statusKaryawan = jsonData[0].statusKaryawan;

            awd.AwesomeDialog(
              context: Get.context!,
              dialogType: awd.DialogType.success,
              animType: awd.AnimType.topSlide,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('SELECT ROLE', style: Get.textTheme.titleLarge),
                  MediaQuery.removePadding(
                    removeTop: true,
                    context: Get.context!,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: roles.length,
                      padding: const EdgeInsets.all(20),
                      dragStartBehavior: DragStartBehavior.start,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          title: Text(roles[index].roleName),
                          onTap: () {
                            storage.write(kRoleName, roles[index].roleName);
                            storage.write(kStatusKaryawan, statusKaryawan);

                            // listStringGedung.add(jsonData[0].geometryAbsen);
                            listStringGedung = jsonData[0].geometryAbsen;
                            debugPrint("ini list poligon absen : " +
                                listStringGedung.toString());
                            storage.write(
                                kLokasiAbsen, jsonData[0].lokasiAbsen);
                            storage.write(
                                kGeometryLokasi, jsonData[0].geometryLokasi);
                            storage.write(kGeometryAbsen, listStringGedung);
                            Future.delayed(const Duration(seconds: 1), () {
                              // if (roles[index].roleName == 'SUPER ADMIN') {
                              //   Get.offAllNamed(Routes.DASHBOARD);
                              // } else if (roles[index].roleName == 'SALES') {
                              //   Get.offAllNamed(Routes.DASHBOARD);
                              // }
                              Get.offAllNamed(Routes.DASHBOARD);
                            });
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                  ),
                ],
              ),
            ).show();

            // Get.offNamed(Routes.HOME);
          } else {
            // dialogWarning('Opss... ', '$message');
            dialogWarning('Ops...', '$message');
          }
        } else if (value.status.isServerError) {
          dialogError('Terjadi Kesalahan',
              'Terjadi masalah pada server / koneksi internet lambat');
        } else if (value.status.connectionError) {
          dialogError(
              'Koneksi Gagal',
              'Tidak dapat terhubung ke server.\n'
                  'Pastikan internet aktif atau server dapat diakses.');
        }
      } catch (e) {
        isLoadingLogin.value = false;
        dialogError('Terjadi Kesalahan', 'Gagal memproses login: $e');
      }
    }
  }

  void getVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version.value = packageInfo.version;
  }
}
