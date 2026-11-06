import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

    // Perbaikan DatePicker dengan Tema Modern
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.parse(widget.firstDate ?? '1000-01-01'),
      lastDate: DateTime.parse(
          widget.lastDate ?? '${DateTime.now().year.toInt() + 1}-12-31'),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kPrimaryColor, // Header & Lingkaran seleksi
              onPrimary: Colors.white, // Teks di atas primary
              onSurface: const Color(0xFF1E293B), // Teks tanggal (Slate 900)
            ),
            // Perbaikan error: Menggunakan DialogThemeData untuk parameter dialogTheme
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
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

    widget.onDataChange?.call(valueDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- LABEL MODERN (Slate 600) ---
        RichText(
          text: TextSpan(
            text: widget.title,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            children: <TextSpan>[
              if (widget.isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: kErrorColor, fontSize: 14),
                )
              else
                TextSpan(
                  text: ' (Optional)',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // --- INPUT FIELD MODERN ---
        TextFormField(
          readOnly: true,
          enabled: widget.enabled,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B), // Slate 900
          ),
          // Menggunakan nilai setDateValue jika ada, jika tidak gunakan textDate (dd-MM-yyyy)
          controller:
              TextEditingController(text: widget.setDateValue ?? textDate),
          validator: widget.validator,
          onTap: () {
            if (widget.enabled == true) _selectDate(context);
          },
          decoration: InputDecoration(
            hintText: 'Pilih Tanggal',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: widget.enabled ? kPrimaryColor : Colors.grey.shade300,
            ),
            filled: true,
            fillColor: widget.enabled ? Colors.white : const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            // Border Design: Soft Slate
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kErrorColor, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
