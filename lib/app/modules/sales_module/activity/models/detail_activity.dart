// To parse this JSON data, do
//
//     final detailActivity = detailActivityFromJson(jsonString);

import 'dart:convert';

DetailActivity detailActivityFromJson(Map<String, dynamic> str) =>
    DetailActivity.fromJson(str);

String detailActivityToJson(DetailActivity data) => json.encode(data.toJson());

class DetailActivity {
  int id;
  dynamic leadId;
  int customerId;
  int salesId1;
  dynamic salesId2;
  DateTime tglAwal;
  dynamic tglReschedule;
  dynamic lokasi;
  dynamic lokasiRadius;
  dynamic action;
  dynamic notulen;
  dynamic status;
  DateTime waktuCheckin;
  dynamic waktuCheckout;
  dynamic lokasiCheckin;
  dynamic lokasiCheckout;
  int userCreated;
  int userModified;
  DateTime created;
  DateTime modified;
  dynamic ketcustomer;

  DetailActivity({
    required this.id,
    required this.leadId,
    required this.customerId,
    required this.salesId1,
    required this.salesId2,
    required this.tglAwal,
    required this.tglReschedule,
    required this.lokasi,
    required this.lokasiRadius,
    required this.action,
    required this.notulen,
    required this.status,
    required this.waktuCheckin,
    required this.waktuCheckout,
    required this.lokasiCheckin,
    required this.lokasiCheckout,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
    required this.ketcustomer,
  });

  factory DetailActivity.fromJson(Map<String, dynamic> json) => DetailActivity(
        id: json["id"],
        leadId: json["lead_id"],
        customerId: json["customer_id"],
        salesId1: json["sales_id1"],
        salesId2: json["sales_id2"],
        tglAwal: DateTime.parse(json["tgl_awal"]),
        tglReschedule: json["tgl_reschedule"],
        lokasi: json["lokasi"],
        lokasiRadius: json["lokasi_radius"],
        action: json["action"],
        notulen: json["notulen"],
        status: json["status"],
        waktuCheckin: DateTime.parse(json["waktu_checkin"]),
        waktuCheckout: json["waktu_checkout"],
        lokasiCheckin: json["lokasi_checkin"],
        lokasiCheckout: json["lokasi_checkout"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        ketcustomer: json["ketcustomer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "customer_id": customerId,
        "sales_id1": salesId1,
        "sales_id2": salesId2,
        "tgl_awal":
            "${tglAwal.year.toString().padLeft(4, '0')}-${tglAwal.month.toString().padLeft(2, '0')}-${tglAwal.day.toString().padLeft(2, '0')}",
        "tgl_reschedule": tglReschedule,
        "lokasi": lokasi,
        "lokasi_radius": lokasiRadius,
        "action": action,
        "notulen": notulen,
        "status": status,
        "waktu_checkin": waktuCheckin.toIso8601String(),
        "waktu_checkout": waktuCheckout,
        "lokasi_checkin": lokasiCheckin,
        "lokasi_checkout": lokasiCheckout,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "ketcustomer": ketcustomer,
      };
}
