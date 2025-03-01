import 'dart:convert';

List<JenisKunjungan> jenisKunjunganFromJson(List lst) =>
    List<JenisKunjungan>.from(lst.map((x) => JenisKunjungan.fromJson(x)));

String jenisKunjunganToJson(List<JenisKunjungan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JenisKunjungan {
  int jenisKunjunganId;
  String nama;

  JenisKunjungan({
    required this.jenisKunjunganId,
    required this.nama,
  });

  factory JenisKunjungan.fromJson(Map<String, dynamic> json) => JenisKunjungan(
        jenisKunjunganId: json["jenis_kunjungan_id"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "jenis_kunjungan_id": jenisKunjunganId,
        "nama": nama,
      };
}
