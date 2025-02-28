import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/custom_app_bar.dart';
import '../../../style/borders.dart';
import '../../../style/colors.dart';
import '../../../style/paddings.dart';
import '../controllers/laporan_controller.dart';
import 'laporan_bulanini_view.dart';
import 'laporan_tahunini_view.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) { 
    return Obx(() => DefaultTabController(
          length: 2,
          initialIndex: controller.currentTabIndex.value,
          child: Scaffold(
            appBar: CustomAppBar(
              tabBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPagePadding),
                  child: Container(
                    decoration: BoxDecoration(
                        color: kGreyColor,
                        borderRadius: BorderRadius.circular(kDefaultBorder)),
                    child: TabBar(
                        labelColor: kPrimaryColor,
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        unselectedLabelColor: kSecondaryTextColor,
                        indicatorColor: kBoxColor,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(kDefaultBorder),
                          color: kBoxColor,
                        ),
                        padding: const EdgeInsets.all(5),
                        tabs: const [
                          Tab(
                            text: 'Bulan Ini',
                          ),
                          Tab(text: 'Tahun Ini'),
                        ]),
                  ),
                ),
              ),
            ),
            body: const TabBarView(
              children: [
                LaporanBulaniniView(),
                LaporanTahuniniView(),
                // TagihanKeuanganPage(),
                // RiwayatKeuanganPage(),
              ],
            ),
          ),
        ));
  }
}
