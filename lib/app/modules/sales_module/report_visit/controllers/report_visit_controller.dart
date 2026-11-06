import 'dart:io';

import 'package:attamana_salles_app/app/modules/sales_module/report_visit/models/report_visit.dart';
import 'package:attamana_salles_app/app/modules/sales_module/report_visit/models/sales.dart';
import 'package:attamana_salles_app/app/modules/sales_module/report_visit/providers/report_visit_provider.dart';
import 'package:attamana_salles_app/app/utils/constants.dart';
import 'package:attamana_salles_app/app/utils/extension_font.dart';
import 'package:attamana_salles_app/app/utils/string.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../activity/controllers/activity_controller.dart';
import '../../activity/models/existing_customer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../activity/providers/activity_provider.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'dart:io';

class ReportVisitController extends GetxController {
  //TODO: Implement ReportVisitController

  TextEditingController textEditingControllerSales =
      TextEditingController(text: 'ALL');
  TextEditingController textEditingControllerCustomer = TextEditingController();

  var activityC = Get.find<ActivityController>();
  var customerId = ''.obs;

  var managerSalesId = 'ALL'.obs;
  var listExistingCustomer = <ExistingCustomer>[].obs;

  var salesId = storage.read(kPegawaiId);
  var roles = storage.read(kRoleName);

  var tglMulai =
      '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}'
          .obs;
  var tglSelesai =
      '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}'
          .obs;
  var listReportVisit = <ReportVisit>[].obs;
  var listSales = <Sales>[].obs;

  var isLoadingeportVisit = false.obs;

  @override
  void onInit() async {
    // postRequstListReportVisit('');
    await getCustomerExisting();
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

  Future<void> getCustomerExisting() async {
    ActivityProvider().getExistingCustomer().then((value) {
      if (kDebugMode) {
        print("ini custommer existing ${value.body['data']}");
      }
      if (value.status.isOk) {
        var data = value.body['data'];
        listExistingCustomer.value = existingCustomerFromJson(data);
        listExistingCustomer.insert(
            0,
            ExistingCustomer(
                customerId: 0,
                namaHotel: 'ALL',
                kode: '',
                namaPerusahaan: '',
                alamatHotel: '',
                alamatPerusahaan: '',
                email: '',
                phone: ''));

        if (kDebugMode) {
          print('list existing custommer : ${activityC.listExistingCustomer2}');
        }
      }
    });
  }

  void postRequstListReportVisit() {
    var id = roles == 'SALES MANAGER' ? managerSalesId.value : salesId;
    var body = {
      'sales_id': id,
      'customer_id': customerId.value == '0' ? 'ALL' : customerId.value,
      'tgl_mulai': tglMulai.value,
      'tgl_selesai': tglSelesai.value,
    };
    print(body);
    isLoadingeportVisit.toggle();
    ReportVisitProvider().postRequestListReportVisit(body).then((value) {
      print("respons report visit : ${value.body}");

      isLoadingeportVisit.toggle();
      if (value.status.isOk) {
        var data = value.body['data'];
        listReportVisit.value = reportVisitFromJson(data);
      }
    }).timeout(const Duration(seconds: 30));
  }

  void getListSales() {
    ReportVisitProvider().getAllSales().then((value) {
      if (value.status.isOk) {
        var data = value.body['data'];
        // langsung parse ke model Sales
        listSales.value = salesFromJson(data);

        // kalau ingin ada opsi ALL, bisa tambahkan dummy Sales
        listSales.insert(
          0,
          Sales(pegawaiId: 0, nama: 'ALL'), // pegawaiId 0 untuk ALL
        );
      }
    }).catchError((e) {
      print('Error getListSales: $e');
    });
  }

  Future<void> exportReportVisitToPdf(List<ReportVisit> data) async {
    if (data.isEmpty) return;

    final pdf = pw.Document();

    /// LOAD FONT ROBOTO
    final fontRegular = await rootBundle.load('Roboto-Regular'.ttf);
    final fontBold = await rootBundle.load('Roboto-Bold'.ttf);

    final ttfRegular = pw.Font.ttf(fontRegular);
    final ttfBold = pw.Font.ttf(fontBold);

    /// ambil nama sales aktif
    String salesName = textEditingControllerSales.text.isEmpty
        ? 'all'
        : textEditingControllerSales.text;

    salesName = salesName.toLowerCase().replaceAll(' ', '_');

    /// tanggal
    final startDate = DateTime.parse(tglMulai.value);
    final endDate = DateTime.parse(tglSelesai.value);

    final startBulan =
        DateFormat('MMM', 'id_ID').format(startDate).toLowerCase();
    final endBulan = DateFormat('MMM', 'id_ID').format(endDate).toLowerCase();
    final tahun = DateFormat('yyyy').format(startDate);

    final fileName =
        'report_visit_sales_${salesName}_${startBulan}${tahun}_${endBulan}${tahun}.pdf';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          /// TITLE
          pw.Text(
            'REPORT VISIT SALES',
            style: pw.TextStyle(
              font: ttfBold,
              fontSize: 18,
            ),
          ),

          pw.SizedBox(height: 6),

          pw.Text(
            'Periode: ${tglMulai.value} s/d ${tglSelesai.value}',
            style: pw.TextStyle(font: ttfRegular),
          ),

          pw.SizedBox(height: 12),

          /// TABLE
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(3),
              3: const pw.FlexColumnWidth(3),
              4: const pw.FlexColumnWidth(3),
              5: const pw.FlexColumnWidth(2),
              6: const pw.FlexColumnWidth(4),
            },
            children: [
              /// HEADER
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _headerCell('No', ttfBold),
                  _headerCell('Tanggal', ttfBold),
                  _headerCell('Sales', ttfBold),
                  _headerCell('Hotel', ttfBold),
                  _headerCell('Perusahaan', ttfBold),
                  _headerCell('Status', ttfBold),
                  _headerCell('Alamat', ttfBold),
                ],
              ),

              /// DATA
              ...List.generate(data.length, (index) {
                final e = data[index];

                return pw.TableRow(
                  children: [
                    _bodyCell((index + 1).toString(), ttfRegular),
                    _bodyCell(
                      e.tanggalVisit != null
                          ? DateFormat('dd MMM yyyy', 'id_ID')
                              .format(e.tanggalVisit!)
                          : '-',
                      ttfRegular,
                    ),
                    _bodyCell(e.namaSales ?? '-', ttfRegular),
                    _bodyCell(e.namaHotel ?? '-', ttfRegular),
                    _bodyCell(e.namaPerusahaan ?? '-', ttfRegular),
                    _bodyCell(e.status ?? '-', ttfRegular),
                    _bodyCell(
                      (e.alamat ?? '-').replaceAll('\n', ' '),
                      ttfRegular,
                    ),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 10),

          /// FOOTER
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total data: ${data.length}',
              style: pw.TextStyle(font: ttfRegular, fontSize: 10),
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: fileName,
    );
  }

  pw.Widget _headerCell(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
        ),
      ),
    );
  }

  pw.Widget _bodyCell(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font),
        softWrap: true,
        maxLines: 5,
      ),
    );
  }

  void showExportPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Export Report',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                /// DOWNLOAD PDF
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: const Text('Download PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    exportReportVisitToPdf(listReportVisit);
                  },
                ),

                /// DOWNLOAD EXCEL
                ListTile(
                  leading: const Icon(Icons.table_chart, color: Colors.green),
                  title: const Text('Download Excel'),
                  onTap: () {
                    Navigator.pop(context);
                    exportReportVisitToExcel(listReportVisit);
                  },
                ),

                /// EXPORT GOOGLE SHEET
                ListTile(
                  leading: const Icon(Icons.cloud_upload, color: Colors.blue),
                  title: const Text('Export Spreadsheet'),
                  onTap: () {
                    Navigator.pop(context);
                    // exportReportVisitToGSheet(listReportVisit);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> exportReportVisitToExcel(List<ReportVisit> data) async {
    if (data.isEmpty) return;

    /// request permission Android
    if (Platform.isAndroid) {
      await ph.Permission.storage.request();
      await ph.Permission.manageExternalStorage.request();
    }

    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Report Visit');
    final sheet = excel['Report Visit'];

    /// FORMAT TANGGAL
    final dateFormat = DateFormat('dd-MM-yyyy');
    final dateTimeFormat = DateFormat('dd-MM-yyyy HH:mm');

    /// NAMA SALES
    String salesName = textEditingControllerSales.text.isEmpty
        ? 'All'
        : textEditingControllerSales.text;

    /// JUDUL
    final title = 'Report Visit $salesName';

    /// RANGE TANGGAL
    final startDate = DateTime.parse(tglMulai.value);
    final endDate = DateTime.parse(tglSelesai.value);
    final rangeTanggal =
        'Periode: ${dateFormat.format(startDate)} s/d ${dateFormat.format(endDate)}';

    /// ===== STYLE TENGAH =====
    final centerStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
    );

    /// ===== STYLE HEADER =====
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString("#D9D9D9"), // abu-abu muda
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    /// JUMLAH KOLM = 13
    int totalColumns = 13;

    /// Baris 1: judul
    sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("M1"));
    sheet.cell(CellIndex.indexByString("A1"))
      ..value = TextCellValue(title)
      ..cellStyle = centerStyle;

    /// Baris 2: range tanggal
    sheet.merge(CellIndex.indexByString("A2"), CellIndex.indexByString("M2"));
    sheet.cell(CellIndex.indexByString("A2"))
      ..value = TextCellValue(rangeTanggal)
      ..cellStyle = centerStyle;

    /// Baris 3: kosong (spasi)
    sheet.appendRow(List.generate(totalColumns, (_) => TextCellValue('')));

    /// Baris 4: HEADER
    final header = [
      'No',
      'Tanggal Visit',
      'Sales',
      'Hotel',
      'Perusahaan',
      'Alamat',
      'Action',
      'Notulen',
      'Status',
      'Checkin',
      'Lokasi Checkin',
      'Checkout',
      'Lokasi Checkout',
    ];

    // append header
    sheet.appendRow(header.map((h) => TextCellValue(h)).toList());

    // apply style header ke setiap cell
    int headerRow = sheet.maxRows - 1; // baris terakhir
    for (int col = 0; col < header.length; col++) {
      sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: headerRow))
        ..cellStyle = headerStyle;
    }

    /// DATA mulai dari baris 5
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      sheet.appendRow([
        IntCellValue(i + 1),
        TextCellValue(item.tanggalVisit != null
            ? dateFormat.format(item.tanggalVisit!)
            : ''),
        TextCellValue(item.namaSales),
        TextCellValue(item.namaHotel),
        TextCellValue(item.namaPerusahaan),
        TextCellValue(item.alamat),
        TextCellValue(item.action ?? ''),
        TextCellValue(item.notulen ?? ''),
        TextCellValue(item.status ?? ''),
        TextCellValue(item.waktuCheckin != null
            ? dateTimeFormat.format(item.waktuCheckin!)
            : ''),
        TextCellValue(item.lokasiCheckin ?? ''),
        TextCellValue(item.waktuCheckout != null
            ? dateTimeFormat.format(item.waktuCheckout!)
            : ''),
        TextCellValue(item.lokasiCheckout ?? ''),
      ]);
    }

    /// ===== PENAMAAN FILE =====
    salesName = salesName.toLowerCase().replaceAll(' ', '_');
    final startBulan =
        DateFormat('MMM', 'id_ID').format(startDate).toLowerCase();
    final endBulan = DateFormat('MMM', 'id_ID').format(endDate).toLowerCase();
    final tahun = DateFormat('yyyy').format(startDate);

    final fileName =
        'report_sales_${salesName}_${startBulan}${tahun}_${endBulan}${tahun}.xlsx';

    /// DIRECTORY
    Directory directory;
    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory())!;
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = "${directory.path}/$fileName";

    final fileBytes = excel.encode();
    if (fileBytes == null) return;

    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    /// buka file
    await OpenFile.open(file.path);
  }
}
