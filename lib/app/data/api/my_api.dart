import 'package:get_storage/get_storage.dart';

abstract class Api {
  // Key storage untuk menyimpan base URL dinamis
  static const kCustomBaseUrl = 'custom_base_url';

  // URL default (server utama)
  static const defaultBaseUrl = 'https://attamana.freightapp.in:444/api';

  // URL alternatif untuk demo (jika diperlukan sebagai referensi)
  static const demoBaseUrl = 'https://demoerp.freightapp.in:444/api';

  /// Base URL dinamis. Membaca custom URL yang tersimpan di storage (jika ada),
  /// atau fallback ke defaultBaseUrl.
  static String get baseUrl {
    try {
      final storage = GetStorage();
      final customUrl = storage.read<String>(kCustomBaseUrl);
      if (customUrl != null && customUrl.trim().isNotEmpty) {
        final clean = customUrl.trim();
        return clean.endsWith('/') ? clean.substring(0, clean.length - 1) : clean;
      }
    } catch (_) {}
    return defaultBaseUrl;
  }

  /// Update base URL dinamis ke storage. Bila [newUrl] null atau kosong, kembali ke default.
  static void setBaseUrl(String? newUrl) {
    final storage = GetStorage();
    if (newUrl == null || newUrl.trim().isEmpty) {
      storage.remove(kCustomBaseUrl);
    } else {
      var clean = newUrl.trim();
      if (clean.endsWith('/')) {
        clean = clean.substring(0, clean.length - 1);
      }
      storage.write(kCustomBaseUrl, clean);
    }
  }

  /// Request token handshake selalu memanggil gateway default/master
  static String get token => '$defaultBaseUrl/login';

  // Endpoint aplikasi lainnya mengikuti baseUrl aktif
  static String get login => '$baseUrl/uslogin';

  //absen
  static String get lokasiAbsen => '$baseUrl/get_lokasiabsen';
  static String get simpanAbsenMasuk => '$baseUrl/absen-masuk';
  static String get simpanAbsenPulang => '$baseUrl/absen-pulang';
  static String get checkPresensihariIni => '$baseUrl/cek-absensi';
  static String get getAnnouncement => '$baseUrl/pengumuman';

  static String get riwayatAbsenHarian => '$baseUrl/riwayat_absen_harian';
  static String get riwayatAbsenBulanan => '$baseUrl/riwayat_absen_bulanan';
  static String get riwayatAbsenTahunan => '$baseUrl/riwayat_absen_tahunan';
  static String get grafikAbsenBulanan => '$baseUrl/grafik_absen_bulanan';

  static String get simpanPermohonanIjin => '$baseUrl/simpan_ijin';
  static String get getAllShift => '$baseUrl/shifts';

  //cuti
  static String get cuti => '$baseUrl/cuti-saya';
  static String get tipeCuti => '$baseUrl/tipe-cutis';

  //terlambat
  static String get terlambat => '$baseUrl/terlambat-saya';

  //lembur
  static String get lembur => '$baseUrl/lembur-saya';

  //activity
  static String get listActivity => '$baseUrl/list_kunjungan';
  static String get detailActivity => '$baseUrl/detail_kunjungan';
  static String get existingCustomer => '$baseUrl/get_allcustomer';
  static String get jenisKunjungan => '$baseUrl/get_jenis_kunjungan';
  static String get simpanActivity => '$baseUrl/save_kunjungan';
  static String get updateActivity => '$baseUrl/update_kunjungan';
  static String get presensiActivity => '$baseUrl/absen_kunjungan';
  static String get kunjunganAutoCheckOutActivity => '$baseUrl/absen_autocheckout';
  static String get lead => '$baseUrl/getmy_lead';

  // VERSI 53: ubah lokasi bertemu dari HP & daftar pendamping
  static String get ubahLokasiActivity => '$baseUrl/ubah_lokasi_kunjungan';
  static String get listPendamping => '$baseUrl/list_pendamping';

  //report visit
  static String get reportVisit => '$baseUrl/visit_report';
  static String get uploadCheckinImage => '$baseUrl/upload_checkin';

  //inventory
  static String get listGudang => '$baseUrl/list_gudang';
  static String get listStockBarang => '$baseUrl/list_stok';

  //sales monitoring
  static String get salesOrder => '$baseUrl/so_monitoring';
  static String get customer => '$baseUrl/getsales_customer';
  static String get addCustomer => '$baseUrl/add_customer';
  static String get updateCustomer => '$baseUrl/update_customer';
  static String get sales => '$baseUrl/allsales';

  // VERSI 49: tracking sales order
  static String get soTracking => '$baseUrl/so_tracking';

  // VERSI 49: sample & pricing
  static String get sampleMaster => '$baseUrl/sample/master';
  static String get sampleCustomer => '$baseUrl/sample/customer';
  static String get samplePertanyaan => '$baseUrl/sample/pertanyaan';
  static String get sample => '$baseUrl/sample';
  static String get sampleSimpan => '$baseUrl/sample/simpan';
  static String get sampleUpdate => '$baseUrl/sample/update';
  // VERSI 61: kirim sample ke pelanggan & update status hasil (APPROVED / REVISI / FAIL)
  static String get sampleKirim => '$baseUrl/sample/kirim';
  static String get sampleStatus => '$baseUrl/sample/status';

  // VERSI 51: notifikasi (Firebase) & pendampingan activity
  static String get notifikasi => '$baseUrl/notifikasi';
  static String get notifikasiJumlah => '$baseUrl/notifikasi/jumlah';
  static String get notifikasiBaca => '$baseUrl/notifikasi/baca';
  static String get notifikasiPerangkat => '$baseUrl/notifikasi/perangkat';
  static String get notifikasiPerangkatHapus => '$baseUrl/notifikasi/perangkat/hapus';
  static String get pendampingan => '$baseUrl/pendampingan';
  static String get pendampinganPutuskan => '$baseUrl/pendampingan/putuskan';

  //sales report
  static String get customerAssign => '$baseUrl/list_customer_assigned';
  static String get customerNotAssign => '$baseUrl/list_customer_notassigned';
  static String get customerSales => '$baseUrl/get_customersales';
  static String get simpanAssignSales => '$baseUrl/simpan_assigned_sales';
  static String get updateAssignSales => '$baseUrl/update_assigned_sales';

  //slip gaji
  static String get slipGaji => '$baseUrl/slip-gaji-saya';

  //kendaraan
  static String get kendaraan => '$baseUrl/kendaraan';
  static String get bensin => '$baseUrl/bensin';

  //Fixedasset
  static String get fixedasset => '$baseUrl/fixedassets';
  static String get maintenance => '$baseUrl/maintenances';
  static String get services => '$baseUrl/services';
  static String get vendors => '$baseUrl/vendors';

  //acoount
  static String get updatePassword => '$baseUrl/updatepassword';

  //get user
  static String get getUser => '$baseUrl/get_user';

  //get provinsi
  static String get getProvinsi => '$baseUrl/list_provinsi';

  //get kabupaten
  static String get getKabupaten => '$baseUrl/list_kabupaten';
}
