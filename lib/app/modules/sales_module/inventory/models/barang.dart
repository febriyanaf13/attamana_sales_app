// To parse this JSON data, do
//
//     final barang = barangFromJson(jsonString);

import 'dart:convert';

List<Barang> barangFromJson(List lst) =>
    List<Barang>.from(lst.map((x) => Barang.fromJson(x)));

String barangToJson(List<Barang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Barang {
  int stokId;
  String namaGudang;
  String namaProduk;
  String jumlahStok;
  String satuan;

  Barang({
    required this.stokId,
    required this.namaGudang,
    required this.namaProduk,
    required this.jumlahStok,
    required this.satuan,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        stokId: json["stok_id"],
        namaGudang: json["nama_gudang"].toString(),
        namaProduk: json["nama_produk"].toString(),
        jumlahStok: json["jumlah_stok"].toString(),
        satuan: json["satuan"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "stok_id": stokId,
        "nama_gudang": namaGudang,
        "nama_produk": namaProduk,
        "jumlah_stok": jumlahStok,
        "satuan": satuan,
      };
}
