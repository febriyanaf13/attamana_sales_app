import 'package:attamana_salles_app/app/components/custom_dropdown.dart';
import 'package:attamana_salles_app/app/components/custom_lottie_not_found.dart';
import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../controllers/cuti_controller.dart';

class CutiView extends GetView<CutiController> {
  const CutiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Cuti'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.AJUKAN_CUTI);
          },
          child: const Icon(Icons.add)),
      body: Column(
        children: [
          // Image.asset('bg_cuti2'.jpg),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () {
                    return Future<void>.delayed(
                      const Duration(seconds: 3),
                      () {
                        controller.getAllPengajuanCuti();
                      },
                    );
                  },
                  child: controller.listAllCutiSaya.isEmpty
                      ? const CustomLottieNotFound()
                      : ListView.separated(
                          itemCount: controller.listAllCutiSaya.length,
                          padding: const EdgeInsets.all(20),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range,
                                      color: kPrimaryColor,
                                    ),
                                    Text(
                                      DateFormat("EEE, dd MMM yyyy", "id_ID")
                                          .format(controller
                                              .listAllCutiSaya[index]
                                              .startDate),
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Cuti ${controller.listAllCutiSaya[index].tipeCuti.namaTipe}',
                                              style: Get.textTheme.titleSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(controller
                                                    .listAllCutiSaya[index]
                                                    .status)),
                                          ],
                                        ),
                                        const Divider(),
                                        Text(
                                          controller
                                              .listAllCutiSaya[index].note,
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        5.height,
                                        SizedBox(
                                          height: 15,
                                          child: Row(
                                            children: [
                                              // const Icon(
                                              //   Icons.date_range_rounded,
                                              //   size: 15,
                                              //   color: Colors.grey,
                                              // ),
                                              // 2.width,
                                              // Text(
                                              //   '20 Feb 2023 - 21 Feb 2023',
                                              //   style: Get.textTheme.bodySmall
                                              //       ?.copyWith(
                                              //           color: Colors.grey,
                                              //           fontWeight: FontWeight.w600),
                                              // ),
                                              // const VerticalDivider(
                                              //   color: Colors.grey,
                                              //   thickness: 1,
                                              // ),
                                              const Icon(
                                                Icons.access_time,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              2.width,
                                              Text(
                                                '${controller.listAllCutiSaya[index].days} Days',
                                                style: Get.textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              const VerticalDivider(
                                                color: Colors.grey,
                                                thickness: 1,
                                              ),
                                              const Icon(
                                                Icons.photo,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              2.width,
                                              Text(
                                                '1 Bukti',
                                                style: Get.textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ).onTap(() {
                                                showDialog<Widget>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          Dialog(
                                                    alignment: Alignment.center,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration:
                                                          boxDecorationRoundedWithShadow(
                                                              12,
                                                              backgroundColor:
                                                                  context
                                                                      .cardColor),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Center(
                                                              child:
                                                                  Image.network(
                                                                '${controller.listAllCutiSaya[index].bukti}',
                                                                width:
                                                                    Get.width,
                                                                fit:
                                                                    BoxFit.fill,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    'bg_terlambat'
                                                                        .jpg,
                                                                    width: 100,
                                                                    height: 100,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return 20.height;
                          },
                        )))
        ],
      ),
    );
  }
}
