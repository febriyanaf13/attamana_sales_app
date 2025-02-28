// To parse this JSON data, do
//
//     final existingCustomer = existingCustomerFromJson(jsonString);

import 'dart:convert';

List<ExistingCustomer> existingCustomerFromJson(List lst) =>
    List<ExistingCustomer>.from(lst.map((x) => ExistingCustomer.fromJson(x)));

String existingCustomerToJson(List<ExistingCustomer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExistingCustomer {
  int customerId;
  String kode;
  String namaHotel;
  String namaPerusahaan;
  String alamatHotel;
  String? alamatPerusahaan;
  String? email;
  String? phone;

  ExistingCustomer({
    required this.customerId,
    required this.kode,
    required this.namaHotel,
    required this.namaPerusahaan,
    required this.alamatHotel,
    required this.alamatPerusahaan,
    required this.email,
    required this.phone,
  });

  factory ExistingCustomer.fromJson(Map<String, dynamic> json) =>
      ExistingCustomer(
        customerId: json["customer_id"],
        kode: json["kode"],
        namaHotel: json["nama_hotel"],
        namaPerusahaan: json["nama_perusahaan"],
        alamatHotel: json["alamat_hotel"],
        alamatPerusahaan: json["alamat_perusahaan"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "kode": kode,
        "nama_hotel": namaHotel,
        "nama_perusahaan": namaPerusahaan,
        "alamat_hotel": alamatHotel,
        "alamat_perusahaan": alamatPerusahaan,
        "email": email,
        "phone": phone,
      };
}
