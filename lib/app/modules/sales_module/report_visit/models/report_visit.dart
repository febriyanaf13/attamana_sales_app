// To parse this JSON data, do
//
//     final reportVisit = reportVisitFromJson(jsonString);

import 'dart:convert';

List<ReportVisit> reportVisitFromJson(List lst) =>
    List<ReportVisit>.from(lst.map((x) => ReportVisit.fromJson(x)));

String reportVisitToJson(List<ReportVisit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportVisit {
  String leadId;
  int? customerId;
  int kunjunganId;
  DateTime? tanggalVisit;
  String namaSales;
  String namaHotel;
  String namaPerusahaan;
  String? action;
  String? notulen;
  String? lokasi;
  String? status;
  String? foto;
  DateTime? waktuCheckin;
  String? lokasiCheckin;
  DateTime? waktuCheckout;
  String? lokasiCheckout;
  String alamat;

  ReportVisit({
    required this.leadId,
    required this.customerId,
    required this.kunjunganId,
    required this.tanggalVisit,
    required this.namaHotel,
    required this.namaSales,
    required this.namaPerusahaan,
    required this.action,
    required this.notulen,
    required this.lokasi,
    required this.status,
    required this.foto,
    required this.waktuCheckin,
    required this.lokasiCheckin,
    required this.waktuCheckout,
    required this.lokasiCheckout,
    required this.alamat,
  });

  factory ReportVisit.fromJson(Map<String, dynamic> json) => ReportVisit(
        leadId: json["lead_id"],
        customerId: json["customer_id"],
        kunjunganId: json["kunjungan_id"],
        tanggalVisit: json["tanggal_visit"] == null
            ? null
            : DateTime.parse(json["tanggal_visit"]),
        namaSales: json["nama_sales"],
        namaHotel: json["nama_hotel"],
        namaPerusahaan: json["nama_perusahaan"],
        action: json["action"],
        notulen: json["notulen"],
        lokasi: json["lokasi"],
        status: json["status"],
        foto: json["foto"],
        waktuCheckin: json["waktu_checkin"] == null
            ? null
            : DateTime.parse(json["waktu_checkin"]),
        lokasiCheckin: json["lokasi_checkin"],
        waktuCheckout: json["waktu_checkout"] == null
            ? null
            : DateTime.parse(json["waktu_checkout"]),
        lokasiCheckout: json["lokasi_checkout"],
        alamat: json["alamat"],
      );

  Map<String, dynamic> toJson() => {
        "lead_id": leadId,
        "customer_id": customerId,
        "kunjungan_id": kunjunganId,
        "tanggal_visit":
            "${tanggalVisit!.year.toString().padLeft(4, '0')}-${tanggalVisit!.month.toString().padLeft(2, '0')}-${tanggalVisit!.day.toString().padLeft(2, '0')}",
        "nama_hotel": namaHotel,
        "nama_sales": namaSales,
        "nama_perusahaan": namaPerusahaan,
        "action": action,
        "notulen": notulen,
        "lokasi": lokasi,
        "status": status,
        "foto": foto,
        "waktu_checkin": waktuCheckin?.toIso8601String(),
        "lokasi_checkin": lokasiCheckin,
        "waktu_checkout": waktuCheckout?.toIso8601String(),
        "lokasi_checkout": lokasiCheckout,
        "alamat": alamat,
      };
}
