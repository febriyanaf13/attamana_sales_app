import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../utils/calendar.dart';

class AgendaController extends GetxController {
  //TODO: Implement AgendaController
  var currentIndex = 1.obs;

  late final ValueNotifier<List<Event>> selectedEvents;
  CalendarFormat calendarFormat = CalendarFormat.week;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  int bulanIni = DateTime.now().month;
  int tahunIni = DateTime.now().year;
  // DateTime? rangeStart;
  // DateTime? rangeEnd;

  @override
  void onInit() {
    super.onInit();
    selectedDay = focusedDay;
    selectedEvents = ValueNotifier(getEventsForDay(selectedDay.value));
  }


  @override
  void onClose() {
    super.onClose();
    selectedEvents.dispose();
  }

  List<Event> getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }


  // void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  //   if (!isSameDay(selectedDay, selectedDay)) {
  //     // setState(() {
  //       selectedDay = selectedDay;
  //       focusedDay = focusedDay;
  //       rangeStart = null; // Important to clean those
  //       rangeEnd = null;
  //       rangeSelectionMode = RangeSelectionMode.toggledOff;
  //     // });
  //
  //     selectedEvents.value = getEventsForDay(selectedDay);
  //   }
  // }
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setFocusedDay(selectedDay);
    selectedEvents.value = getEventsForDay(selectedDay);


  }
  void setFocusedDay(DateTime day) {
   focusedDay(day);
  }


  // void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
  //   // setState(() {
  //   selectedDay = null;
  //   focusedDay = focusedDay;
  //   rangeStart = start;
  //   rangeEnd = end;
  //   rangeSelectionMode = RangeSelectionMode.toggledOn;
  //   // });
  //
  //   // `start` or `end` could be null
  //   if (start != null && end != null) {
  //     selectedEvents.value = getEventsForRange(start, end);
  //   } else if (start != null) {
  //     selectedEvents.value = getEventsForDay(start);
  //   } else if (end != null) {
  //     selectedEvents.value = getEventsForDay(end);
  //   }
  // }
}
