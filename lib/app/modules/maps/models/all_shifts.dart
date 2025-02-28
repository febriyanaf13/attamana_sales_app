// To parse this JSON data, do
//
//     final allShifts = allShiftsFromJson(jsonString);

import 'dart:convert';

List<AllShifts> allShiftsFromJson(List lst) =>
    List<AllShifts>.from(lst.map((x) => AllShifts.fromJson(x)));

String allShiftsToJson(List<AllShifts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllShifts {
  int id;
  String nama;
  String jamMasuk;
  String jamPulang;
  String toleransiTerlambat;
  dynamic userCreated;
  dynamic userModified;
  DateTime created;
  DateTime modified;

  AllShifts({
    required this.id,
    required this.nama,
    required this.jamMasuk,
    required this.jamPulang,
    required this.toleransiTerlambat,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
  });

  factory AllShifts.fromJson(Map<String, dynamic> json) => AllShifts(
        id: json["id"],
        nama: json["nama"],
        jamMasuk: json["jam_masuk"],
        jamPulang: json["jam_pulang"],
        toleransiTerlambat: json["toleransi_terlambat"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "jam_masuk": jamMasuk,
        "jam_pulang": jamPulang,
        "toleransi_terlambat": toleransiTerlambat,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
      };
}
