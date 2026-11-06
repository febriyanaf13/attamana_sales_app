// To parse this JSON data, do
//
//     final sales = salesFromJson(jsonString);

import 'dart:convert';

List<Sales> salesFromJson(List lst) =>
    List<Sales>.from(lst.map((x) => Sales.fromJson(x)));

String salesToJson(List<Sales> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sales {
  int pegawaiId;
  String nama;

  Sales({
    required this.pegawaiId,
    required this.nama,
  });

  factory Sales.fromJson(Map<String, dynamic> json) => Sales(
        pegawaiId: json["pegawai_id"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "pegawai_id": pegawaiId,
        "nama": nama,
      };

  @override
  String toString() {
    return nama;
  }

  @override
  bool filter(String query) {
    return nama.toLowerCase().contains(query.toLowerCase());
  }
}
