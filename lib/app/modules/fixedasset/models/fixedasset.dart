// To parse this JSON data, do
//
//     final fIxedasset = fIxedassetFromJson(jsonString);

import 'dart:convert';

List<Fixedasset> fIxedassetFromJson(List lst) =>
    List<Fixedasset>.from(lst.map((x) => Fixedasset.fromJson(x)));

String fIxedassetToJson(List<Fixedasset> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Fixedasset {
  int id;
  int companyId;
  int tipeFixedassetId;
  String kodeAsset;
  String namaAsset;
  dynamic metode;
  DateTime tglBeli;
  String umur;
  DateTime tglSelesai;
  String hargaBeli;
  dynamic statusAktif;
  dynamic matauang;
  String kurs;
  dynamic tglJual;
  dynamic taggedNumber;
  dynamic hargaJual;
  dynamic labaRugi;
  dynamic akunAkuisisi;
  dynamic akunGainloss;
  dynamic akunDeposit;
  dynamic memo;
  dynamic statusDepresiasi;
  dynamic akunKredit;
  DateTime created;
  DateTime modified;
  int userCreated;
  int userModified;
  DateTime tglMulaiJurnal;
  dynamic faFiscal;
  dynamic ukuran;

  Fixedasset({
    required this.id,
    required this.companyId,
    required this.tipeFixedassetId,
    required this.kodeAsset,
    required this.namaAsset,
    required this.metode,
    required this.tglBeli,
    required this.umur,
    required this.tglSelesai,
    required this.hargaBeli,
    required this.statusAktif,
    required this.matauang,
    required this.kurs,
    required this.tglJual,
    required this.taggedNumber,
    required this.hargaJual,
    required this.labaRugi,
    required this.akunAkuisisi,
    required this.akunGainloss,
    required this.akunDeposit,
    required this.memo,
    required this.statusDepresiasi,
    required this.akunKredit,
    required this.created,
    required this.modified,
    required this.userCreated,
    required this.userModified,
    required this.tglMulaiJurnal,
    required this.faFiscal,
    required this.ukuran,
  });

  factory Fixedasset.fromJson(Map<String, dynamic> json) => Fixedasset(
        id: json["id"],
        companyId: json["company_id"],
        tipeFixedassetId: json["tipe_fixedasset_id"],
        kodeAsset: json["kode_asset"],
        namaAsset: json["nama_asset"],
        metode: json["metode"]!,
        tglBeli: DateTime.parse(json["tgl_beli"]),
        umur: json["umur"],
        tglSelesai: DateTime.parse(json["tgl_selesai"]),
        hargaBeli: json["harga_beli"],
        statusAktif: json["status_aktif"]!,
        matauang: json["matauang"]!,
        kurs: json["kurs"],
        tglJual: json["tgl_jual"],
        taggedNumber: json["tagged_number"],
        hargaJual: json["harga_jual"],
        labaRugi: json["laba_rugi"],
        akunAkuisisi: json["akun_akuisisi"],
        akunGainloss: json["akun_gainloss"],
        akunDeposit: json["akun_deposit"],
        memo: json["memo"]!,
        statusDepresiasi: json["status_depresiasi"]!,
        akunKredit: json["akun_kredit"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        tglMulaiJurnal: DateTime.parse(json["tgl_mulai_jurnal"]),
        faFiscal: json["fa_fiscal"]!,
        ukuran: json["ukuran"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "tipe_fixedasset_id": tipeFixedassetId,
        "kode_asset": kodeAsset,
        "nama_asset": namaAsset,
        "metode": metode,
        "tgl_beli":
            "${tglBeli.year.toString().padLeft(4, '0')}-${tglBeli.month.toString().padLeft(2, '0')}-${tglBeli.day.toString().padLeft(2, '0')}",
        "umur": umur,
        "tgl_selesai":
            "${tglSelesai.year.toString().padLeft(4, '0')}-${tglSelesai.month.toString().padLeft(2, '0')}-${tglSelesai.day.toString().padLeft(2, '0')}",
        "harga_beli": hargaBeli,
        "status_aktif": statusAktif,
        "matauang": matauang,
        "kurs": kurs,
        "tgl_jual": tglJual,
        "tagged_number": taggedNumber,
        "harga_jual": hargaJual,
        "laba_rugi": labaRugi,
        "akun_akuisisi": akunAkuisisi,
        "akun_gainloss": akunGainloss,
        "akun_deposit": akunDeposit,
        "memo": memo,
        "status_depresiasi": statusDepresiasi,
        "akun_kredit": akunKredit,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "user_created": userCreated,
        "user_modified": userModified,
        "tgl_mulai_jurnal":
            "${tglMulaiJurnal.year.toString().padLeft(4, '0')}-${tglMulaiJurnal.month.toString().padLeft(2, '0')}-${tglMulaiJurnal.day.toString().padLeft(2, '0')}",
        "fa_fiscal": faFiscal,
        "ukuran": ukuran,
      };
}
