// To parse this JSON data, do
//
//     final SalesOrder = SalesOrderFromJson(jsonString);

import 'dart:convert';

List<SalesOrder> SalesOrderFromJson(List lst) =>
    List<SalesOrder>.from(lst.map((x) => SalesOrder.fromJson(x)));

String SalesOrderToJson(List<SalesOrder> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesOrder {
  int pesananId;
  String noTransaksi;
  String namaSales;
  String namaCustomer;
  DateTime tglTransaksi;
  DateTime dueDate;
  String? status;
  List<Detail> detail;

  SalesOrder({
    required this.pesananId,
    required this.noTransaksi,
    required this.namaSales,
    required this.namaCustomer,
    required this.tglTransaksi,
    required this.dueDate,
    required this.status,
    required this.detail,
  });

  factory SalesOrder.fromJson(Map<String, dynamic> json) => SalesOrder(
        pesananId: json["pesanan_id"],
        noTransaksi: json["no_transaksi"],
        namaSales: json["nama_sales"],
        namaCustomer: json["nama_customer"],
        tglTransaksi: DateTime.parse(json["tgl_transaksi"]),
        dueDate: DateTime.parse(json["due_date"]),
        status: json["status"],
        detail:
            List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pesanan_id": pesananId,
        "no_transaksi": noTransaksi,
        "nama_sales": namaSales,
        "nama_customer": namaCustomer,
        "tgl_transaksi":
            "${tglTransaksi.year.toString().padLeft(4, '0')}-${tglTransaksi.month.toString().padLeft(2, '0')}-${tglTransaksi.day.toString().padLeft(2, '0')}",
        "due_date":
            "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
      };
}

class Detail {
  String namaProduk;
  String request;
  String inProgress;
  String done;
  String delivered;
  int outstanding;

  Detail({
    required this.namaProduk,
    required this.request,
    required this.inProgress,
    required this.done,
    required this.delivered,
    required this.outstanding,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        namaProduk: json["nama_produk"],
        request: json["request"],
        inProgress: json["in_progress"],
        done: json["done"],
        delivered: json["delivered"],
        outstanding: json["outstanding"],
      );

  Map<String, dynamic> toJson() => {
        "nama_produk": namaProduk,
        "request": request,
        "in_progress": inProgress,
        "done": done,
        "delivered": delivered,
        "outstanding": outstanding,
      };
}
