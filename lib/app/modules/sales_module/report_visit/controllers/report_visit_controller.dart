import 'package:attamana_salles_app/app/modules/sales_module/report_visit/models/report_visit.dart';
import 'package:attamana_salles_app/app/modules/sales_module/report_visit/models/sales.dart';
import 'package:attamana_salles_app/app/modules/sales_module/report_visit/providers/report_visit_provider.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReportVisitController extends GetxController {
  //TODO: Implement ReportVisitController

  TextEditingController textEditingControllerSales =
      TextEditingController(text: 'ALL');

  var managerSalesId = 'ALL'.obs;

  var salesId = storage.read(kPegawaiId);
  var roles = storage.read(kRoleName);

  var tglMulai =
      '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}'
          .obs;
  var tglSelesai =
      '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}'
          .obs;
  var listReportVisit = <ReportVisit>[].obs;
  var listSales = <Map<String, String>>[].obs;

  var isLoadingeportVisit = false.obs;

  @override
  void onInit() {
    // postRequstListReportVisit('');
    getListSales();
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

  void postRequstListReportVisit() {
    var id = roles == 'SALES MANAGER' ? managerSalesId.value : salesId;
    var body = {
      'sales_id': id,
      'tgl_mulai': tglMulai.value,
      'tgl_selesai': tglSelesai.value,
    };
    print(body);
    isLoadingeportVisit.toggle();
    ReportVisitProvider().postRequestListReportVisit(body).then((value) {
      isLoadingeportVisit.toggle();
      if (value.status.isOk) {
        var data = value.body['data'];
        listReportVisit.value = reportVisitFromJson(data);
      }
    });
  }

  void getListSales() {
    ReportVisitProvider().getAllSales().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        listSales.value = salesFromJson(data)
            .map((e) => {'text': e.nama, 'value': e.pegawaiId.toString()})
            .toList();
        listSales.value.insert(0, {'text': 'ALL', 'value': 'ALL'});
      }
    });
  }
}
