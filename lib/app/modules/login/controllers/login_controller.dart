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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (formKey.currentState!.validate()) {
      isLoadingLogin.toggle();

      LoginProvider()
          .postLogin(nameController.text, passwordController.text, token)
          .then((value) async {
        isLoadingLogin.toggle();
        if (value.status.isOk) {
          var success = value.body['success'];
          var message = value.body['message'];
          var data = value.body['data'];
          print(value.body);
          print(success);
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

  void getVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version.value = packageInfo.version;
  }
}
