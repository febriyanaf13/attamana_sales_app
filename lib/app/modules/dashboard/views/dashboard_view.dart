import 'package:attamana_salles_app/app/modules/account/views/account_view.dart';
import 'package:attamana_salles_app/app/modules/maps/views/maps_view.dart';
import 'package:attamana_salles_app/app/modules/staff_home/views/staff_home_view.dart';
import 'package:attamana_salles_app/app/modules/teams/views/teams_view.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PersistentTabController tabController =
        PersistentTabController(initialIndex: 0);
    DateTime timeBackPressed = DateTime.now();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final difference = DateTime.now().difference(timeBackPressed);
        timeBackPressed = DateTime.now();

        if (difference >= const Duration(seconds: 2)) {
          if (tabController.index == 0) {
            Fluttertoast.showToast(msg: 'Tekan sekali lagi untuk keluar');
          } else {
            tabController.index = 0;
          }
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
        }
      },
      child: PersistentTabView(
        context,
        controller: tabController,
        screens:
            controller.role == 'SALES' || controller.role == 'SALES MANAGER'
                ? _buildScreensSales()
                : _buildScreens(),
        items: controller.role == 'SALES' || controller.role == 'SALES MANAGER'
            ? _navBarsItemsSales()
            : _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        // Ini menggantikan fungsi penyembunyian saat keyboard muncul
        stateManagement: true,

        // ── DEKORASI NAVBAR MODERN (Clean Soft Style) ───────────
        decoration: NavBarDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
          colorBehindNavBar: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),

        navBarStyle: NavBarStyle.style15, // Tombol tengah melayang
      ),
    );
  }

  // Helper untuk membuat item Nav Bar agar tetap konsisten
  PersistentBottomNavBarItem _buildNavItem({
    required Widget icon,
    required String title,
    bool isCenter = false,
  }) {
    return PersistentBottomNavBarItem(
      icon: isCenter
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: icon,
            )
          : icon,
      title: title,
      activeColorPrimary: kPrimaryColor,
      inactiveColorPrimary: Colors.grey.shade400,
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const StaffHomeView(),
      const TeamsView(),
      const MapsView(),
      const Center(child: Text('Leaves Page')),
      const AccountView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      _buildNavItem(icon: const Icon(CupertinoIcons.house_fill), title: "Home"),
      _buildNavItem(
          icon: const Icon(CupertinoIcons.person_2_fill), title: "Teams"),
      _buildNavItem(
        icon: Image.asset('logo_attamana'.png, scale: 12),
        title: "Absen",
        isCenter: true,
      ),
      _buildNavItem(
          icon: const Icon(CupertinoIcons.doc_text_fill), title: "Izin"),
      _buildNavItem(
          icon: const Icon(CupertinoIcons.person_crop_circle_fill),
          title: "Profil"),
    ];
  }

  List<Widget> _buildScreensSales() {
    return [
      const StaffHomeView(),
      const MapsView(),
      const AccountView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsSales() {
    return [
      _buildNavItem(icon: const Icon(CupertinoIcons.house_fill), title: "Home"),
      _buildNavItem(
        icon: Image.asset('logo_attamana'.png, scale: 12),
        title: "Absen",
        isCenter: true,
      ),
      _buildNavItem(
          icon: const Icon(CupertinoIcons.person_crop_circle_fill),
          title: "Profil"),
    ];
  }
}
