// To parse this JSON data, do
//
//     final announcement = announcementFromJson(jsonString);

import 'dart:convert';

List<Announcement> announcementFromJson(List lst) =>
    List<Announcement>.from(lst.map((x) => Announcement.fromJson(x)));

String announcementToJson(List<Announcement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Announcement {
  int id;
  String nama;
  String keterangan;
  DateTime tanggalMulai;
  DateTime tanggalSelesai;

  Announcement({
    required this.id,
    required this.nama,
    required this.keterangan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json["id"],
        nama: json["nama"],
        keterangan: json["keterangan"],
        tanggalMulai: DateTime.parse(json["tanggal_mulai"]),
        tanggalSelesai: DateTime.parse(json["tanggal_selesai"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "keterangan": keterangan,
        "tanggal_mulai":
            "${tanggalMulai.year.toString().padLeft(4, '0')}-${tanggalMulai.month.toString().padLeft(2, '0')}-${tanggalMulai.day.toString().padLeft(2, '0')}",
        "tanggal_selesai":
            "${tanggalSelesai.year.toString().padLeft(4, '0')}-${tanggalSelesai.month.toString().padLeft(2, '0')}-${tanggalSelesai.day.toString().padLeft(2, '0')}",
      };
}
