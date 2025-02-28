// To parse this JSON data, do
//
//     final lembur = lemburFromJson(jsonString);

import 'dart:convert';

List<Lembur> lemburFromJson(List lst) =>
    List<Lembur>.from(lst.map((x) => Lembur.fromJson(x)));

String lemburToJson(List<Lembur> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lembur {
  int id;
  DateTime tanggal;
  String jamMulai;
  String jamSelesai;
  String keterangan;

  Lembur({
    required this.id,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.keterangan,
  });

  factory Lembur.fromJson(Map<String, dynamic> json) => Lembur(
        id: json["id"],
        tanggal: DateTime.parse(json["tanggal"]),
        jamMulai: json["jam_mulai"],
        jamSelesai: json["jam_selesai"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "jam_mulai": jamMulai,
        "jam_selesai": jamSelesai,
        "keterangan": keterangan,
      };
}
