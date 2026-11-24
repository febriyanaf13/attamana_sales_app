import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../modules/notification/providers/notifikasi_provider.dart';
import '../modules/pendampingan/views/pendampingan_view.dart';
import '../modules/sales_module/sales_order/views/so_tracking_detail_view.dart';
import '../modules/sample_and_pricing/views/sample_detail_view.dart';
import '../routes/app_pages.dart';
import '../utils/constants.dart';
import '../utils/string.dart';

const _kChannelId = 'attamana_notif';
const _kChannelNama = 'Notifikasi Attamana';
const _kTokenFcm = 'fcm_token';

/// Pesan yang datang saat aplikasi tertutup / di latar belakang. Notifikasi ditampilkan otomatis oleh sistem
/// (payload `notification` dari server), jadi di sini tidak perlu apa-apa.
@pragma('vm:entry-point')
Future<void> notifikasiLatarBelakang(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

/// VERSI 51: push notification (Firebase Cloud Messaging) aplikasi sales.
///
/// - token HP didaftarkan ke server setelah login (StaffHome) dan saat token berganti, dihapus saat logout
/// - notifikasi yang datang saat aplikasi dibuka ditampilkan lewat flutter_local_notifications
/// - notifikasi yang diketuk membuka halaman terkait (tracking SO, request pendampingan, activity, sample)
/// - jumlah belum dibaca untuk badge lonceng di beranda
///
/// Bila Firebase belum dikonfigurasi (google-services.json belum ada), aplikasi tetap jalan tanpa push;
/// daftar notifikasi tetap bisa dibuka dari lonceng.
class NotifikasiService extends GetxService {
  static NotifikasiService get to => Get.find<NotifikasiService>();

  final aktif = false.obs;
  final jumlahBelum = 0.obs;
  final pendampinganMenunggu = 0.obs;

  final _lokal = FlutterLocalNotificationsPlugin();
  Map<String, dynamic>? _tujuanTertunda;

  static Future<void> pasang() async {
    final s = Get.put(NotifikasiService(), permanent: true);
    await s._init();
  }

  Future<void> _init() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(notifikasiLatarBelakang);
      aktif.value = true;
    } catch (e) {
      if (kDebugMode) print('Firebase belum dikonfigurasi: $e');
      return;
    }

    try {
      await _lokal.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: (r) {
          if (r.payload == null || r.payload!.isEmpty) return;
          try {
            bukaDariData(Map<String, dynamic>.from(jsonDecode(r.payload!)));
          } catch (_) {}
        },
      );
      await _lokal
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(const AndroidNotificationChannel(
            _kChannelId,
            _kChannelNama,
            description:
                'Status sales order, pendampingan activity, sample & pengingat',
            importance: Importance.high,
          ));

      // aplikasi sedang dibuka -> tampilkan sendiri & perbarui badge
      FirebaseMessaging.onMessage.listen((m) {
        final n = m.notification;
        if (n != null) {
          _lokal.show(
            m.hashCode,
            n.title,
            n.body,
            NotificationDetails(
              android: AndroidNotificationDetails(_kChannelId, _kChannelNama,
                  importance: Importance.high,
                  priority: Priority.high,
                  styleInformation: BigTextStyleInformation(n.body ?? '')),
              iOS: const DarwinNotificationDetails(),
            ),
            payload: jsonEncode(m.data),
          );
        }
        muatJumlah();
      });

      // diketuk saat aplikasi di latar belakang
      FirebaseMessaging.onMessageOpenedApp.listen((m) => bukaDariData(m.data));

      // diketuk saat aplikasi tertutup -> dibuka setelah beranda siap
      final awal = await FirebaseMessaging.instance.getInitialMessage();
      if (awal != null) _tujuanTertunda = awal.data;

      FirebaseMessaging.instance.onTokenRefresh.listen((t) => _kirimToken(t));
    } catch (e) {
      if (kDebugMode) print('Inisialisasi notifikasi gagal: $e');
    }
  }

  bool get _login =>
      storage.read('session') == true && storage.read(kUserId) != null;

  /// dipanggil setelah login / saat beranda dibuka
  Future<void> daftarkanToken() async {
    if (!aktif.value || !_login) return;
    try {
      final izin = await FirebaseMessaging.instance
          .requestPermission(alert: true, badge: true, sound: true);
      if (izin.authorizationStatus == AuthorizationStatus.denied) return;
      final t = await FirebaseMessaging.instance.getToken();
      if (t != null && t.isNotEmpty) await _kirimToken(t);
    } catch (e) {
      if (kDebugMode) print('Token FCM gagal: $e');
    }
  }

  Future<void> _kirimToken(String token) async {
    if (!_login) return;
    try {
      final info = await PackageInfo.fromPlatform();
      final r = await NotifikasiProvider().simpanPerangkat(
          token, Platform.isIOS ? 'ios' : 'android', info.version);
      if (r.status.isOk && r.body is Map && r.body['success'] == true) {
        storage.write(_kTokenFcm, token);
      }
    } catch (_) {}
  }

  /// dipanggil SEBELUM data login dihapus (logout): HP berhenti menerima notifikasi user ini
  Future<void> hapusToken() async {
    final t = storage.read(_kTokenFcm);
    if (t == null) return;
    try {
      await NotifikasiProvider().hapusPerangkat('$t');
    } catch (_) {}
    storage.remove(_kTokenFcm);
    jumlahBelum.value = 0;
    pendampinganMenunggu.value = 0;
  }

  Future<void> muatJumlah() async {
    if (!_login) return;
    try {
      final r = await NotifikasiProvider().getJumlah();
      if (r.status.isOk && r.body is Map && r.body['success'] == true) {
        jumlahBelum.value = int.tryParse('${r.body['belum_dibaca']}') ?? 0;
        pendampinganMenunggu.value =
            int.tryParse('${r.body['pendampingan_menunggu']}') ?? 0;
      }
    } catch (_) {}
  }

  /// dipanggil beranda setelah tampil: buka notifikasi yang diketuk saat aplikasi masih tertutup
  void prosesTertunda() {
    final d = _tujuanTertunda;
    _tujuanTertunda = null;
    if (d != null)
      Future.delayed(const Duration(milliseconds: 400), () => bukaDariData(d));
  }

  /// data push FCM: notif_id, tipe, ref_tabel, ref_id, url
  void bukaDariData(Map<String, dynamic> d) {
    if (!_login) return;
    final id = int.tryParse('${d['notif_id'] ?? ''}') ?? 0;
    if (id > 0) {
      NotifikasiProvider().baca(ids: [id]).then((_) => muatJumlah());
    }
    final refTabel = '${d['ref_tabel'] ?? ''}';
    final tipe = '${d['tipe'] ?? ''}';
    final refId = int.tryParse('${d['ref_id'] ?? ''}') ?? 0;
    String halaman = '';
    if (refTabel == 'pesanans' && refId > 0) {
      halaman = 'SO_TRACKING';
    } else if (refTabel == 'kunjungans' && tipe == 'PENDAMPINGAN') {
      halaman = 'PENDAMPINGAN';
    } else if (refTabel == 'kunjungans') {
      halaman = 'ACTIVITY';
    } else if (refTabel == 'samples' && refId > 0) {
      halaman = 'SAMPLE';
    }
    if (halaman.isEmpty) {
      Get.toNamed(Routes.NOTIFICATION);
    } else {
      bukaHalaman(halaman, refId);
    }
  }

  /// tujuan dari API daftar notifikasi (field `buka`)
  void bukaHalaman(String halaman, int id) {
    switch (halaman) {
      case 'SO_TRACKING':
        Get.to(() => SoTrackingDetailView(pesananId: id));
        break;
      case 'PENDAMPINGAN':
        Get.to(() => const PendampinganView());
        break;
      case 'ACTIVITY':
        Get.toNamed(Routes.ACTIVITY);
        break;
      case 'SAMPLE':
        Get.to(() => SampleDetailView(sampleId: id));
        break;
      default:
        break;
    }
  }
}
