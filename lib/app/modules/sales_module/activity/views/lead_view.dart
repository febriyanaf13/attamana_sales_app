import 'package:attamana_salles_app/app/components/custom_lottie.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/custom_lottie_not_found.dart';
import '../../../../style/colors.dart';
import '../controllers/activity_controller.dart';
import '../models/lead.dart';

class LeadView extends GetView<ActivityController> {
  const LeadView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lead'),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return Future<void>.delayed(
                const Duration(seconds: 3),
                () {
                  // controller.getKendaraan();
                },
              );
            },
            child: DefaultTabController(
                length: 4,
                initialIndex: 0,
                child: Column(children: [
                  PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: TabBar(
                          dividerHeight: 0,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabAlignment: TabAlignment.fill,
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
                              label:
                                  Text(controller.listMyLead.length.toString()),
                              isLabelVisible:
                                  controller.listMyLead.isEmpty ? false : true,
                              offset: const Offset(20, 15),
                              child: const Tab(
                                text: 'Lead',
                              ),
                            ),
                            Badge(
                              label: Text(controller.listOpportunities.length
                                  .toString()),
                              isLabelVisible:
                                  controller.listOpportunities.isEmpty
                                      ? false
                                      : true,
                              offset: const Offset(20, 15),
                              child: const Tab(
                                child: Text(
                                  'Opportunities',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Badge(
                              label:
                                  Text(controller.listDone.length.toString()),
                              isLabelVisible:
                                  controller.listDone.isEmpty ? false : true,
                              offset: const Offset(20, 15),
                              child: const Tab(
                                text: 'Done',
                              ),
                            ),
                            Badge(
                              label:
                                  Text(controller.listJunk.length.toString()),
                              isLabelVisible:
                                  controller.listJunk.isEmpty ? false : true,
                              offset: const Offset(20, 15),
                              child: const Tab(
                                text: 'Junk',
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      CustomListLead(
                        listData: controller.listMyLead,
                      ),
                      CustomListLead(
                        listData: controller.listOpportunities,
                      ),
                      CustomListLead(
                        listData: controller.listDone,
                      ),
                      CustomListLead(
                        listData: controller.listJunk,
                      ),
                    ]),
                  ),
                ]))));
    // Obx(
    //         () =>
    // ),
  }
}

class CustomListLead extends StatelessWidget {
  const CustomListLead({
    super.key,
    required this.listData,
  });

  final List<Lead> listData;

  @override
  Widget build(BuildContext context) {
    return Obx(() => listData.isEmpty
        ? const CustomLottieNotFound()
        : ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 20,
            ),
            itemCount: listData.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'kode : ${listData[index].kode}',
                        style: Get.textTheme.bodyMedium?.copyWith(
                            color: kPrimaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.hotel_rounded),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      listData[index].namaHotel.toString(),
                                      style: Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.account_balance_rounded),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      listData[index].companyName.toString(),
                                      style: Get.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  RatingBar.builder(
                                    initialRating: listData[index]
                                        .categoryHotel
                                        .ceilToDouble(),
                                    minRating: 0,
                                    itemSize: 20,
                                    itemCount: 5,
                                    ignoreGestures: true,
                                    direction: Axis.horizontal,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Job Position :',
                                style: Get.textTheme.bodySmall?.copyWith(),
                              ),
                              Expanded(
                                child: Text(
                                  listData[index].jobPosition.toString(),
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Alamat Penagihan :',
                                style: Get.textTheme.bodySmall?.copyWith(),
                              ),
                              Expanded(
                                child: Text(
                                  listData[index].addressPenagihan.toString(),
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Kota :',
                                style: Get.textTheme.bodySmall?.copyWith(),
                              ),
                              Expanded(
                                child: Text(
                                  '${listData[index].city}, ${listData[index].state}',
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Jenis barang :',
                                style: Get.textTheme.bodySmall?.copyWith(),
                              ),
                              Expanded(
                                child: Text(
                                  listData[index].jenisBarang.toString(),
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Last Activity :',
                                style: Get.textTheme.bodySmall?.copyWith(),
                              ),
                              Expanded(
                                child: Text(
                                  listData[index].lastActivity.toString(),
                                  style: Get.textTheme.bodySmall?.copyWith(),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ));
  }
}
