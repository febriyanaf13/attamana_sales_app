import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../style/colors.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final String title;
  final bool enabled;
  final bool isRequired;
  final Function(String?)? onDataChange;
  final String? Function(String?)? validator;

  const CustomTimePickerDialog({
    Key? key,
    this.onDataChange,
    this.enabled = true,
    this.validator,
    required this.title,
    required this.isRequired,
  }) : super(key: key);

  @override
  State<CustomTimePickerDialog> createState() =>
      _CustomDateTimePickerDialogState();
}

class _CustomDateTimePickerDialogState extends State<CustomTimePickerDialog> {
  var pickedTime;
  var valueTime;
  var validator;

  _selectDate(BuildContext context) async {
    pickedTime = TimeOfDay.now();
    final TimeOfDay? selected = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selected != null) {
      setState(() {
        pickedTime = selected;
        DateTime parsedTime =
            DateFormat.jm().parse(pickedTime.format(context).toString());
        valueTime = DateFormat('HH:mm').format(parsedTime);
      });
    } else {
      validator = '';
    }

    widget.onDataChange?.call(valueTime);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: widget.isRequired ? '* ' : 'Waktu ${widget.title}',
                  style: widget.isRequired
                      ? const TextStyle(color: kErrorColor)
                      : const TextStyle(
                          color: kPrimaryTextColor,
                          fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: widget.isRequired
                            ? 'Waktu ${widget.title}'
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
            height: 50,
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                  hintText: 'Pilih', hintStyle: Get.textTheme.bodyMedium),
              controller: TextEditingController(text: valueTime),
              validator: widget.validator,
              onTap: () {
                if (widget.enabled == true) _selectDate(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
