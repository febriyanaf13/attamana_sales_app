import 'package:attamana_salles_app/app/modules/account/views/account_view.dart';
import 'package:attamana_salles_app/app/modules/maps/views/maps_view.dart';
import 'package:attamana_salles_app/app/modules/staff_home/views/staff_home_view.dart';
import 'package:attamana_salles_app/app/modules/teams/views/teams_view.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentTabController tabController;

    tabController = PersistentTabController(initialIndex: 0);
    DateTime timeBackPressed = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final differeance = DateTime.now().difference(timeBackPressed);
        timeBackPressed = DateTime.now();
        if (differeance >= const Duration(seconds: 2)) {
          if (tabController.index == 0) {
            const String msg = 'Press the back button to exit';
            Fluttertoast.showToast(
              msg: msg,
            );
          } else {
            tabController.index = 0;
          }
          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
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
        onItemSelected: (value) => tabController.index = value,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        // hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        // popAllScreensOnTapOfSelectedTab: true,
        // popActionScreens: PopActionScreensType.all,
        // itemAnimationProperties: const ItemAnimationProperties(
        //   duration: Duration(milliseconds: 200),
        //   curve: Curves.ease,
        // ),
        // screenTransitionAnimation: const ScreenTransitionAnimation(
        //   animateTabTransition: true,
        //   curve: Curves.ease,
        //   duration: Duration(milliseconds: 200),
        // ),
        navBarStyle:
            controller.role == 'SALES' || controller.role == 'SALES MANAGER'
                ? NavBarStyle.style9
                : NavBarStyle.style15,
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const StaffHomeView(),
      const TeamsView(),
      const MapsView(),
      const Text('data'),
      const AccountView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.rectangle_stack_person_crop),
        title: ("Teams"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('logo_attamana'.png),
        title: ("Attendance"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.doc_checkmark),
        title: ("Leaves"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: ("Profiles"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<Widget> _buildScreensSales() {
    return [
      const StaffHomeView(),
      // const TeamsView(),
      // const Text('data'),
      const AccountView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsSales() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(CupertinoIcons.rectangle_stack_person_crop),
      //   title: ("Teams"),
      //   activeColorPrimary: kPrimaryColor,
      //   inactiveColorPrimary: CupertinoColors.systemGrey,
      // ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(CupertinoIcons.doc_checkmark),
      //   title: ("Leaves"),
      //   activeColorPrimary: kPrimaryColor,
      //   inactiveColorPrimary: CupertinoColors.systemGrey,
      // ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: ("Profiles"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
