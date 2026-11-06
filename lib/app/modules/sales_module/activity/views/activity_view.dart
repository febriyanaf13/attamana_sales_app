import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../../components/custom_button.dart';
import '../../../../style/colors.dart';
import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50 background
      appBar: AppBar(
        title: const Text(
          'Aktivitas Saya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.resetForm(); // Pastikan ada fungsi reset di controller
              Get.toNamed(Routes.ADD_ACTIVITY);
            },
            icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => DefaultTabController(
          length: 2,
          child: Column(
            children: [
              // --- CUSTOM TABBAR MODERN ---
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade400,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [kPrimaryColor, const Color(0xFF1E3C72)],
                      ),
                    ),
                    tabs: [
                      _buildTabItem(
                          "Open", controller.listActivityOpenProgress.length),
                      _buildTabItem(
                          "Completed", controller.listActivityCompleted.length),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    _buildActivityList(
                        controller.listActivityOpenProgress, false),
                    _buildActivityList(controller.listActivityCompleted, true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET LIST GENERATOR ---
  Widget _buildActivityList(List<dynamic> list, bool isCompleted) {
    if (list.isEmpty) return _buildEmptyState();

    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () async => controller.getListActivity(),
      child: ListView.separated(
        itemCount: list.length,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildActivityCard(list[index], isCompleted);
        },
      ),
    );
  }

  // --- PREMIUM ACTIVITY CARD ---
  Widget _buildActivityCard(dynamic item, bool isCompleted) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Accent Bar
              Container(
                width: 6,
                color: isCompleted ? Colors.green : kSecondaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Date & Action Button
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat("EEE, dd MMM yyyy", "id_ID")
                                .format(item.tanggalVisit),
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          _buildStatusBadge(isCompleted),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        '${item.action} - ${item.namaHotel}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B), // Slate 900
                        ),
                      ),
                      const Divider(height: 24, thickness: 1),

                      // Details
                      _buildInfoRow(Icons.share_location_rounded, "Lokasi",
                          item.lokasi.toString()),
                      _buildInfoRow(Icons.notes_rounded, "Deskripsi",
                          item.notulen ?? '-'),

                      if (isCompleted) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                                child: _buildTimeBox(
                                    "CHECK-IN", item.waktuCheckin ?? '--:--')),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _buildTimeBox("CHECK-OUT",
                                    item.waktuCheckout ?? '--:--')),
                          ],
                        ),
                      ],

                      // Button Detail/Absen
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            controller.getDetailActivity(
                              item.kunjunganId,
                              isCompleted ? 'COMPLETED' : 'OPEN',
                              item.perluAbsen ?? '',
                            );
                          },
                          icon: Icon(
                              isCompleted
                                  ? Icons.visibility_rounded
                                  : Icons.location_on_rounded,
                              size: 18),
                          label: Text(
                              isCompleted ? "LIHAT DETAIL" : "MULAI KUNJUNGAN"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCompleted
                                ? Colors.grey.shade100
                                : kPrimaryColor.withOpacity(0.1),
                            foregroundColor: isCompleted
                                ? Colors.grey.shade700
                                : kPrimaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
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
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildTabItem(String title, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child:
                  Text(count.toString(), style: const TextStyle(fontSize: 10)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(0.1)
            : kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isCompleted ? "SELESAI" : "PROSES",
        style: TextStyle(
          color: isCompleted ? Colors.green : kSecondaryColor,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                        color: Color(0xFF475569), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String label, String time) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold)),
          Text(time,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('logo_splash'.json, width: 180),
          const SizedBox(height: 20),
          const Text(
            'Belum ada aktivitas hari ini',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Text(
            'Klik tombol + untuk membuat rencana kunjungan.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
