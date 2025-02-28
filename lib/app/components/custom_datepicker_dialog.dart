import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style/colors.dart';

class CustomDateTimePickerDialog extends StatefulWidget {
  final String title;
  final String? firstDate;
  final String? lastDate;
  final String? setDateValue;
  final bool enabled;
  final bool isRequired;
  final Function(String?)? onDataChange;
  final String? Function(String?)? validator;

  const CustomDateTimePickerDialog({
    Key? key,
    this.onDataChange,
    this.enabled = true,
    this.validator,
    required this.title,
    required this.isRequired,
    this.firstDate,
    this.lastDate,
    this.setDateValue,
  }) : super(key: key);

  @override
  State<CustomDateTimePickerDialog> createState() =>
      _CustomDateTimePickerDialogState();
}

class _CustomDateTimePickerDialogState
    extends State<CustomDateTimePickerDialog> {
  var selectedDate;
  var valueDate;
  var textDate =
      '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year.toString().padLeft(2, '0')}';

  _selectDate(BuildContext context) async {
    selectedDate = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate:
          // widget.firstDate == null
          //     ?
          DateTime.parse('1000-01-01'),
      // DateTime.parse('${DateTime.now().year.toString()}-01-01'),
      // :
      // DateTime.parse(widget.firstDate!),
      lastDate: widget.lastDate == null
          ? DateTime.parse('${DateTime.now().year.toInt() + 1}-12-31')
          : DateTime.parse('${widget.firstDate}'),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Center(
            child: SizedBox(
          width: 500,
          height: Get.height / 2,
          child: child,
        ));
      },
    );

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        valueDate =
            '${selectedDate.year.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
        textDate =
            '${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}';
      });
    }
    // print(DateTime.parse(
    //     '${DateTime.now().year.toString().padLeft(2, '0')}-${DateTime.december.toString().padLeft(2, '0')}-${DateUtils.getDaysInMonth(DateTime.now().year, DateTime.now().month).toString().padLeft(2, '0')}'));

    widget.onDataChange?.call(valueDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: widget.isRequired ? '* ' : 'Tanggal ${widget.title}',
                style: widget.isRequired
                    ? const TextStyle(color: kErrorColor)
                    : const TextStyle(
                        color: kPrimaryTextColor, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.isRequired
                          ? 'Tanggal ${widget.title}'
                          : '(Optional)',
                      style: widget.isRequired
                          ? const TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold)
                          : const TextStyle(
                              color: kSecondaryTextColor,
                              fontWeight: FontWeight.normal)),
                ],
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
                hintText: 'Pilih', hintStyle: Get.textTheme.bodyMedium),
            controller:
                TextEditingController(text: widget.setDateValue ?? textDate),
            validator: widget.validator,
            onTap: () {
              if (widget.enabled == true) _selectDate(context);
            },
          ),
        ),
      ],
    );
  }
}
