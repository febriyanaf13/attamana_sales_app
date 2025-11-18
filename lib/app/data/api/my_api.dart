abstract class Api {
  // static const baseUrl = 'https://attamana.freightapp.in:444/api';

  static const baseUrl = 'https://demoerp.freightapp.in:444/api';

  // static const baseUrl = '192.168.18.15:8000/api';

  static const token = '$baseUrl/login';
  static const login = '$baseUrl/uslogin';

  //absen
  static const lokasiAbsen = '$baseUrl/get_lokasiabsen';
  static const simpanAbsenMasuk = '$baseUrl/absen-masuk';
  static const simpanAbsenPulang = '$baseUrl/absen-pulang';
  static const checkPresensihariIni = '$baseUrl/cek-absensi';
  static const getAnnouncement = '$baseUrl/pengumuman';

  static const riwayatAbsenHarian = '$baseUrl/riwayat_absen_harian';
  static const riwayatAbsenBulanan = '$baseUrl/riwayat_absen_bulanan';
  static const riwayatAbsenTahunan = '$baseUrl/riwayat_absen_tahunan';
  static const grafikAbsenBulanan = '$baseUrl/grafik_absen_bulanan';

  static const simpanPermohonanIjin = '$baseUrl/simpan_ijin';
  static const getAllShift = '$baseUrl/shifts';

  //cuti
  static const cuti = '$baseUrl/cuti-saya';
  static const tipeCuti = '$baseUrl/tipe-cutis';

  //terlambat
  static const terlambat = '$baseUrl/terlambat-saya';

  //lembur
  static const lembur = '$baseUrl/lembur-saya';

  //activity
  static const listActivity = '$baseUrl/list_kunjungan';
  static const detailActivity = '$baseUrl/detail_kunjungan';
  static const existingCustomer = '$baseUrl/get_allcustomer';
  static const jenisKunjungan = '$baseUrl/get_jenis_kunjungan';
  static const simpanActivity = '$baseUrl/save_kunjungan';
  static const updateActivity = '$baseUrl/update_kunjungan';
  static const presensiActivity = '$baseUrl/absen_kunjungan';
  static const kunjunganAutoCheckOutActivity = '$baseUrl/absen_autocheckout';
  static const lead = '$baseUrl/getmy_lead';

  //report visit
  static const reportVisit = '$baseUrl/visit_report';
  static const uploadCheckinImage = '$baseUrl/upload_checkin';

  //inventory
  static const listGudang = '$baseUrl/list_gudang';
  static const listStockBarang = '$baseUrl/list_stok';

  //sales monitoring
  static const salesOrder = '$baseUrl/so_monitoring';
  static const customer = '$baseUrl/getsales_customer';
  static const addCustomer = '$baseUrl/add_customer';
  static const updateCustomer = '$baseUrl/update_customer';
  static const sales = '$baseUrl/allsales';

  //sales report
  static const customerAssign = '$baseUrl/list_customer_assigned';
  static const customerNotAssign = '$baseUrl/list_customer_notassigned';
  static const customerSales = '$baseUrl/get_customersales';
  static const simpanAssignSales = '$baseUrl/simpan_assigned_sales';
  static const updateAssignSales = '$baseUrl/update_assigned_sales';

  //slip gaji
  static const slipGaji = '$baseUrl/slip-gaji-saya';

  //kendaraan
  static const kendaraan = '$baseUrl/kendaraan';
  static const bensin = '$baseUrl/bensin';

  //Fixedasset
  static const fixedasset = '$baseUrl/fixedassets';
  static const maintenance = '$baseUrl/maintenances';
  static const services = '$baseUrl/services';
  static const vendors = '$baseUrl/vendors';

  //acoount
  static const updatePassword = '$baseUrl/updatepassword';
}
