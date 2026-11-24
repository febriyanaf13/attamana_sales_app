// VERSI 49: model tracking sales order (API so_tracking).

import 'package:flutter/material.dart';

import '../../shared/sales_ui.dart';

class SoTracking {
  final int pesananId;
  final String noTransaksi;
  final String tglTransaksi;
  final String dueDate;
  final String namaCustomer;
  final String corporate;
  final double total;
  final String statusSo;
  final String statusVerifikasi;
  final String tahap;
  final String tahapLabel;
  final int tahapUrutan;
  final int tahapTotal;
  final int jumlahRencanaKirim;
  final List<SoProduk> produk;

  SoTracking({
    required this.pesananId,
    required this.noTransaksi,
    required this.tglTransaksi,
    required this.dueDate,
    required this.namaCustomer,
    required this.corporate,
    required this.total,
    required this.statusSo,
    required this.statusVerifikasi,
    required this.tahap,
    required this.tahapLabel,
    required this.tahapUrutan,
    required this.tahapTotal,
    required this.jumlahRencanaKirim,
    required this.produk,
  });

  factory SoTracking.fromJson(Map<String, dynamic> j) => SoTracking(
        pesananId: intDari(j['pesanan_id']),
        noTransaksi: teksDari(j['no_transaksi']),
        tglTransaksi: teksDari(j['tgl_transaksi']),
        dueDate: teksDari(j['due_date']),
        namaCustomer: teksDari(j['nama_customer']),
        corporate: teksDari(j['corporate']),
        total: angkaDari(j['total']),
        statusSo: teksDari(j['status_so']),
        statusVerifikasi: teksDari(j['status_verifikasi']),
        tahap: teksDari(j['tahap']),
        tahapLabel: teksDari(j['tahap_label']),
        tahapUrutan: intDari(j['tahap_urutan']),
        tahapTotal: j['tahap_total'] == null ? 8 : intDari(j['tahap_total']),
        jumlahRencanaKirim: intDari(j['jumlah_rencana_kirim']),
        produk: (j['produk'] is List ? j['produk'] as List : [])
            .map((e) => SoProduk.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

class SoProduk {
  final int productId;
  final String namaProduk;
  final String satuan;
  final double qtyPesanan;
  final double qtyRencanaKirim;
  final double qtyHasilProduksi;
  final double qtySiapKirim;
  final double qtyDifaktur;
  final double qtyTerkirim;
  final List<String> statusRencanaKirim;

  SoProduk({
    required this.productId,
    required this.namaProduk,
    required this.satuan,
    required this.qtyPesanan,
    required this.qtyRencanaKirim,
    required this.qtyHasilProduksi,
    required this.qtySiapKirim,
    required this.qtyDifaktur,
    required this.qtyTerkirim,
    required this.statusRencanaKirim,
  });

  factory SoProduk.fromJson(Map<String, dynamic> j) => SoProduk(
        productId: intDari(j['product_id']),
        namaProduk: teksDari(j['nama_produk']),
        satuan: teksDari(j['satuan']),
        qtyPesanan: angkaDari(j['qty_pesanan']),
        qtyRencanaKirim: angkaDari(j['qty_rencana_kirim']),
        qtyHasilProduksi: angkaDari(j['qty_hasil_produksi']),
        qtySiapKirim: angkaDari(j['qty_siap_kirim']),
        qtyDifaktur: angkaDari(j['qty_difaktur']),
        qtyTerkirim: angkaDari(j['qty_terkirim']),
        statusRencanaKirim: (j['status_rencana_kirim'] is List ? j['status_rencana_kirim'] as List : [])
            .map((e) => e.toString())
            .toList(),
      );
}

/// warna per tahap tracking
Color warnaTahap(String tahap) {
  switch (tahap) {
    case 'VERIFIKASI':
    case 'RENCANA_KIRIM':
    case 'KONFIRMASI_JADWAL':
      return kOranye;
    case 'MENUNGGU_PRODUKSI':
      return kUngu;
    case 'PRODUKSI':
      return kBiru;
    case 'SIAP_KIRIM':
    case 'TERINVOICE':
      return const Color(0xFF0D9488);
    case 'PENGIRIMAN':
      return const Color(0xFF4F46E5);
    case 'SELESAI':
      return kHijau;
    case 'BATAL':
      return kMerah;
  }
  return kSlate500;
}

IconData ikonTahap(String tahap) {
  switch (tahap) {
    case 'VERIFIKASI':
      return Icons.fact_check_rounded;
    case 'RENCANA_KIRIM':
    case 'KONFIRMASI_JADWAL':
      return Icons.event_note_rounded;
    case 'MENUNGGU_PRODUKSI':
      return Icons.hourglass_top_rounded;
    case 'PRODUKSI':
      return Icons.precision_manufacturing_rounded;
    case 'SIAP_KIRIM':
      return Icons.inventory_2_rounded;
    case 'TERINVOICE':
      return Icons.receipt_long_rounded;
    case 'PENGIRIMAN':
      return Icons.local_shipping_rounded;
    case 'SELESAI':
      return Icons.verified_rounded;
    case 'BATAL':
      return Icons.cancel_rounded;
  }
  return Icons.circle_outlined;
}

/// warna status rencana kirim (plan delivery)
Color warnaStatusPlan(String status) {
  switch (status) {
    case 'MENUNGGU KONFIRMASI PELANGGAN':
    case 'PERLU APPROVAL':
    case 'PERLU APPROVAL PPIC':
      return kOranye;
    case 'KONFIRMASI':
      return kUngu;
    case 'TERJADWAL':
    case 'PROSES PRODUKSI':
    case 'SELESAI DIPRODUKSI':
      return kBiru;
    case 'SIAP DIKIRIM':
    case 'TERINVOICE':
    case 'TERINVOICE SEBAGIAN':
      return const Color(0xFF0D9488);
    case 'PROSES PENGIRIMAN':
      return const Color(0xFF4F46E5);
    case 'BARANG TERKIRIM':
      return kHijau;
  }
  return kSlate500;
}
