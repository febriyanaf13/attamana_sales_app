// To parse this JSON data, do
//
//     final maintenance = maintenanceFromJson(jsonString);

import 'dart:convert';

List<Maintenance> maintenanceFromJson(List lst) =>
    List<Maintenance>.from(lst.map((x) => Maintenance.fromJson(x)));

String maintenanceToJson(List<Maintenance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Maintenance {
  int id;
  int fixedassetId;
  int serviceId;
  int customerId;
  String namaFixedasset;
  String namaService;
  String customer;
  String nomorMaintenance;
  DateTime serviceDate;
  String bukti;
  String comment;
  dynamic odometer;
  dynamic spareParts;
  dynamic totalBiaya;

  Maintenance({
    required this.id,
    required this.fixedassetId,
    required this.serviceId,
    required this.customerId,
    required this.namaFixedasset,
    required this.namaService,
    required this.customer,
    required this.nomorMaintenance,
    required this.serviceDate,
    required this.bukti,
    required this.comment,
    required this.odometer,
    required this.spareParts,
    required this.totalBiaya,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) => Maintenance(
        id: json["id"],
        fixedassetId: json["fixedasset_id"],
        serviceId: json["service_id"],
        customerId: json["customer_id"],
        namaFixedasset: json["nama_fixedasset"],
        namaService: json["nama_service"],
        customer: json["customer"],
        nomorMaintenance: json["nomor_maintenance"],
        serviceDate: DateTime.parse(json["service_date"]),
        bukti: json["bukti"],
        comment: json["comment"],
        odometer: json["odometer"],
        spareParts: json["spare_parts"],
        totalBiaya: json["total_biaya"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fixedasset_id": fixedassetId,
        "service_id": serviceId,
        "customer_id": customerId,
        "nama_fixedasset": namaFixedasset,
        "nama_service": namaService,
        "customer": customer,
        "nomor_maintenance": nomorMaintenance,
        "service_date":
            "${serviceDate.year.toString().padLeft(4, '0')}-${serviceDate.month.toString().padLeft(2, '0')}-${serviceDate.day.toString().padLeft(2, '0')}",
        "bukti": bukti,
        "comment": comment,
        "odometer": odometer,
        "spare_parts": spareParts,
        "total_biaya": totalBiaya,
      };
}
