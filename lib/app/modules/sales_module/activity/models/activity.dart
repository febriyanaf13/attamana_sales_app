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
  String? perluAbsen;

  /// VERSI 53: lokasi bertemu terbaru, approval, pendamping & hak aksi (dari list_kunjungan)
  String lokasiRadius;
  int radiusMeter;
  String statusLabel;
  String statusApproval;
  String alasanTolak;
  String statusLokasi;
  String lokasiAwal;
  String alasanUbahLokasi;
  String catatanApprovalLokasi;
  String salesId2;
  String namaPendamping;
  String statusPendamping;
  bool isPembuat;
  bool bisaUbahLokasi;
  String pesanUbahLokasi;
  bool bisaAbsen;

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
    required this.perluAbsen,
    this.lokasiRadius = '',
    this.radiusMeter = 500,
    this.statusLabel = '',
    this.statusApproval = '',
    this.alasanTolak = '',
    this.statusLokasi = '',
    this.lokasiAwal = '',
    this.alasanUbahLokasi = '',
    this.catatanApprovalLokasi = '',
    this.salesId2 = '',
    this.namaPendamping = '',
    this.statusPendamping = '',
    this.isPembuat = false,
    this.bisaUbahLokasi = false,
    this.pesanUbahLokasi = '',
    this.bisaAbsen = true,
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
        waktuCheckin: json["waktu_checkin"],
        waktuCheckout: json["waktu_checkout"] ?? '-',
        lokasiCheckin: json["lokasi_checkin"],
        lokasiCheckout: json["lokasi_checkout"],
        perluAbsen: json["perlu_absen"],
        lokasiRadius: '${json["lokasi_radius"] ?? ''}',
        radiusMeter: int.tryParse('${json["radius_meter"] ?? 500}') ?? 500,
        statusLabel: '${json["status_label"] ?? ''}',
        statusApproval: '${json["status_approval"] ?? ''}',
        alasanTolak: '${json["alasan_tolak"] ?? ''}',
        statusLokasi: '${json["status_lokasi"] ?? ''}',
        lokasiAwal: '${json["lokasi_awal"] ?? ''}',
        alasanUbahLokasi: '${json["alasan_ubah_lokasi"] ?? ''}',
        catatanApprovalLokasi: '${json["catatan_approval_lokasi"] ?? ''}',
        salesId2: '${json["sales_id2"] ?? ''}',
        namaPendamping: '${json["nama_pendamping"] ?? ''}',
        statusPendamping: '${json["status_pendamping"] ?? ''}',
        isPembuat: json["is_pembuat"] == true,
        bisaUbahLokasi: json["bisa_ubah_lokasi"] == true,
        pesanUbahLokasi: '${json["pesan_ubah_lokasi"] ?? ''}',
        bisaAbsen: json["bisa_absen"] != false,
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
