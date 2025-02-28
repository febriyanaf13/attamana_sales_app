// To parse this JSON data, do
//
//     final slipGaji = slipGajiFromJson(jsonString);

import 'dart:convert';

SlipGaji slipGajiByIdFromJson(Map<String, dynamic> str) =>
    SlipGaji.fromJson(str);

List<SlipGaji> slipGajiFromJson(List lst) =>
    List<SlipGaji>.from(lst.map((x) => SlipGaji.fromJson(x)));

String slipGajiToJson(List<SlipGaji> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SlipGaji {
  int id;
  int pegawaiId;
  DateTime tanggalAwal;
  int hariKerjaAktual;
  int hariAbsen;
  String jamLembur;
  String gajiPokok;
  String tunjangan;
  String homeBase;
  String bonus;
  String lembur;
  String revisi;
  String potonganAbsensi;
  String terlambat;
  String bpjsKes;
  String jht;
  String jkk;
  String jkm;
  String jp;
  String pinjaman;
  String lainLain;
  String brutoSetahun;
  String pph;
  String pphBulanan;
  String gajiDiterima;

  SlipGaji({
    required this.id,
    required this.pegawaiId,
    required this.tanggalAwal,
    required this.hariKerjaAktual,
    required this.hariAbsen,
    required this.jamLembur,
    required this.gajiPokok,
    required this.tunjangan,
    required this.homeBase,
    required this.bonus,
    required this.lembur,
    required this.revisi,
    required this.potonganAbsensi,
    required this.terlambat,
    required this.bpjsKes,
    required this.jht,
    required this.jkk,
    required this.jkm,
    required this.jp,
    required this.pinjaman,
    required this.lainLain,
    required this.brutoSetahun,
    required this.pph,
    required this.pphBulanan,
    required this.gajiDiterima,
  });

  factory SlipGaji.fromJson(Map<String, dynamic> json) => SlipGaji(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        hariKerjaAktual: json["hari_kerja_aktual"],
        hariAbsen: json["hari_absen"],
        jamLembur: json["jam_lembur"],
        gajiPokok: json["gaji_pokok"],
        tunjangan: json["tunjangan"],
        homeBase: json["home_base"],
        bonus: json["bonus"],
        lembur: json["lembur"],
        revisi: json["revisi"],
        potonganAbsensi: json["potongan_absensi"],
        terlambat: json["terlambat"],
        bpjsKes: json["bpjs_kes"],
        jht: json["jht"],
        jkk: json["jkk"],
        jkm: json["jkm"],
        jp: json["jp"],
        pinjaman: json["pinjaman"],
        lainLain: json["lain_lain"],
        brutoSetahun: json["bruto_setahun"],
        pph: json["pph"],
        pphBulanan: json["pph_bulanan"],
        gajiDiterima: json["gaji_diterima"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pegawai_id": pegawaiId,
        "tanggal_awal":
            "${tanggalAwal.year.toString().padLeft(4, '0')}-${tanggalAwal.month.toString().padLeft(2, '0')}-${tanggalAwal.day.toString().padLeft(2, '0')}",
        "hari_kerja_aktual": hariKerjaAktual,
        "hari_absen": hariAbsen,
        "jam_lembur": jamLembur,
        "gaji_pokok": gajiPokok,
        "tunjangan": tunjangan,
        "home_base": homeBase,
        "bonus": bonus,
        "lembur": lembur,
        "revisi": revisi,
        "potongan_absensi": potonganAbsensi,
        "terlambat": terlambat,
        "bpjs_kes": bpjsKes,
        "jht": jht,
        "jkk": jkk,
        "jkm": jkm,
        "jp": jp,
        "pinjaman": pinjaman,
        "lain_lain": lainLain,
        "bruto_setahun": brutoSetahun,
        "pph": pph,
        "pph_bulanan": pphBulanan,
        "gaji_diterima": gajiDiterima,
      };
}
