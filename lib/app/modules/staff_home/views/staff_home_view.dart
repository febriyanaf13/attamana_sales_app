import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/internet_connection_checker.dart';
import '../controllers/staff_home_controller.dart';

class StaffHomeView extends GetView<StaffHomeController> {
  const StaffHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var internetConnectionChecker = Get.put(InternetConnectionChecker());

    return Scaffold(
      backgroundColor: kCardColor,
      body: RefreshIndicator(
        color: kPrimaryColor,
        backgroundColor: kWhiteColor,
        strokeWidth: 2.5,
        onRefresh: () {
          return Future<void>.delayed(
            const Duration(seconds: 3),
            () {
              controller.getAnnouncement();
              controller.checkAbsenHariIni();
            },
          );
        },
        child: Column(
          children: [
            // ============================================================
            // HEADER + CARD PRESENSI
            // ============================================================
            SizedBox(
              height: Get.width * 0.6,
              child: Stack(
                children: [
                  // ---------- BACKGROUND HEADER ----------
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 50,
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        image: DecorationImage(
                          image: AssetImage('bg'.png),
                          repeat: ImageRepeat.repeat,
                          opacity: 0.08,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Decorative circles
                          Positioned(
                            top: -60,
                            right: -40,
                            child: _decorCircle(
                                180, kWhiteColor.withOpacity(0.06)),
                          ),
                          Positioned(
                            bottom: -80,
                            left: -50,
                            child: _decorCircle(
                                200, kWhiteColor.withOpacity(0.04)),
                          ),
                          Positioned(
                            top: 40,
                            right: 80,
                            child:
                                _decorCircle(80, kWhiteColor.withOpacity(0.08)),
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  kPrimaryColor.withOpacity(0.4),
                                  kPrimaryColor.withOpacity(0.95),
                                ],
                              ),
                            ),
                            child: Container(
                              width: Get.width,
                              padding: const EdgeInsets.all(20),
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SafeArea(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // ==== NAMA + STATUS + ROLE ====
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      'Hi, ${controller.nama}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Get
                                                          .textTheme.titleSmall
                                                          ?.copyWith(
                                                        color: kWhiteColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  // Status pill
                                                  Obx(
                                                    () => Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8,
                                                        vertical: 3,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: internetConnectionChecker
                                                                .isConnectedToInternet
                                                                .isTrue
                                                            ? const Color(
                                                                    0xFF16A34A)
                                                                .withOpacity(
                                                                    0.18)
                                                            : Colors.red
                                                                .withOpacity(
                                                                    0.18),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                          color: internetConnectionChecker
                                                                  .isConnectedToInternet
                                                                  .isTrue
                                                              ? const Color(
                                                                  0xFF3FFF00)
                                                              : Colors
                                                                  .red.shade300,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .radio_button_checked_rounded,
                                                            size: 9,
                                                            color: internetConnectionChecker
                                                                    .isConnectedToInternet
                                                                    .isTrue
                                                                ? const Color(
                                                                    0xFF3FFF00)
                                                                : Colors
                                                                    .redAccent,
                                                          ),
                                                          SizedBox(width: 4),
                                                          Text(
                                                            internetConnectionChecker
                                                                    .isConnectedToInternet
                                                                    .isTrue
                                                                ? 'Online'
                                                                : 'Offline',
                                                            style: Get.textTheme
                                                                .labelSmall
                                                                ?.copyWith(
                                                              color:
                                                                  kWhiteColor,
                                                              fontSize: 9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              // Role chip
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: kWhiteColor
                                                      .withOpacity(0.18),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: kWhiteColor
                                                        .withOpacity(0.4),
                                                    width: 0.8,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .verified_user_rounded,
                                                      size: 11,
                                                      color: kWhiteColor,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '${controller.roles}',
                                                      style: Get
                                                          .textTheme.labelSmall
                                                          ?.copyWith(
                                                        color: kWhiteColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // ==== NOTIFICATION ICON ====
                                        Stack(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Get.toNamed(
                                                    Routes.NOTIFICATION);
                                              },
                                              icon: Icon(
                                                Icons
                                                    .notifications_none_rounded,
                                                // Gunakan outline agar lebih clean
                                                color: kWhiteColor,
                                                size: 26,
                                              ),
                                            ),
                                            // Notification Badge Indicator
                                            Positioned(
                                              right: 12,
                                              top: 12,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xFFFF3B30), // Red dot
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: kPrimaryColor,
                                                      width: 1.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 8),
                                        // ==== AVATAR ====
                                        Container(
                                          padding: const EdgeInsets.all(2.5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                kWhiteColor,
                                                kWhiteColor.withOpacity(0.6),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.15),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                              controller.foto ?? '',
                                              fit: BoxFit.cover,
                                              width: 48,
                                              height: 48,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Image.asset(
                                                'user_profile'.png,
                                                fit: BoxFit.cover,
                                                width: 48,
                                                height: 48,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---------- CARD PRESENSI FLOATING ----------
                  Positioned(
                    bottom: 0,
                    left: 16,
                    right: 16,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                            color: const Color(0xFFF1F5F9), width: 1.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              // === CHECK-IN ===
                              Expanded(
                                flex: 3,
                                child: _presensiTileModern(
                                  label: 'MASUK',
                                  icon: Icons.login_rounded,
                                  color: const Color(0xFF10B981),
                                  time: Obx(() => Text(
                                        controller.waktuIn.value == 'null' ||
                                                controller.waktuIn.value == ''
                                            ? '--:--'
                                            : controller.waktuIn.value,
                                        style: const TextStyle(
                                          color: Color(0xFF1E293B),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      )),
                                ),
                              ),

                              // === DIVIDER ===
                              Container(
                                width: 1.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              // === JAM REALTIME ===
                              Expanded(
                                flex: 4,
                                child: StreamBuilder(
                                  stream: Stream.periodic(
                                      const Duration(seconds: 1)),
                                  builder: (context, snapshot) {
                                    controller.checkPresensiHariIni();
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat("EEEE", "id_ID")
                                              .format(DateTime.now())
                                              .toUpperCase(),
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                            letterSpacing: -1,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF1E293B),
                                            fontSize: 28,
                                          ),
                                        ),
                                        Text(
                                          DateFormat("dd MMM yyyy", "id_ID")
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              // === DIVIDER ===
                              Container(
                                width: 1.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              // === CHECK-OUT ===
                              Expanded(
                                flex: 3,
                                child: _presensiTileModern(
                                  label: 'PULANG',
                                  icon: Icons.logout_rounded,
                                  color: const Color(0xFFEF4444),
                                  time: Obx(() => Text(
                                        controller.waktuOut.value == 'null' ||
                                                controller.waktuOut.value == ''
                                            ? '--:--'
                                            : controller.waktuOut.value,
                                        style: const TextStyle(
                                          color: Color(0xFF1E293B),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ============================================================
            // KONTEN SCROLL (Menu + Announcement) — REDESIGN
            // ============================================================
            Expanded(
              child: SingleChildScrollView(
                primary: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ===== SECTION: MENU =====
                    _sectionTitle(
                      title: 'Menu',
                      subtitle: 'Akses cepat fitur kamu',
                    ),
                    const SizedBox(height: 10),
                    controller.roles == 'SALES' ||
                            controller.roles == 'SALES MANAGER'
                        ? salesMenu()
                        : staffMenu(),

                    const SizedBox(height: 24),

                    // ===== SECTION: ANNOUNCEMENT =====
                    _sectionTitle(
                      title: 'Pengumuman',
                      subtitle: 'Info terbaru untuk kamu',
                      trailing: Obx(
                        () => controller.listAnnounchement.isEmpty
                            ? const SizedBox()
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${controller.listAnnounchement.length} baru',
                                  style: Get.textTheme.labelSmall?.copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: Obx(
                        () => controller.listAnnounchement.isEmpty
                            ? _emptyAnnouncementNew()
                            : ListView.separated(
                                itemCount: controller.listAnnounchement.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final item =
                                      controller.listAnnounchement[index];
                                  return _announcementCard(item);
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 8);
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HELPERS — decorative
  // ============================================================
  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  // ============================================================
  // SECTION TITLE (BARU)
  // ============================================================
  Widget _sectionTitle({
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                    fontSize: 16,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Get.textTheme.labelSmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // ============================================================
  // ANNOUNCEMENT CARD (BARU)
  // ============================================================
  Widget _announcementCard(dynamic item) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row atas: icon + judul + tanggal
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Image.asset(
                      'announcement'.png,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nama,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 10, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${DateFormat.yMMMd().format(item.tanggalMulai)}  •  '
                              '${DateFormat.yMMMd().format(item.tanggalSelesai)}',
                              style: Get.textTheme.labelSmall?.copyWith(
                                color: Colors.grey.shade500,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Deskripsi
            Text(
              item.keterangan,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
                height: 1.5,
                fontSize: 11.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY ANNOUNCEMENT (BARU)
  // ============================================================
  Widget _emptyAnnouncementNew() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.campaign_outlined,
                size: 30,
                color: kPrimaryColor.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Belum ada pengumuman',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pengumuman terbaru akan muncul di sini',
              textAlign: TextAlign.center,
              style: Get.textTheme.labelSmall?.copyWith(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STAFF MENU (BARU)
  // ============================================================
  GridView staffMenu() {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 4 / 4,
        mainAxisExtent: Get.width / 5.4,
      ),
      children: [
        CustomMenuHome(
          title: 'Reports',
          icon: 'absen'.png,
          onTap: () => Get.toNamed(Routes.GRAFIK),
        ),
        CustomMenuHome(
          title: 'Cuti',
          icon: 'cuti'.png,
          onTap: () => Get.toNamed(Routes.CUTI),
        ),
        CustomMenuHome(
          title: 'Terlambat',
          icon: 'terlambat'.png,
          onTap: () => Get.toNamed(Routes.TERLAMBAT),
        ),
        CustomMenuHome(
          title: 'Lembur',
          icon: 'lembur'.png,
          onTap: () => Get.toNamed(Routes.LEMBUR),
        ),
        CustomMenuHome(
          title: 'Reimburse',
          icon: 'reimbursement'.png,
          onTap: () => Get.toNamed(Routes.REIMBURSE),
        ),
        CustomMenuHome(
          title: 'Slip Gaji',
          icon: 'slip_gaji'.png,
          onTap: () => Get.toNamed(Routes.SLIP_GAJI),
        ),
        CustomMenuHome(
          title: 'Kasbon',
          icon: 'kasbon'.png,
          onTap: () => Get.toNamed(Routes.KASBON),
        ),
        CustomMenuHome(
          title: 'More',
          icon: 'more'.png,
          onTap: () => showMoreMenu(),
        ),
      ],
    );
  }

  // ============================================================
  // SALES MENU (BARU)
  // ============================================================
  GridView salesMenu() {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 4 / 4,
        mainAxisExtent: Get.width / 5.4 + 16,
      ),
      children: [
        CustomMenuHome(
          title: 'Customers',
          icon: 'customer'.png,
          onTap: () => Get.toNamed(Routes.CUSTOMER),
        ),
        CustomMenuHome(
          title: 'Activity',
          icon: 'find_job'.png,
          onTap: () => Get.toNamed(Routes.ACTIVITY),
        ),
        CustomMenuHome(
          title: 'Sales Order',
          icon: 'so_monitoring'.png,
          onTap: () => Get.toNamed(Routes.SO_MONITORING),
        ),
        CustomMenuHome(
          title: 'Inventory',
          icon: 'inventory'.png,
          onTap: () => Get.toNamed(Routes.INVENTORY),
        ),
        CustomMenuHome(
          title: 'Report Visit',
          icon: 'report_visit'.png,
          onTap: () => Get.toNamed(Routes.REPORT_VISIT),
        ),
        CustomMenuHome(
          title: 'Sample & Pricing',
          icon: 'sample'.png,
          onTap: () => Get.toNamed(Routes.SAMPLE_AND_PRICING),
        ),
        controller.roles == 'SALES MANAGER' || controller.roles == 'DIREKTUR'
            ? CustomMenuHome(
                title: 'Assign Sales',
                icon: 'assign_sales'.png,
                onTap: () => Get.toNamed(Routes.ASSIGN_SALES),
              )
            : const SizedBox(),
      ],
    );
  }

  // ============================================================
  // BOTTOM SHEET "MORE"
  // ============================================================
  void showMoreMenu() {
    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.78,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: controller.roles == 'SALES' ||
                            controller.roles == 'SALES MANAGER'
                        ? _salesMoreContent()
                        : _staffMoreContent(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _salesMoreContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'More Menu',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _menuSectionCard(
          title: 'Sales Menu',
          icon: Icons.workspace_premium_rounded,
          children: [
            CustomMenuHome(
              title: 'Customers',
              icon: 'customer'.png,
              onTap: () => Get.toNamed(Routes.CUSTOMER),
            ),
            CustomMenuHome(
              title: 'Activity',
              icon: 'find_job'.png,
              onTap: () => Get.toNamed(Routes.ACTIVITY),
            ),
            CustomMenuHome(
              title: 'Report Visit',
              icon: 'report_visit'.png,
              onTap: () => Get.toNamed(Routes.REPORT_VISIT),
            ),
            CustomMenuHome(
              title: 'Sales Order',
              icon: 'so_monitoring'.png,
              onTap: () => Get.toNamed(Routes.SO_MONITORING),
            ),
            CustomMenuHome(
              title: 'Inventory',
              icon: 'inventory'.png,
              onTap: () => Get.toNamed(Routes.INVENTORY),
            ),
            CustomMenuHome(
              title: 'Lead',
              icon: 'lead'.png,
              onTap: () => Get.toNamed(Routes.LEAD),
            ),
            CustomMenuHome(
              title: 'Cuti',
              icon: 'cuti'.png,
              onTap: () => Get.toNamed(Routes.CUTI),
            ),
          ],
        ),
      ],
    );
  }

  Widget _staffMoreContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'More Menu',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _menuSectionCard(
          title: 'Main Menu',
          icon: Icons.apps_rounded,
          children: [
            CustomMenuHome(
              title: 'Reports',
              icon: 'absen'.png,
              onTap: () => Get.toNamed(Routes.GRAFIK),
            ),
            CustomMenuHome(
              title: 'Cuti',
              icon: 'cuti'.png,
              onTap: () => Get.toNamed(Routes.CUTI),
            ),
            CustomMenuHome(
              title: 'Terlambat',
              icon: 'terlambat'.png,
              onTap: () => Get.toNamed(Routes.TERLAMBAT),
            ),
            CustomMenuHome(
              title: 'Lembur',
              icon: 'lembur'.png,
              onTap: () => Get.toNamed(Routes.LEMBUR),
            ),
            CustomMenuHome(
              title: 'Reimburse',
              icon: 'reimbursement'.png,
              onTap: () => Get.toNamed(Routes.REIMBURSE),
            ),
            CustomMenuHome(
              title: 'Slip Gaji',
              icon: 'slip_gaji'.png,
              onTap: () => Get.toNamed(Routes.SLIP_GAJI),
            ),
            CustomMenuHome(
              title: 'Kasbon',
              icon: 'kasbon'.png,
              onTap: () => Get.toNamed(Routes.KASBON),
            ),
            CustomMenuHome(
              title: 'Kendaraan',
              icon: 'car'.png,
              onTap: () => Get.toNamed(Routes.KENDARAAN),
            ),
            CustomMenuHome(
              title: 'Bensin',
              icon: 'bensin'.png,
              onTap: () => Get.toNamed(Routes.BENSIN),
            ),
            CustomMenuHome(
              title: 'Maintenance',
              icon: 'maintenance'.png,
              onTap: () => Get.toNamed(Routes.MAINTENANCE),
            ),
            CustomMenuHome(
              title: 'Fixedasset',
              icon: 'fixedasset'.png,
              onTap: () => Get.toNamed(Routes.FIXEDASSET),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _menuSectionCard(
          title: 'Sales Menu',
          icon: Icons.workspace_premium_rounded,
          children: [
            CustomMenuHome(
              title: 'Activity',
              icon: 'find_job'.png,
              onTap: () => Get.toNamed(Routes.ACTIVITY),
            ),
            CustomMenuHome(
              title: 'Report Visit',
              icon: 'report_visit'.png,
              onTap: () => Get.toNamed(Routes.REPORT_VISIT),
            ),
            CustomMenuHome(
              title: 'Sales Order',
              icon: 'so_monitoring'.png,
              onTap: () => Get.toNamed(Routes.SO_MONITORING),
            ),
            CustomMenuHome(
              title: 'Inventory',
              icon: 'inventory'.png,
              onTap: () => Get.toNamed(Routes.INVENTORY),
            ),
            CustomMenuHome(
              title: 'Lead',
              icon: 'lead'.png,
              onTap: () => Get.toNamed(Routes.LEAD),
            ),
          ],
        ),
      ],
    );
  }

  Widget _menuSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: kPrimaryColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Get.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 4 / 4,
              mainAxisExtent: Get.width / 5.4,
            ),
            children: children,
          ),
        ],
      ),
    );
  }
}

// ================================================================
// CUSTOM MENU HOME — Card putih + border tipis + soft shadow
// ================================================================
class CustomMenuHome extends StatelessWidget {
  const CustomMenuHome({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: kPrimaryColor.withOpacity(0.10),
        highlightColor: kPrimaryColor.withOpacity(0.04),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFF1F5F9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    icon,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 6),
                AutoSizeText(
                  title,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                    letterSpacing: -0.1,
                  ),
                  maxLines: 2,
                  minFontSize: 8,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// PRESENSI TILE MODERN (untuk card presensi di header)
// ================================================================
Widget _presensiTileModern({
  required String label,
  required IconData icon,
  required Color color,
  required Widget time,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 2),
      time,
    ],
  );
}
