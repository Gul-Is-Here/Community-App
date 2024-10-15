import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_hijri_calendar/islamic_hijri_calendar.dart';

class HijriCalendarExample extends StatefulWidget {
  const HijriCalendarExample({
    super.key,
  });

  @override
  State<HijriCalendarExample> createState() => _HijriCalendarExampleState();
}

class _HijriCalendarExampleState extends State<HijriCalendarExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          backgroundColor: primaryColor,
          title: const Text(
            "Islamic Hijri Calendar",
            style: TextStyle(fontFamily: popinsSemiBold, color: Colors.white),
          )),
      body: SizedBox(
        height: 450,
        child: IslamicHijriCalendar(
          isHijriView:
              true, //allowing users to set either the English calendar only or display the Hijri calendar alongside the English calendar
          highlightBorder: Theme.of(context)
              .colorScheme
              .primary, // Set selected date border color
          defaultBorder: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(.1), // Set default date border color
          highlightTextColor: Theme.of(context)
              .colorScheme
              .surface, // Set today date text color
          defaultTextColor: Theme.of(context)
              .colorScheme
              .onSurface, //Set others dates text color
          defaultBackColor: Theme.of(context)
              .colorScheme
              .surface, // Set default date background color
          adjustmentValue:
              0, // Set hijri calendar adjustment value which is set  by user side
          isGoogleFont:
              true, // Set it true if you want to use google fonts else false
          fontFamilyName:
              "Lato", // Set your custom font family name or google font name
          getSelectedEnglishDate:
              (selectedDate) {}, // returns the date selected by user
          getSelectedHijriDate:
              (selectedDate) {}, // returns the date selected by user in Hijri format
          isDisablePreviousNextMonthDates:
              true, // Set dates which are not included in current month should show disabled or enabled
        ),
      ),
    );
  }
}
