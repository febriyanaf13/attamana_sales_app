// To parse this JSON data, do
//
//     final Activity = ActivityFromJson(jsonString);

import 'dart:convert';

List<Activity> activityFromJson(List lst) =>
    List<Activity>.from(lst.map((x) => Activity.fromJson(x)));

String activityToJson(List<Activity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Activity {
  int kunjunganId;
  var customerId;
  DateTime tanggalVisit;
  String namaHotel;
  String namaPerusahaan;
  String action;
  dynamic notulen;
  String lokasi;
  String? status;
  String? lokasiCheckin;
  dynamic waktuCheckin;
  dynamic waktuCheckout;
  String? lokasiCheckout;

  Activity({
    required this.kunjunganId,
    required this.customerId,
    required this.tanggalVisit,
    required this.namaHotel,
    required this.namaPerusahaan,
    required this.action,
    required this.notulen,
    required this.lokasi,
    required this.status,
    required this.waktuCheckin,
    required this.lokasiCheckin,
    required this.waktuCheckout,
    required this.lokasiCheckout,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        kunjunganId: json["kunjungan_id"],
        customerId: json["customer_id"],
        tanggalVisit: DateTime.parse(json["tanggal_visit"]),
        namaHotel: json["nama_hotel"],
        namaPerusahaan: json["nama_perusahaan"],
        action: json["action"] ?? '-',
        notulen: json["notulen"],
        lokasi: json["lokasi"],
        status: json["status"],
        waktuCheckin: json["waktu_checkin"] == null
            ? '-'
            : json["waktu_checkin"] == ""
                ? ""
                : DateTime.parse(json["waktu_checkin"]),
        waktuCheckout: json["waktu_checkout"] ?? '-',
        lokasiCheckin: json["lokasi_checkin"],
        lokasiCheckout: json["lokasi_checkout"],
      );

  Map<String, dynamic> toJson() => {
        "kunjungan_id": kunjunganId,
        "customer_id": customerId,
        "tanggal_visit":
            "${tanggalVisit.year.toString().padLeft(4, '0')}-${tanggalVisit.month.toString().padLeft(2, '0')}-${tanggalVisit.day.toString().padLeft(2, '0')}",
        "nama_hotel": namaHotel,
        "nama_perusahaan": namaPerusahaan,
        "action": action,
        "notulen": notulen,
        "lokasi": lokasi,
        "status": status,
        "waktu_checkin": waktuCheckin?.toIso8601String(),
        "waktu_checkout": waktuCheckout,
        "lokasi_checkin": lokasiCheckin,
        "lokasi_checkout": lokasiCheckout,
      };
}
