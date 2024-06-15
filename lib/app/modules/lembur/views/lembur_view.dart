import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../controllers/lembur_controller.dart';

class LemburView extends GetView<LemburController> {
  LemburView({Key? key}) : super(key: key);
  Duration myDuration = const Duration(hours: 24);

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lembur'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future<void>.delayed(
              const Duration(seconds: 3),
              () {
                controller.getRiwayatLembur();
              },
            );
          },
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('bg_lembur'.jpg),
                            fit: BoxFit.cover)),
                  )),
              Expanded(
                  child: Obx(() => ListView.separated(
                        separatorBuilder: (context, index) => 20.height,
                        itemCount: controller.listRiwayatLembur.length,
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
                                            .listRiwayatLembur[index].tanggal),
                                    style: Get.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
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
                                      Text(
                                        'Note : ${controller.listRiwayatLembur[index].keterangan}',
                                        style: Get.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(),
                                      5.height,
                                      SizedBox(
                                        height: 15,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.timer_rounded,
                                              size: 15,
                                              color: Colors.green,
                                            ),
                                            2.width,
                                            Text(
                                              controller
                                                  .listRiwayatLembur[index]
                                                  .jamMulai,
                                              style: Get.textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            20.width,
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 15,
                                            ),
                                            20.width,
                                            const Icon(
                                              Icons.timer_rounded,
                                              size: 15,
                                              color: Colors.red,
                                            ),
                                            2.width,
                                            Text(
                                              controller
                                                  .listRiwayatLembur[index]
                                                  .jamSelesai,
                                              style: Get.textTheme.bodySmall
                                                  ?.copyWith(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
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
                      ))
                  // Expanded(
                  //     flex: 2,
                  //     child: Column(
                  //       children: [
                  //     // Row(
                  //     //   children: [
                  //     //     Expanded(
                  //     //         child: Card(
                  //     //             elevation: 2,
                  //     //             color: greenColor,
                  //     //             shape: RoundedRectangleBorder(
                  //     //                 borderRadius: BorderRadius.circular(20)),
                  //     //             child: Padding(
                  //     //               padding: const EdgeInsets.all(10),
                  //     //               child: Column(
                  //     //                 children: [
                  //     //                   const Icon(
                  //     //                     Icons.timer_rounded,
                  //     //                     color: white,
                  //     //                     size: 50,
                  //     //                   ),
                  //     //                   10.height,
                  //     //                   Text(
                  //     //                     'Check-In',
                  //     //                     style: Get.textTheme.titleSmall
                  //     //                         ?.copyWith(color: white),
                  //     //                   ),
                  //     //                   Text(
                  //     //                     '--:--',
                  //     //                     style: Get.textTheme.titleLarge
                  //     //                         ?.copyWith(color: white),
                  //     //                   ),
                  //     //                 ],
                  //     //               ),
                  //     //             ))),
                  //     //     10.width,
                  //     //     Expanded(
                  //     //       child: Padding(
                  //     //         padding: const EdgeInsets.all(8.0),
                  //     //         child: StreamBuilder(
                  //     //             stream:
                  //     //                 Stream.periodic(const Duration(seconds: 1)),
                  //     //             builder: (context, snapshot) {
                  //     //               return Center(
                  //     //                 child: Column(
                  //     //                   children: [
                  //     //                     AutoSizeText(
                  //     //                       DateFormat(
                  //     //                               "EEE, dd MMM yyyy", "id_ID")
                  //     //                           .format(DateTime.now()),
                  //     //                       style: Theme.of(context)
                  //     //                           .textTheme
                  //     //                           .bodyMedium
                  //     //                           ?.copyWith(
                  //     //                               fontWeight: FontWeight.bold),
                  //     //                       maxLines: 1,
                  //     //                     ),
                  //     //                     Text(
                  //     //                       DateFormat('HH:mm')
                  //     //                           .format(DateTime.now()),
                  //     //                       style: Theme.of(context)
                  //     //                           .textTheme
                  //     //                           .headlineSmall
                  //     //                           ?.copyWith(
                  //     //                               letterSpacing: 5,
                  //     //                               fontWeight: FontWeight.bold),
                  //     //                     ),
                  //     //                     10.height,
                  //     //                     ElevatedButton(
                  //     //                         onPressed: () async {
                  //     //                           TimeRange? result =
                  //     //                               await showCupertinoDialog(
                  //     //                             barrierDismissible: true,
                  //     //                             context: context,
                  //     //                             builder:
                  //     //                                 (BuildContext context) {
                  //     //                               TimeOfDay startTime =
                  //     //                                   TimeOfDay.now();
                  //     //                               TimeOfDay endTime =
                  //     //                                   TimeOfDay.now();
                  //     //                               return CupertinoAlertDialog(
                  //     //                                 content: SizedBox(
                  //     //                                     width: MediaQuery.of(
                  //     //                                             context)
                  //     //                                         .size
                  //     //                                         .width,
                  //     //                                     height: 340,
                  //     //                                     child: Column(
                  //     //                                       children: [
                  //     //                                         TimeRangePicker(
                  //     //                                           padding: 22,
                  //     //                                           hideButtons: true,
                  //     //                                           handlerRadius: 8,
                  //     //                                           strokeWidth: 4,
                  //     //                                           ticks: 12,
                  //     //                                           disabledTime:
                  //     //                                               TimeRange(
                  //     //                                             startTime:
                  //     //                                                 const TimeOfDay(
                  //     //                                                     hour: 8,
                  //     //                                                     minute:
                  //     //                                                         15),
                  //     //                                             endTime:
                  //     //                                                 const TimeOfDay(
                  //     //                                                     hour:
                  //     //                                                         16,
                  //     //                                                     minute:
                  //     //                                                         0),
                  //     //                                           ),
                  //     //                                           maxDuration:
                  //     //                                               const Duration(
                  //     //                                                   hours: 6),
                  //     //                                           activeTimeTextStyle:
                  //     //                                               const TextStyle(
                  //     //                                                   fontWeight:
                  //     //                                                       FontWeight
                  //     //                                                           .normal,
                  //     //                                                   fontSize:
                  //     //                                                       22,
                  //     //                                                   color: Colors
                  //     //                                                       .white),
                  //     //                                           timeTextStyle: const TextStyle(
                  //     //                                               fontWeight:
                  //     //                                                   FontWeight
                  //     //                                                       .normal,
                  //     //                                               fontSize: 22,
                  //     //                                               color: Colors
                  //     //                                                   .white70),
                  //     //                                           onStartChange:
                  //     //                                               (start) {
                  //     //                                             // setState(() {
                  //     //                                             startTime =
                  //     //                                                 start;
                  //     //                                             // });
                  //     //                                           },
                  //     //                                           onEndChange:
                  //     //                                               (end) {
                  //     //                                             // setState(() {
                  //     //                                             endTime = end;
                  //     //                                             // });
                  //     //                                           },
                  //     //                                         ),
                  //     //                                       ],
                  //     //                                     )),
                  //     //                                 actions: <Widget>[
                  //     //                                   CupertinoDialogAction(
                  //     //                                       isDestructiveAction:
                  //     //                                           true,
                  //     //                                       child: const Text(
                  //     //                                           'Cancel'),
                  //     //                                       onPressed: () {
                  //     //                                         Navigator.of(
                  //     //                                                 context)
                  //     //                                             .pop();
                  //     //                                       }),
                  //     //                                   CupertinoDialogAction(
                  //     //                                     child: const Text('Ok'),
                  //     //                                     onPressed: () {
                  //     //                                       Navigator.of(context)
                  //     //                                           .pop(
                  //     //                                         TimeRange(
                  //     //                                             startTime:
                  //     //                                                 startTime,
                  //     //                                             endTime:
                  //     //                                                 endTime),
                  //     //                                       );
                  //     //                                     },
                  //     //                                   ),
                  //     //                                 ],
                  //     //                               );
                  //     //                             },
                  //     //                           );
                  //     //                           if (kDebugMode) {
                  //     //                             print(result.toString());
                  //     //                           }
                  //     //                         },
                  //     //                         child: const Text("Atur Lembur")),
                  //     //                   ],
                  //     //                 ),
                  //     //               );
                  //     //             }),
                  //     //       ),
                  //     //     ),
                  //     //     10.width,
                  //     //     Expanded(
                  //     //         child: Card(
                  //     //             elevation: 2,
                  //     //             color: errorColor,
                  //     //             shape: RoundedRectangleBorder(
                  //     //                 borderRadius: BorderRadius.circular(20)),
                  //     //             child: Padding(
                  //     //               padding: const EdgeInsets.all(10),
                  //     //               child: Column(
                  //     //                 children: [
                  //     //                   const Icon(
                  //     //                     Icons.timer_rounded,
                  //     //                     color: white,
                  //     //                     size: 50,
                  //     //                   ),
                  //     //                   10.height,
                  //     //                   Text(
                  //     //                     'Check-Out',
                  //     //                     style: Get.textTheme.titleSmall
                  //     //                         ?.copyWith(color: white),
                  //     //                   ),
                  //     //                   Text(
                  //     //                     '--:--',
                  //     //                     style: Get.textTheme.titleLarge
                  //     //                         ?.copyWith(color: white),
                  //     //                   ),
                  //     //                 ],
                  //     //               ),
                  //     //             ))),
                  //     //   ],
                  //     // ),
                  //     // 20.height,
                  //     // Text(
                  //     //   'Lembur Selesai :',
                  //     //   style: Get.textTheme.titleLarge,
                  //     // ),
                  //     // 20.height,
                  //     // Text(
                  //     //   '$hours:$minutes:$seconds',
                  //     //   style: Get.textTheme.headlineLarge
                  //     //       ?.copyWith(color: kErrorColor),
                  //     // ),
                  //     // 20.height,
                  //     // Text(
                  //     //   'Status Lembur : Berjalan',
                  //     //   style: Get.textTheme.titleLarge,
                  //     // ),
                  //   ],
                  // )),
                  )
            ],
          ),
        ));
  }
}
