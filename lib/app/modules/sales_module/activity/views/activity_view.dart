import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/custom_button.dart';
import '../../../../style/colors.dart';
import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentTabIndex = 0.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activity Today'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.customerId.value = '';
                controller.action.value = '';
                controller.tglVisit.value =
                    '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
                controller.textEditingControllerDeskripsi.clear();
                controller.textEditingControllerAction.clear();
                controller.textEditingControllerNama.clear();
                controller.textEditingControllerAlamat.clear();
                Get.toNamed(Routes.ADD_ACTIVITY);
              },
              icon: const Icon(Icons.add_box))
        ],
      ),
      body: Obx(
        () => DefaultTabController(
          length: 2,
          initialIndex: currentTabIndex.value,
          child: Column(
            children: [
              PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: TabBar(
                      dividerHeight: 0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: kWhiteColor,
                      labelStyle: Get.textTheme.titleSmall,
                      unselectedLabelColor: kPrimaryColor,
                      indicatorColor: kWhiteColor,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kPrimaryColor,
                      ),
                      padding: const EdgeInsets.all(5),
                      tabs: [
                        Badge(
                          label: Text(controller.listActivityOpenProgress.length
                              .toString()),
                          isLabelVisible:
                              controller.listActivityOpenProgress.isEmpty
                                  ? false
                                  : true,
                          offset: const Offset(20, 15),
                          child: const Tab(
                            text: 'Open',
                          ),
                        ),
                        Badge(
                          label: Text(controller.listActivityCompleted.length
                              .toString()),
                          isLabelVisible:
                              controller.listActivityCompleted.isEmpty
                                  ? false
                                  : true,
                          offset: const Offset(20, 15),
                          child: const Tab(
                            text: 'Completed',
                          ),
                        ),
                      ]),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    customActivityOpen(),
                    customActivityCompleted(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Obx customActivityCompleted() {
    return Obx(
      () => controller.listActivity.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kamu belum memiliki rencana job visit. Buat Job visit sekarang?',
                    style: Get.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  50.height,
                  Lottie.asset(
                    'logo_splash'.json,
                    width: Get.width * 0.5,
                  ),
                  50.height,
                  CustomButton(
                      onTap: () {
                        Get.toNamed(Routes.ADD_ACTIVITY);
                      },
                      width: 200,
                      height: 50,
                      border: 30,
                      color: kSecondaryColor,
                      text: 'Buat Job Visit'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return Future<void>.delayed(
                  const Duration(seconds: 3),
                  () {
                    controller.getListActivity();
                  },
                );
              },
              child: ListView.separated(
                itemCount: controller.listActivityCompleted.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                          5.width,
                          Expanded(
                            child: AutoSizeText(
                              DateFormat("EEE, dd MMM yyyy", "id_ID").format(
                                  controller.listActivityCompleted[index]
                                      .tanggalVisit),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            'Edit',
                            style: Get.textTheme.bodySmall
                                ?.copyWith(color: Colors.blue),
                          ).onTap(() {
                            controller.textEditingControllerNama.text =
                                controller
                                    .listActivityCompleted[index].namaHotel;
                            // controller
                            //         .customerId
                            //         .value =
                            //     controller
                            //         .listActivityOpenProgress[
                            //             index]
                            //         .customerId;
                            print(controller
                                .listActivityCompleted[index].customerId);
                            controller.action.value =
                                controller.listActivityCompleted[index].action;
                            controller.tglVisit.value =
                                "${controller.listActivityCompleted[index].tanggalVisit.year}-${controller.listActivityCompleted[index].tanggalVisit.month}-${controller.listActivityCompleted[index].tanggalVisit.day}";
                            controller.textEditingControllerDeskripsi.text =
                                controller.listActivityCompleted[index].notulen;
                            controller.customerId.value = controller
                                .listActivityCompleted[index].customerId
                                .toString();

                            controller.getDetailActivity(
                                controller
                                    .listActivityCompleted[index].kunjunganId,
                                'EDIT');
                          }),
                        ],
                      ),
                      5.height,
                      Card(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${controller.listActivityCompleted[index].action} - ${controller.listActivityCompleted[index].lokasi}',
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      20.width,
                                      SizedBox(
                                        child: Card(
                                          color: Colors.green,
                                          child: const Icon(
                                            Icons.location_history,
                                            color: Colors.white,
                                            size: 30,
                                          ).onTap(
                                            () {
                                              controller.getDetailActivity(
                                                  controller
                                                      .listActivityCompleted[
                                                          index]
                                                      .kunjunganId,
                                                  'COMPLETED');
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const Icon(
                                  //       Icons.home_work,
                                  //       color: grey,
                                  //       size: 20,
                                  //     ),
                                  //     5.width,
                                  //     Expanded(
                                  //       child: Text(
                                  //         controller
                                  //                     .listActivityOpenProgress[
                                  //                         index]
                                  //                     .namaHotel ==
                                  //                 ''
                                  //             ? controller
                                  //                 .listActivityOpenProgress[
                                  //                     index]
                                  //                 .lokasi
                                  //             : controller
                                  //                 .listActivityOpenProgress[
                                  //                     index]
                                  //                 .namaHotel,
                                  //         style: Get.textTheme.bodySmall,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.share_location_outlined,
                                        color: grey,
                                        size: 20,
                                      ),
                                      5.width,
                                      Text(
                                        'Alamat : ',
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Text(
                                          controller
                                              .listActivityCompleted[index]
                                              .lokasi
                                              .toString(),
                                          style: Get.textTheme.bodySmall,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.note_alt_outlined,
                                        color: grey,
                                        size: 20,
                                      ),
                                      5.width,
                                      Text(
                                        'Deskripsi :',
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .listActivityCompleted[index]
                                                  .notulen ??
                                              '-',
                                          style: Get.textTheme.bodySmall,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.watch_later_outlined,
                                        color: grey,
                                        size: 20,
                                      ),
                                      5.width,
                                      Text(
                                        'Checkin :',
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .listActivityCompleted[index]
                                                  .waktuCheckin
                                                  .toString() ??
                                              '-',
                                          style: Get.textTheme.bodySmall,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.watch_later_outlined,
                                        color: grey,
                                        size: 20,
                                      ),
                                      5.width,
                                      Text(
                                        'Checkout :',
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .listActivityCompleted[index]
                                                  .waktuCheckout
                                                  .toString() ??
                                              '-',
                                          style: Get.textTheme.bodySmall,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 5,
                                decoration: const BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return 10.height;
                },
              ),
            ),
    );
  }

  Obx customActivityOpen() {
    return Obx(
      () => controller.listActivity.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kamu belum memiliki rencana job visit. Buat Job visit sekarang?',
                    style: Get.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  50.height,
                  Lottie.asset(
                    'logo_splash'.json,
                    width: Get.width * 0.5,
                  ),
                  50.height,
                  CustomButton(
                      onTap: () {
                        Get.toNamed(Routes.ADD_ACTIVITY);
                      },
                      width: 200,
                      height: 50,
                      border: 30,
                      color: kSecondaryColor,
                      text: 'Buat Job Visit'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return Future<void>.delayed(
                  const Duration(seconds: 3),
                  () {
                    controller.getListActivity();
                  },
                );
              },
              child: ListView.separated(
                itemCount: controller.listActivityOpenProgress.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  print(
                      "activity open : ${controller.listActivityOpenProgress.length}");
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                          5.width,
                          Expanded(
                            child: AutoSizeText(
                              DateFormat("EEE, dd MMM yyyy", "id_ID").format(
                                  controller.listActivityOpenProgress[index]
                                      .tanggalVisit),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            'Edit',
                            style: Get.textTheme.bodySmall
                                ?.copyWith(color: Colors.blue),
                          ).onTap(() {
                            controller.textEditingControllerNama.text =
                                controller
                                    .listActivityOpenProgress[index].namaHotel;
                            // controller
                            //         .customerId
                            //         .value =
                            //     controller
                            //         .listActivityOpenProgress[
                            //             index]
                            //         .customerId;
                            print(controller
                                .listActivityOpenProgress[index].customerId);
                            controller.action.value = controller
                                .listActivityOpenProgress[index].action;
                            controller.tglVisit.value =
                                "${controller.listActivityOpenProgress[index].tanggalVisit.year}-${controller.listActivityOpenProgress[index].tanggalVisit.month}-${controller.listActivityOpenProgress[index].tanggalVisit.day}";
                            controller.textEditingControllerDeskripsi.text =
                                controller
                                    .listActivityOpenProgress[index].notulen;
                            controller.customerId.value = controller
                                .listActivityOpenProgress[index].customerId
                                .toString();

                            controller.getDetailActivity(
                                controller.listActivityOpenProgress[index]
                                    .kunjunganId,
                                'EDIT');
                          }),
                        ],
                      ),
                      5.height,
                      Card(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${controller.listActivityOpenProgress[index].action} - ${controller.listActivityOpenProgress[index].lokasi}',
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      20.width,
                                      // proteksi absen

                                      if (controller.listButuhLokasi.contains(
                                          controller
                                              .listActivityOpenProgress[index]
                                              .action
                                              .toString()))
                                        SizedBox(
                                          child: Card(
                                            color: Colors.green,
                                            child: const Icon(
                                              Icons.fingerprint_rounded,
                                              color: Colors.white,
                                              size: 30,
                                            ).onTap(
                                              () {
                                                // controller.imageBukti?.delete();
                                                // controller.imageBukti
                                                //     ?.deleteSync();
                                                controller.boolImage(false);

                                                controller.getDetailActivity(
                                                    controller
                                                        .listActivityOpenProgress[
                                                            index]
                                                        .kunjunganId,
                                                    'MAPS');
                                                controller.action.value =
                                                    controller
                                                        .listActivityOpenProgress[
                                                            index]
                                                        .action
                                                        .toString();
                                              },
                                            ),
                                          ),
                                        )
                                      else if (controller.listTidakButuhLokasi
                                          .contains(controller
                                              .listActivityOpenProgress[index]
                                              .action
                                              .toString()))
                                        SizedBox(
                                          child: Card(
                                            color: Colors.blue,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: const Icon(
                                                Icons.camera_alt_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ).onTap(
                                                () {
                                                  // controller.imageBukti
                                                  //     ?.delete();
                                                  // controller.imageBukti
                                                  //     ?.deleteSync();
                                                  controller.boolImage(false);

                                                  controller.getDialogPostImage(
                                                      controller
                                                          .listActivityOpenProgress[
                                                              index]
                                                          .kunjunganId);
                                                  controller.action.value =
                                                      controller
                                                          .listActivityOpenProgress[
                                                              index]
                                                          .action
                                                          .toString();
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  5.height,
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const Icon(
                                  //       Icons.home_work,
                                  //       color: grey,
                                  //       size: 20,
                                  //     ),
                                  //     5.width,
                                  //     Expanded(
                                  //       child: Text(
                                  //         controller
                                  //                     .listActivityOpenProgress[
                                  //                         index]
                                  //                     .namaHotel ==
                                  //                 ''
                                  //             ? controller
                                  //                 .listActivityOpenProgress[
                                  //                     index]
                                  //                 .lokasi
                                  //             : controller
                                  //                 .listActivityOpenProgress[
                                  //                     index]
                                  //                 .namaHotel,
                                  //         style: Get.textTheme.bodySmall,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.share_location_outlined,
                                        color: grey,
                                        size: 20,
                                      ),
                                      5.width,
                                      Text(
                                        'Alamat : ',
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Text(
                                          controller
                                              .listActivityOpenProgress[index]
                                              .lokasi
                                              .toString(),
                                          style: Get.textTheme.bodySmall,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.note_alt_outlined,
                                        color: grey,
                                        size: 20,
                                      ),
                                      5.width,
                                      Text(
                                        'Deskripsi :',
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .listActivityOpenProgress[
                                                      index]
                                                  .notulen ??
                                              '-',
                                          style: Get.textTheme.bodySmall,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.watch_later_outlined,
                                        color: grey,
                                        size: 20,
                                      ),
                                      5.width,
                                      Text(
                                        'Checkin :',
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .listActivityOpenProgress[
                                                      index]
                                                  .waktuCheckin
                                                  .toString() ??
                                              '-',
                                          style: Get.textTheme.bodySmall,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.watch_later_outlined,
                                        color: grey,
                                        size: 20,
                                      ),
                                      5.width,
                                      Text(
                                        'Checkout :',
                                        style: Get.textTheme.bodySmall,
                                      ),
                                      10.width,
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .listActivityOpenProgress[
                                                      index]
                                                  .waktuCheckout
                                                  .toString() ??
                                              '-',
                                          style: Get.textTheme.bodySmall,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 5,
                                decoration: const BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return 15.height;
                },
              ),
            ),
    );
  }
}
