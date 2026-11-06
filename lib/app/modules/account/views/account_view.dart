import 'dart:ui';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../style/colors.dart';
import '../../../style/paddings.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.isBiomatric.value = storage.read(kBiomatricAuth) ?? false;
    final isAdmin =
        controller.role == "SUPER ADMIN" || controller.role == "ADMIN";

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // Putih bersih sedikit keabuan
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profil Saya',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── HEADER PROFILE (Clean Style) ────────────────────────
            _buildCleanHeader(context),

            // ── MENU SECTION ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'PENGATURAN'),
                  _buildMenuCard([
                    _MenuTileClean(
                      icon: Icons.lock_outline_rounded,
                      iconColor: Colors.blue,
                      title: 'Keamanan Akun',
                      subtitle: 'Ubah password berkala',
                      onTap: () => controller.onTapUpdatePassword(),
                    ),
                    const _DividerClean(),
                    _MenuTileClean(
                      icon: Icons.fingerprint_rounded,
                      iconColor: Colors.teal,
                      title: 'Biometrik',
                      subtitle: 'Login sidik jari/wajah',
                      trailing: Obx(
                        () => Switch.adaptive(
                          value: controller.isBiomatric.value,
                          activeColor: kPrimaryColor,
                          onChanged: (v) => controller.aktifkanBiomatric(v),
                        ),
                      ),
                      onTap: () => controller
                          .aktifkanBiomatric(!controller.isBiomatric.value),
                    ),
                  ]),
                  if (isAdmin) ...[
                    const SizedBox(height: 20),
                    _SectionLabel(label: 'ADMINISTRASI'),
                    _buildMenuCard([
                      Obx(() => _MenuTileClean(
                            icon: Icons.admin_panel_settings_outlined,
                            iconColor: Colors.indigo,
                            title: 'Mode Simulasi (Login As)',
                            subtitle: 'Masuk sebagai user lain',
                            // Tampilkan indikator loading kecil jika sedang menarik data user
                            trailing: controller.isLoadingCekUser.isTrue
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : null,
                            onTap: controller.isLoadingCekUser.isTrue
                                ? () {} // Disable klik saat loading
                                : () => controller.onTapLoginAs(),
                          )),
                    ]),
                  ],
                  const SizedBox(height: 20),
                  _SectionLabel(label: 'APLIKASI'),
                  _buildMenuCard([
                    _MenuTileClean(
                      icon: Icons.info_outline_rounded,
                      iconColor: Colors.amber.shade700,
                      title: 'Tentang Aplikasi',
                      subtitle: 'Informasi detail sistem',
                      onTap: () {
                        controller.showAboutApp();
                      },
                    ),
                    const _DividerClean(),
                    _MenuTileClean(
                      icon: Icons.logout_rounded,
                      iconColor: Colors.redAccent,
                      title: 'Keluar',
                      titleColor: Colors.redAccent,
                      onTap: () => controller.onTapLogout(),
                    ),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: AssetImage('user_profile'.png),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Icon(Icons.camera_alt_outlined,
                    size: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            controller.nama,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.email,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              controller.role,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Column(children: children),
    );
  }
}

class _MenuTileClean extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? titleColor;

  const _MenuTileClean({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor ?? const Color(0xFF334155),
          fontSize: 15,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            )
          : null,
      trailing:
          trailing ?? Icon(Icons.chevron_right, color: Colors.grey.shade300),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DividerClean extends StatelessWidget {
  const _DividerClean();

  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 1, thickness: 1, color: const Color(0xFFF8FAFC), indent: 56);
  }
}

class AboutAppPopup extends StatelessWidget {
  final String version;

  const AboutAppPopup({Key? key, required this.version}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Aplikasi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'logo_attamana'.png,
                height: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ATTAMANA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: kPrimaryColor,
                letterSpacing: 2,
              ),
            ),
            Text(
              'Sales Management System',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 24),

            // Deskripsi Singkat
            Text(
              'Aplikasi ini dirancang untuk mempermudah manajemen penjualan, absensi presisi berbasis lokasi, dan pelaporan performa sales secara real-time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey.shade600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Info Versi & Copyright
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Versi Aplikasi: $version',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2024 Attamana Group',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Tutup
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
