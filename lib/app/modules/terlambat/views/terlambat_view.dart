import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_datepicker_dialog.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_image_picker.dart';
import '../../../components/custom_text_field.dart';
import '../../../routes/app_pages.dart';
import '../../../style/colors.dart';
import '../../../style/paddings.dart';
import '../controllers/terlambat_controller.dart';

class TerlambatView extends GetView<TerlambatController> {
  const TerlambatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Terlambat Saya'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADD_TERLAMBAT);
              },
              icon: const Icon(Icons.add_box))
        ],
      ),
      body: Column(
        children: [
          Image.asset('bg_terlambat'.jpg),
          Expanded(
              child: ListView.separated(
            itemCount: controller.listTerlambatSaya.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return RefreshIndicator(
                onRefresh: () {
                  return Future<void>.delayed(
                    const Duration(seconds: 3),
                    () {
                      controller.getAllTerlambatSaya();
                    },
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: kPrimaryColor,
                        ),
                        Text(
                          DateFormat("EEE, dd MMM yyyy", "id_ID").format(
                              controller.listTerlambatSaya[index].startDate),
                          style: Get.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Note : ${controller.listTerlambatSaya[index].note}',
                                  style: Get.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(controller
                                        .listTerlambatSaya[index].status)),
                              ],
                            ),
                            const Divider(),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 15,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${controller.listTerlambatSaya[index].days} Days',
                                    style: Get.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
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
                                  SizedBox(
                                    width: 2,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog<Widget>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Dialog(
                                          alignment: Alignment.center,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.15),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Center(
                                                    child: Image.network(
                                                      controller
                                                          .listTerlambatSaya[
                                                              index]
                                                          .bukti,
                                                      width: Get.width,
                                                      fit: BoxFit.fill,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.asset(
                                                          'bg_terlambat'.jpg,
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.fill,
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
                                    },
                                    child: Text(
                                      'Bukti',
                                      style: Get.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20,
              );
            },
          ))
        ],
      ),
    );
  }
}
