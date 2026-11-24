// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);
//
// VERSI 49: kolom tambahan dari API getsales_customer (tier, provinsi, PIC, jumlah SO, SO terakhir, dll).
// Kolom lama tetap sama sehingga form tambah / edit customer tidak berubah.

import 'dart:convert';

List<Customer> customerFromJson(List lst) =>
    List<Customer>.from(lst.map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String _teks(dynamic v, [String kosong = '-']) =>
    v == null || v.toString().trim().isEmpty ? kosong : v.toString().trim();

class Customer {
  int customerId;
  String corporate;
  String companyName;
  String nama;
  String address;
  String city;
  String country;
  String phone1;

  // VERSI 49
  String kode;
  String state;
  String email;
  String phone2;
  String tier;
  String tierWarna;
  String pic;
  String picHp;
  String paymentTerms;
  int hotelRating;
  String status;
  String statusCrm;
  int jumlahSo;
  String soTerakhir;

  Customer({
    required this.customerId,
    required this.corporate,
    required this.companyName,
    required this.nama,
    required this.address,
    required this.city,
    required this.country,
    required this.phone1,
    this.kode = '',
    this.state = '',
    this.email = '',
    this.phone2 = '',
    this.tier = '',
    this.tierWarna = '',
    this.pic = '',
    this.picHp = '',
    this.paymentTerms = '',
    this.hotelRating = 0,
    this.status = '',
    this.statusCrm = '',
    this.jumlahSo = 0,
    this.soTerakhir = '',
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: int.tryParse('${json["customer_id"]}') ?? 0,
        corporate: _teks(json["corporate"]),
        companyName: _teks(json["company_name"]),
        nama: _teks(json["nama"]),
        address: _teks(json["address"]),
        city: _teks(json["city"]),
        country: _teks(json["country"]),
        phone1: _teks(json["phone1"]),
        kode: _teks(json["kode"], ''),
        state: _teks(json["state"], ''),
        email: _teks(json["email"], ''),
        phone2: _teks(json["phone2"], ''),
        tier: _teks(json["tier"], ''),
        tierWarna: _teks(json["tier_warna"], ''),
        pic: _teks(json["pic"], ''),
        picHp: _teks(json["pic_hp"], ''),
        paymentTerms: _teks(json["payment_terms"], ''),
        hotelRating: int.tryParse('${json["hotel_rating"] ?? 0}') ?? 0,
        status: _teks(json["status"], ''),
        statusCrm: _teks(json["status_crm"], ''),
        jumlahSo: int.tryParse('${json["jumlah_so"] ?? 0}') ?? 0,
        soTerakhir: _teks(json["so_terakhir"], ''),
      );

  /// nama yang ditampilkan (nama hotel, bila kosong nama perusahaan)
  String get namaTampil => nama != '-' ? nama : companyName;

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "corporate": corporate,
        "company_name": companyName,
        "nama": nama,
        "address": address,
        "city": city,
        "country": country,
        "phone1": phone1,
        "kode": kode,
        "state": state,
        "email": email,
        "phone2": phone2,
        "tier": tier,
        "tier_warna": tierWarna,
        "pic": pic,
        "pic_hp": picHp,
        "payment_terms": paymentTerms,
        "hotel_rating": hotelRating,
        "status": status,
        "status_crm": statusCrm,
        "jumlah_so": jumlahSo,
        "so_terakhir": soTerakhir,
      };
}
