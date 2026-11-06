// To parse this JSON data, do
//
//     final gudang = gudangFromJson(jsonString);

import 'dart:convert';

List<Gudang> gudangFromJson(List lst) =>
    List<Gudang>.from(lst.map((x) => Gudang.fromJson(x)));

String gudangToJson(List<Gudang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Gudang {
  int gudangId;
  String kode;
  String namaGudang;
  String alamat;
  String deskripsi;
  String status;

  Gudang({
    required this.gudangId,
    required this.kode,
    required this.namaGudang,
    required this.alamat,
    required this.deskripsi,
    required this.status,
  });

  factory Gudang.fromJson(Map<String, dynamic> json) => Gudang(
        gudangId: json["gudang_id"],
        kode: json["kode"],
        namaGudang: json["nama_gudang"],
        alamat: json["alamat"],
        deskripsi: json["deskripsi"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "gudang_id": gudangId,
        "kode": kode,
        "nama_gudang": namaGudang,
        "alamat": alamat,
        "deskripsi": deskripsi,
        "status": status,
      };

  @override
  String toString() {
    return namaGudang;
  }

  @override
  bool filter(String query) {
    return namaGudang.toLowerCase().contains(query.toLowerCase());
  }
}
