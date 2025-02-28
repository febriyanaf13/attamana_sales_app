// To parse this JSON data, do
//
//     final customerSales = customerSalesFromJson(jsonString);

import 'dart:convert';

List<CustomerSales> customerSalesFromJson(List lst) =>
    List<CustomerSales>.from(lst.map((x) => CustomerSales.fromJson(x)));

String customerSalesToJson(List<CustomerSales> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerSales {
  int pegawaiId;
  String nama;

  CustomerSales({
    required this.pegawaiId,
    required this.nama,
  });

  factory CustomerSales.fromJson(Map<String, dynamic> json) => CustomerSales(
        pegawaiId: json["pegawai_id"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "pegawai_id": pegawaiId,
        "nama": nama,
      };
}
