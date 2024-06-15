// To parse this JSON data, do
//
//     final terlambat = terlambatFromJson(jsonString);

import 'dart:convert';

List<Terlambat> terlambatFromJson(List list) =>
    List<Terlambat>.from(list.map((x) => Terlambat.fromJson(x)));

String terlambatToJson(List<Terlambat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Terlambat {
  int id;
  int pegawaiId;
  int approvedBy;
  int tipeCutiId;
  DateTime startDate;
  int days;
  String note;
  dynamic noteFromApprover;
  String status;
  int userCreated;
  int userModified;
  DateTime created;
  DateTime modified;
  String bukti;

  Terlambat({
    required this.id,
    required this.pegawaiId,
    required this.approvedBy,
    required this.tipeCutiId,
    required this.startDate,
    required this.days,
    required this.note,
    required this.noteFromApprover,
    required this.status,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
    required this.bukti,
  });

  factory Terlambat.fromJson(Map<String, dynamic> json) => Terlambat(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        approvedBy: json["approved_by"],
        tipeCutiId: json["tipe_cuti_id"],
        startDate: DateTime.parse(json["start_date"]),
        days: json["days"],
        note: json["note"],
        noteFromApprover: json["note_from_approver"],
        status: json["status"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        bukti: json["bukti"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pegawai_id": pegawaiId,
        "approved_by": approvedBy,
        "tipe_cuti_id": tipeCutiId,
        "start_date": startDate.toIso8601String(),
        "days": days,
        "note": note,
        "note_from_approver": noteFromApprover,
        "status": status,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "bukti": bukti,
      };
}
