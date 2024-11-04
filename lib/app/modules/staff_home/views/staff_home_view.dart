import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
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
              SizedBox(
                height: Get.width * 0.6,
                child: Stack(
                  children: [
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
                                  repeat: ImageRepeat.repeat)),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  kPrimaryColor,
                                  kPrimaryColor.withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: Container(
                              width: Get.width,
                              padding: const EdgeInsets.all(20),
                              color: transparentColor,
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
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Hi, ${controller.nama}',
                                                  style: Get
                                                      .textTheme.titleSmall
                                                      ?.copyWith(
                                                          color: kWhiteColor,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                                10.width,
                                                Obx(
                                                  () => internetConnectionChecker
                                                          .isConnectedToInternet
                                                          .isTrue
                                                      ? const Icon(
                                                          Icons
                                                              .radio_button_checked_rounded,
                                                          color: Colors.green,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .radio_button_checked_rounded,
                                                          color: Colors.red,
                                                        ),
                                                )
                                              ],
                                            ),
                                            5.height,
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: kWhiteColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text('${controller.roles}',
                                                  style: Get.textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: kWhiteColor,
                                                          fontWeight:
                                                              FontWeight.w300)),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              color: white,
                                              shape: BoxShape.circle),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                              controller.foto ?? '',
                                              fit: BoxFit.fill,
                                              width: 40,
                                              height: 40,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Image.asset(
                                                'user_profile'.png,
                                                fit: BoxFit.fill,
                                                width: 40,
                                                height: 40,
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
                        )),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      right: 10,
                      child: SizedBox(
                        width: Get.width,
                        height: 100,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                              elevation: 2,
                                              color: greenColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Obx(
                                                    () => Column(
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            'Check-In',
                                                            style: Get.textTheme
                                                                .titleSmall
                                                                ?.copyWith(
                                                                    color:
                                                                        white),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            controller.waktuIn
                                                                            .value ==
                                                                        'null' ||
                                                                    controller
                                                                            .waktuIn
                                                                            .value ==
                                                                        ''
                                                                ? '--:--'
                                                                : controller
                                                                    .waktuIn
                                                                    .value,
                                                            style: Get.textTheme
                                                                .titleLarge
                                                                ?.copyWith(
                                                                    color:
                                                                        white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))),
                                        ),
                                        10.width,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: StreamBuilder(
                                                stream: Stream.periodic(
                                                    const Duration(seconds: 1)),
                                                builder: (context, snapshot) {
                                                  controller
                                                      .checkPresensiHariIni();
                                                  return SizedBox(
                                                    height: 50,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        AutoSizeText(
                                                          DateFormat(
                                                                  "EEE, dd MMM yyyy",
                                                                  "id_ID")
                                                              .format(DateTime
                                                                  .now()),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                        ),
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            DateFormat('HH:mm')
                                                                .format(DateTime
                                                                    .now()),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineSmall
                                                                ?.copyWith(
                                                                    letterSpacing:
                                                                        5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                        // 10.width,
                                        // Expanded(
                                        //     child: Card(
                                        //         elevation: 2,
                                        //         color: kPrimaryColor,
                                        //         shape: RoundedRectangleBorder(
                                        //           borderRadius: BorderRadius.circular(140),
                                        //         ),
                                        //         child: const Padding(
                                        //           padding: EdgeInsets.all(8.0),
                                        //           child: AnalogClock(),
                                        //         ))),
                                        10.width,
                                        Expanded(
                                            child: Card(
                                                elevation: 2,
                                                color: errorColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Obx(
                                                    () => Column(
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            'Check-Out',
                                                            style: Get.textTheme
                                                                .titleSmall
                                                                ?.copyWith(
                                                                    color:
                                                                        white),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            controller.waktuOut
                                                                            .value ==
                                                                        'null' ||
                                                                    controller
                                                                            .waktuOut
                                                                            .value ==
                                                                        ''
                                                                ? '--:--'
                                                                : controller
                                                                    .waktuOut
                                                                    .value,
                                                            style: Get.textTheme
                                                                .titleLarge
                                                                ?.copyWith(
                                                                    color:
                                                                        white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))),
                                      ],
                                    ),
                                  ),
                                  Obx(() =>
                                      controller.checkPresensiHariIni.value ==
                                                  '' ||
                                              controller.checkPresensiHariIni
                                                      .value !=
                                                  'null'
                                          ? const Column(
                                              children: [
                                                // 5.height,
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.center,
                                                //   children: [
                                                //     const Icon(
                                                //       Icons.error,
                                                //       color: redColor,
                                                //       size: 15,
                                                //     ),
                                                //     AutoSizeText(
                                                //       controller
                                                //           .checkPresensiHariIni.value,
                                                //       style: Theme.of(context)
                                                //           .textTheme
                                                //           .bodySmall
                                                //           ?.copyWith(
                                                //               color: redColor,
                                                //               fontSize: 5),
                                                //       textAlign: TextAlign.center,
                                                //       maxLines: 1,
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            )
                                          : const SizedBox()),
                                ],
                              ),
                            )),
                      ),
                    ),
                    // Obx(
                    //   () => Positioned(
                    //     top: 45,
                    //     right: 32,
                    //     child: internetConnectionChecker
                    //             .isConnectedToInternet.isTrue
                    //         ? const Icon(
                    //             Icons.radio_button_checked_rounded,
                    //             color: Colors.green,
                    //           )
                    //         : const Icon(
                    //             Icons.radio_button_checked_rounded,
                    //             color: Colors.red,
                    //           ),
                    //   ),
                    // )
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                primary: true,
                child: Column(
                  children: [
                    controller.roles == 'SALES' ||
                            controller.roles == 'SALES MANAGER'
                        ? salesMenu()
                        : staffMenu(),
                    const Divider(
                      thickness: 1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Announcement',
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: Obx(
                              () => ListView.separated(
                                  itemCount:
                                      controller.listAnnounchement.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        leading: Image.asset(
                                          'announcement'.png,
                                          width: 40,
                                          height: 40,
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller
                                                  .listAnnounchement[index]
                                                  .nama,
                                              style: Get.textTheme.bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text(
                                              controller
                                                  .listAnnounchement[index]
                                                  .keterangan,
                                              style: Get.textTheme.bodySmall,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  DateFormat.yMMMd()
                                                      .format(controller
                                                          .listAnnounchement[
                                                              index]
                                                          .tanggalMulai)
                                                      .toString(),
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                                10.width,
                                                const Icon(
                                                  Icons.arrow_forward_rounded,
                                                  size: 15,
                                                ),
                                                10.width,
                                                Text(
                                                  DateFormat.yMMMd()
                                                      .format(controller
                                                          .listAnnounchement[
                                                              index]
                                                          .tanggalSelesai)
                                                      .toString(),
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider();
                                  }),
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '',
                          style: Get.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  GridView staffMenu() {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          childAspectRatio: 4 / 4,
          mainAxisExtent: Get.width / 6),
      children: [
        CustomMenuHome(
            title: 'Reports',
            icon: 'absen'.png,
            onTap: () {
              Get.toNamed(Routes.GRAFIK);
            }),
        CustomMenuHome(
            title: 'Cuti',
            icon: 'cuti'.png,
            onTap: () {
              Get.toNamed(Routes.CUTI);
            }),
        CustomMenuHome(
            title: 'Terlambat',
            icon: 'terlambat'.png,
            onTap: () {
              Get.toNamed(Routes.TERLAMBAT);
            }),
        CustomMenuHome(
            title: 'Lembur',
            icon: 'lembur'.png,
            onTap: () {
              Get.toNamed(Routes.LEMBUR);
            }),
        CustomMenuHome(
            title: 'Reimburse',
            icon: 'reimbursement'.png,
            onTap: () {
              Get.toNamed(Routes.REIMBURSE);
            }),
        CustomMenuHome(
            title: 'Slip Gaji',
            icon: 'slip_gaji'.png,
            onTap: () {
              Get.toNamed(Routes.SLIP_GAJI);
            }),
        CustomMenuHome(
            title: 'Kasbon',
            icon: 'kasbon'.png,
            onTap: () {
              Get.toNamed(Routes.KASBON);
            }),
        CustomMenuHome(
            title: 'More',
            icon: 'more'.png,
            onTap: () {
              showMoreMenu();
            }),
      ],
    );
  }

  GridView salesMenu() {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          childAspectRatio: 4 / 4,
          mainAxisExtent: Get.width / 6 + 20),
      children: [
        CustomMenuHome(
            title: 'Customers',
            icon: 'customer'.png,
            onTap: () {
              Get.toNamed(Routes.CUSTOMER);
            }),
        CustomMenuHome(
            title: 'Activity',
            icon: 'find_job'.png,
            onTap: () {
              Get.toNamed(Routes.ACTIVITY);
            }),
        CustomMenuHome(
            title: 'Lead',
            icon: 'lead'.png,
            onTap: () {
              Get.toNamed(Routes.LEAD);
            }),
        CustomMenuHome(
            title: 'Sales Order',
            icon: 'so_monitoring'.png,
            onTap: () {
              Get.toNamed(Routes.SO_MONITORING);
            }),
        CustomMenuHome(
            title: 'Inventory',
            icon: 'inventory'.png,
            onTap: () {
              Get.toNamed(Routes.INVENTORY);
            }),
        CustomMenuHome(
            title: 'Report Visit',
            icon: 'report_visit'.png,
            onTap: () {
              Get.toNamed(Routes.REPORT_VISIT);
            }),
        CustomMenuHome(
            title: 'Sample & Pricing',
            icon: 'sample'.png,
            onTap: () {
              Get.toNamed(Routes.SAMPLE_AND_PRICING);
            }),
        controller.roles == 'SALES MANAGER' || controller.roles == 'DIREKTUR'
            ? CustomMenuHome(
                title: 'Assign Sales',
                icon: 'assign_sales'.png,
                onTap: () {
                  Get.toNamed(Routes.ASSIGN_SALES);
                })
            : const SizedBox(),

        // CustomMenuHome(
        //     title: 'Sample & Pricing',
        //     icon: 'inventory'.png,
        //     onTap: () {
        //       Get.toNamed(Routes.INVENTORY);
        //     }),
        // CustomMenuHome(
        //     title: 'Slip Gaji',
        //     icon: 'slip_gaji'.png,
        //     onTap: () {
        //       Get.toNamed(Routes.SLIP_GAJI);
        //     }),
        // CustomMenuHome(
        //     title: 'More',
        //     icon: 'more'.png,
        //     onTap: () {
        //       showMoreMenu();
        //     }),
      ],
    );
  }

  void showMoreMenu() {
    Get.bottomSheet(SizedBox(
      width: Get.width,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: controller.roles == 'SALES' ||
                  controller.roles == 'SALES MANAGER'
              ? Column(
                  children: [
                    Text(
                      'More Menu',
                      style: Get.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    30.height,
                    GridView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          childAspectRatio: 4 / 4,
                          mainAxisExtent: Get.width / 6),
                      children: [
                        CustomMenuHome(
                            title: 'Customers',
                            icon: 'customer'.png,
                            onTap: () {
                              Get.toNamed(Routes.CUSTOMER);
                            }),
                        CustomMenuHome(
                            title: 'Activity',
                            icon: 'find_job'.png,
                            onTap: () {
                              Get.toNamed(Routes.ACTIVITY);
                            }),
                        CustomMenuHome(
                            title: 'Report Visit',
                            icon: 'report_visit'.png,
                            onTap: () {
                              Get.toNamed(Routes.REPORT_VISIT);
                            }),
                        CustomMenuHome(
                            title: 'Sales Order',
                            icon: 'so_monitoring'.png,
                            onTap: () {
                              Get.toNamed(Routes.SO_MONITORING);
                            }),
                        CustomMenuHome(
                            title: 'Inventory',
                            icon: 'inventory'.png,
                            onTap: () {
                              Get.toNamed(Routes.INVENTORY);
                            }),
                        CustomMenuHome(
                            title: 'Lead',
                            icon: 'lead'.png,
                            onTap: () {
                              Get.toNamed(Routes.LEAD);
                            }),
                        CustomMenuHome(
                            title: 'Cuti',
                            icon: 'cuti'.png,
                            onTap: () {
                              Get.toNamed(Routes.CUTI);
                            }),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text(
                      'More Menu',
                      style: Get.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    20.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //Main Menu
                        Text(
                          'Main Menu',
                          style: Get.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        10.height,

                        GridView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 4 / 4,
                                  mainAxisExtent: Get.width / 6),
                          children: [
                            CustomMenuHome(
                                title: 'Reports',
                                icon: 'absen'.png,
                                onTap: () {
                                  Get.toNamed(Routes.GRAFIK);
                                }),
                            CustomMenuHome(
                                title: 'Cuti',
                                icon: 'cuti'.png,
                                onTap: () {
                                  Get.toNamed(Routes.CUTI);
                                }),
                            CustomMenuHome(
                                title: 'Terlambat',
                                icon: 'terlambat'.png,
                                onTap: () {
                                  Get.toNamed(Routes.TERLAMBAT);
                                }),
                            CustomMenuHome(
                                title: 'Lembur',
                                icon: 'lembur'.png,
                                onTap: () {
                                  Get.toNamed(Routes.LEMBUR);
                                }),
                            CustomMenuHome(
                                title: 'Reimburse',
                                icon: 'reimbursement'.png,
                                onTap: () {
                                  Get.toNamed(Routes.REIMBURSE);
                                }),
                            CustomMenuHome(
                                title: 'Slip Gaji',
                                icon: 'slip_gaji'.png,
                                onTap: () {
                                  Get.toNamed(Routes.SLIP_GAJI);
                                }),
                            CustomMenuHome(
                                title: 'Kasbon',
                                icon: 'kasbon'.png,
                                onTap: () {
                                  Get.toNamed(Routes.KASBON);
                                }),
                            CustomMenuHome(
                                title: 'Kendaraan',
                                icon: 'car'.png,
                                onTap: () {
                                  Get.toNamed(Routes.KENDARAAN);
                                }),
                            CustomMenuHome(
                                title: 'Bensin',
                                icon: 'bensin'.png,
                                onTap: () {
                                  Get.toNamed(Routes.BENSIN);
                                }),
                            CustomMenuHome(
                                title: 'Maintenance',
                                icon: 'maintenance'.png,
                                onTap: () {
                                  Get.toNamed(Routes.MAINTENANCE);
                                }),
                            CustomMenuHome(
                                title: 'Fixedasset',
                                icon: 'fixedasset'.png,
                                onTap: () {
                                  Get.toNamed(Routes.FIXEDASSET);
                                }),
                          ],
                        ),
                      ],
                    ),
                    30.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sales Menu',
                          style: Get.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        10.height,
                        GridView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 4 / 4,
                                  mainAxisExtent: Get.width / 6),
                          children: [
                            CustomMenuHome(
                                title: 'Activity',
                                icon: 'find_job'.png,
                                onTap: () {
                                  Get.toNamed(Routes.ACTIVITY);
                                }),
                            CustomMenuHome(
                                title: 'Report Visit',
                                icon: 'report_visit'.png,
                                onTap: () {
                                  Get.toNamed(Routes.CUTI);
                                }),
                            CustomMenuHome(
                                title: 'Sales Order',
                                icon: 'so_monitoring'.png,
                                onTap: () {
                                  Get.toNamed(Routes.SO_MONITORING);
                                }),
                            CustomMenuHome(
                                title: 'Inventory',
                                icon: 'inventory'.png,
                                onTap: () {
                                  Get.toNamed(Routes.INVENTORY);
                                }),
                            CustomMenuHome(
                                title: 'Lead',
                                icon: 'lead'.png,
                                onTap: () {
                                  Get.toNamed(Routes.LEAD);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      )),
    ));
  }
}

class CustomMenuHome extends StatelessWidget {
  const CustomMenuHome({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            icon,
            width: 40,
            height: 40,
          ),
          10.height,
          AutoSizeText(
            title,
            style: Get.textTheme.bodySmall,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ).onTap(onTap),
    );
  }
}
