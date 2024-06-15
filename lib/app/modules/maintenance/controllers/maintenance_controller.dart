import 'dart:io';

import 'package:attamana_salles_app/app/modules/fixedasset/controllers/fixedasset_controller.dart';
import 'package:attamana_salles_app/app/modules/maintenance/models/maintenance.dart';
import 'package:attamana_salles_app/app/modules/maintenance/models/services.dart';
import 'package:attamana_salles_app/app/modules/maintenance/providers/maintenance_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/vendors.dart';

class MaintenanceController extends GetxController {
  //TODO: Implement MaintenanceController

  //global key
  final formKeyMaintenance = GlobalKey<FormState>();

  //text editing controller
  TextEditingController textEditingControllerAsset = TextEditingController();
  TextEditingController textEditingControllerJenisServices =
      TextEditingController();
  TextEditingController textEditingControllerTotalBiaya =
      TextEditingController();
  TextEditingController textEditingControllerSparePart =
      TextEditingController();
  TextEditingController textEditingControllerTanggalMaintenance =
      TextEditingController();
  TextEditingController textEditingControllerNoMaintenance =
      TextEditingController();
  TextEditingController textEditingControllerVendors = TextEditingController();
  TextEditingController textEditingControllerNotes = TextEditingController();

  var listMaintenance = <Maintenance>[].obs;
  var listServices = <Services>[].obs;
  var listVendors = <Vendors>[].obs;
  var listServicesDropdown = <Map<String, Object>>[].obs;
  var listVendorsDropdown = <Map<String, Object>>[].obs;

  // controller
  var fixedassetC = Get.put(FixedassetController());

  //bool
  var isGantiSparePart = false.obs;
  var isLoadingSimpanMaintenance = false.obs;

  //file image maintenance
  File? imageMaintenance;
  var boolImageMaintenance = false.obs;

  @override
  void onInit() {
    getMaintenance();
    getServices();
    getVendors();
    fixedassetC.getFixedasset();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getMaintenance() {
    MaintenanceProvider().getMaintenance().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        listMaintenance.value = maintenanceFromJson(data);
      }
    });
  }

  void getServices() {
    MaintenanceProvider().getServices().then((value) {
      print(value.body);
      if (value.status.isOk) {
        var data = value.body['data'];
        listServices.value = servicesFromJson(data);
        listServicesDropdown.value = listServices
            .map(
                (element) => {'text': element.namaService, 'value': element.id})
            .toList();
      }
    });
  }

  void getVendors() {
    MaintenanceProvider().getVendors().then((value) {
      print(value.body);
      if (value.status.isOk) {
        var data = value.body['data'];
        listVendors.value = vendorsFromJson(data);
        listVendorsDropdown.value = listVendors
            .map((element) => {'text': element.nama, 'value': element.id})
            .toList();
      }
    });
  }

  Future getImageBukti() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo == null) return;

      final image = File(photo.path);
      boolImageMaintenance.value = true;
      imageMaintenance = image;
    } catch (e) {
      toast('Gagal mengambil gambar : $e');
    }
    update();
  }
}
