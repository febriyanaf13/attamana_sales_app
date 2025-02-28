// To parse this JSON data, do
//
//     final services = servicesFromJson(jsonString);

import 'dart:convert';

List<Services> servicesFromJson(List list) =>
    List<Services>.from(list.map((x) => Services.fromJson(x)));

String servicesToJson(List<Services> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Services {
  int id;
  String namaService;
  String acuanService;
  int nilaiAcuan;
  int userCreated;
  int userModified;
  DateTime created;
  DateTime modified;

  Services({
    required this.id,
    required this.namaService,
    required this.acuanService,
    required this.nilaiAcuan,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        id: json["id"],
        namaService: json["nama_service"],
        acuanService: json["acuan_service"],
        nilaiAcuan: json["nilai_acuan"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_service": namaService,
        "acuan_service": acuanService,
        "nilai_acuan": nilaiAcuan,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
      };
}
