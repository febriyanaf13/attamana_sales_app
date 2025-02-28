import 'package:attamana_salles_app/app/components/custom_text_field_title.dart';
import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:attamana_salles_app/app/style/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../utils/calendar.dart';
import '../controllers/agenda_controller.dart';

class AgendaView extends GetView<AgendaController> {
  const AgendaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGENDA'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.bottomSheet(Container(
                    width: Get.width,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tambah Agenda',
                                style: Get.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          10.height,
                          const Divider(),
                          10.height,
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  CustomTextFieldTitle(
                                    withTitle: false,
                                    title: 'Alamat',
                                    hint: 'Masukan Alamat',
                                    controller: TextEditingController(),
                                  ),
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.map_rounded,
                                        color: Colors.green,
                                      ),
                                      Text('Pilih lewat Peta'),
                                    ],
                                  ),
                                  20.height,
                                  CustomTextFieldTitle(
                                    withTitle: false,
                                    title: 'Notes',
                                    hint: 'Masukan Catatan',
                                    controller: TextEditingController(),
                                    maxLine: 4,
                                  ),
                                  20.height,
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPrimaryColor,
                                        // Background color
                                        shape: const StadiumBorder(),
                                        minimumSize: const Size.fromHeight(50),
                                      ),
                                      onPressed: () {},
                                      child: AutoSizeText(
                                        'Submit',
                                        style: Get.textTheme.bodyLarge
                                            ?.copyWith(color: kWhiteColor),
                                      )),
                                ],
                              ),
                            ),
                          )
                        ])));
              },
              icon: const Icon(Icons.add_box))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => TableCalendar<Event>(
              locale: 'id_ID',
              firstDay: DateTime(controller.tahunIni, 01, 01),
              lastDay: DateTime(controller.tahunIni, 12, 31),
              focusedDay: controller.focusedDay.value,
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDay.value, day),
              // rangeStartDay: controller.rangeStart,
              // rangeEndDay: controller.rangeEnd,
              calendarFormat: controller.calendarFormat,

              // rangeSelectionMode: controller.rangeSelectionMode,
              eventLoader: controller.getEventsForDay,

              onDaySelected: controller.onDaySelected,
              startingDayOfWeek: StartingDayOfWeek.monday,
              holidayPredicate: (day) => day.weekday > 6,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, datetime, events) {
                  return events.isNotEmpty
                      ? Container(
                          width: 20,
                          height: 15,
                          decoration: BoxDecoration(
                              color: kDarkGreyColor,
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Center(
                            child: Text(events.length.toString(),
                                style: Get.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white)),
                          ),
                        )
                      : Container();
                },
                singleMarkerBuilder: (context, date, _) {
                  return Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: date == controller.selectedDay
                            ? Colors.white
                            : Colors.black), //Change color
                    width: 5.0,
                    height: 5.0,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                holidayTextStyle: const TextStyle(color: kErrorColor),
                holidayDecoration: const BoxDecoration(shape: BoxShape.circle),
                // weekendTextStyle: const TextStyle(color: kErrorColor),
                selectedDecoration: const BoxDecoration(
                    color: kPrimaryColor, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(
                    color: kAccentColor.withOpacity(0.5),
                    shape: BoxShape.circle),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              // onRangeSelected: controller.onRangeSelected,
              // onFormatChanged: (format) {
              //   if (controller.calendarFormat != format) {
              //     // setState(() {
              //
              //       controller.calendarFormat = format;
              //     // });
              //   }
              // },
              // onPageChanged: (focusedDay) {
              //   controller.focusedDay.value = focusedDay;
              // },
            ),
          ),
          const Divider(),

          // Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: Text(
          //     'Todo List',
          //     style: Get.textTheme.titleSmall,
          //   ),
          // ),

          // 20.height,
          Expanded(
              child: ValueListenableBuilder<List<Event>>(
                  valueListenable: controller.selectedEvents,
                  builder: (context, value, _) {
                    return Obx(
                      () => Column(
                        children: [
                          FloatingNavbar(
                            onTap: (int val) {
                              controller.currentIndex.value = val;
                            },
                            itemBorderRadius: 30,
                            borderRadius: 30,
                            backgroundColor: lightGray,
                            selectedItemColor: black,
                            unselectedItemColor: black,
                            selectedBackgroundColor: white,
                            currentIndex: controller.currentIndex.value,
                            items: [
                              FloatingNavbarItem(
                                  customWidget: Text(
                                    '${value.length}',
                                    style: Get.textTheme.titleLarge,
                                  ),
                                  title: 'Archivement'),
                              FloatingNavbarItem(
                                  customWidget: Text(
                                    '0',
                                    style: Get.textTheme.titleLarge,
                                  ),
                                  title: 'Last Visit'),
                              FloatingNavbarItem(
                                  customWidget: Text(
                                    '0',
                                    style: Get.textTheme.titleLarge,
                                  ),
                                  title: 'Deal'),
                            ],
                          ),
                          controller.currentIndex.value == 0
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: value.length,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.home,
                                                          color: kPrimaryColor,
                                                        ),
                                                        5.width,
                                                        Text(
                                                          'Hotel Louise Kiene',
                                                          style: Get.textTheme
                                                              .titleLarge,
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.location_on,
                                                          color: Colors.green,
                                                        ),
                                                        5.width,
                                                        Text(
                                                          'Jalan Pemuda, Semarang',
                                                          style: Get.textTheme
                                                              .bodySmall,
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.event_note,
                                                          color: Colors.blue,
                                                        ),
                                                        5.width,
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Notes :',
                                                              style: Get
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                            Text(
                                                              'Melakukan kunjungan ke client',
                                                              style: Get
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                          fixedSize: const Size
                                                              .fromWidth(
                                                              80) // Background color
                                                          ),
                                                      onPressed: () {
                                                        Get.toNamed(
                                                            Routes.HOME);
                                                      },
                                                      child: AutoSizeText(
                                                        'Cek In',
                                                        style: Get
                                                            .textTheme.bodySmall
                                                            ?.copyWith(
                                                                color:
                                                                    kWhiteColor),
                                                      )),
                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          fixedSize: const Size
                                                              .fromWidth(
                                                              80) // Background color
                                                          ),
                                                      onPressed: () {},
                                                      child: AutoSizeText(
                                                        'Cek Out',
                                                        style: Get
                                                            .textTheme.bodySmall
                                                            ?.copyWith(
                                                                color:
                                                                    kWhiteColor),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const Text('Data Kosong')
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
