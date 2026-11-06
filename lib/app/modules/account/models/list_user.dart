import 'dart:convert';

import '../../../data/models/user.dart';

List<ListUser> listUserFromJson(String str) =>
    List<ListUser>.from(json.decode(str).map((x) => ListUser.fromJson(x)));

List<ListUser> listUserFromList(List data) =>
    List<ListUser>.from(data.map((x) => ListUser.fromJson(x)));

String listUserToJson(List<ListUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListUser {
  int userid;
  String username;
  String nama;
  String email;
  String telepon;
  String initial;
  String pegawaiId;
  String lokasiAbsen;
  String statusKaryawan;
  String geometryLokasi;
  String geometryAbsen;
  List<Role> roles;

  ListUser({
    required this.userid,
    required this.username,
    required this.nama,
    required this.email,
    required this.telepon,
    required this.initial,
    required this.pegawaiId,
    required this.lokasiAbsen,
    required this.statusKaryawan,
    required this.geometryLokasi,
    required this.geometryAbsen,
    required this.roles,
  });

  factory ListUser.fromJson(Map<String, dynamic> json) => ListUser(
        userid: json["userid"] ?? 0,
        username: (json["username"] ?? "").toString().trim(),
        nama: (json["nama"] ?? "").toString().trim(),
        email: (json["email"] ?? "").toString().trim(),
        telepon: (json["telepon"] ?? "").toString().trim(),
        initial: (json["initial"] ?? "").toString().trim(),
        pegawaiId: (json["pegawai_id"] ?? "").toString().trim(),
        lokasiAbsen: (json["lokasi_absen"] ?? "").toString().trim(),
        statusKaryawan: (json["status_karyawan"] ?? "").toString().trim(),
        geometryLokasi: (json["geometry_lokasi"] ?? "").toString().trim(),
        geometryAbsen: (json["geometry_absen"] ?? "").toString().trim(),
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "username": username,
        "nama": nama,
        "email": email,
        "telepon": telepon,
        "initial": initial,
        "pegawai_id": pegawaiId,
        "lokasi_absen": lokasiAbsen,
        "status_karyawan": statusKaryawan,
        "geometry_lokasi": geometryLokasi,
        "geometry_absen": geometryAbsen,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return nama;
  }

  /// FILTER UNTUK SEARCH (INI KUNCI BIAR GA NGACO)
  bool filter(String query) {
    final q = query.toLowerCase().trim();

    return nama.toLowerCase().contains(q) ||
        username.toLowerCase().contains(q) ||
        email.toLowerCase().contains(q);
  }
}
