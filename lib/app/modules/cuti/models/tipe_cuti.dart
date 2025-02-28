// To parse this JSON data, do
//
//     final tipeCuti = tipeCutiFromJson(jsonString);

import 'dart:convert';

List<TipeCuti> tipeCutiFromJson(List lst) =>
    List<TipeCuti>.from(lst.map((x) => TipeCuti.fromJson(x)));

String tipeCutiToJson(List<TipeCuti> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TipeCuti {
  int id;
  String namaTipe;
  int kuota;
  int userCreated;
  int userModified;
  DateTime created;
  DateTime modified;

  TipeCuti({
    required this.id,
    required this.namaTipe,
    required this.kuota,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
  });

  factory TipeCuti.fromJson(Map<String, dynamic> json) => TipeCuti(
        id: json["id"],
        namaTipe: json["nama_tipe"],
        kuota: json["kuota"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_tipe": namaTipe,
        "kuota": kuota,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
      };
}
