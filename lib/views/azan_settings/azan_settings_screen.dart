import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/controllers/home_controller.dart';
import 'package:community_islamic_app/services/notification_service.dart';
import 'package:community_islamic_app/views/azan_settings/events_notification_settinons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzanSettingsScreen extends StatefulWidget {
  const AzanSettingsScreen({super.key});

  @override
  _AzanSettingsScreenState createState() => _AzanSettingsScreenState();
}

class _AzanSettingsScreenState extends State<AzanSettingsScreen> {
  String _selectedAzan = 'Adhan - Makkah';

  Map<String, bool> _azanTimes = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  Map<String, bool> _iqamahTimes = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  // Add a map to track the playing state for each Azan sound
  final Map<String, bool> _isPlaying = {
    'Adhan - Makkah': false,
    'Adhan - Madina': false,
  };

  SharedPreferences? sharedPreferences;

  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    screenInit();
  }

  Future<void> screenInit() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _azanTimes = {
          'Fajr': sharedPreferences!.getBool("fajr")!,
          'Dhuhr': sharedPreferences!.getBool("dhuhr")!,
          'Asr': sharedPreferences!.getBool("asr")!,
          'Maghrib': sharedPreferences!.getBool("maghrib")!,
          'Isha': sharedPreferences!.getBool("isha")!,
        };

        _iqamahTimes = {
          'Fajr': sharedPreferences!.getBool("fajrIqamah")!,
          'Dhuhr': sharedPreferences!.getBool("dhuhrIqamah")!,
          'Asr': sharedPreferences!.getBool("asrIqamah")!,
          'Maghrib': sharedPreferences!.getBool("maghribIqamah")!,
          'Isha': sharedPreferences!.getBool("ishaIqamah")!,
        };

        _selectedAzan = sharedPreferences!.getString("selectedSound")!;
      });
    }
  }

  HomeController homeController = Get.find<HomeController>();

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
            size: 20,
          ),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18,
            // fontWeight: FontWeight.bold,
            fontFamily: popinsSemiBold,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: lightColor,
              height: 2.0,
            )),
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (_azanTimes.values.every((val) => val)) {
                for (var azanTime in _azanTimes.keys) {
                  _azanTimes[azanTime] = false;

                  sharedPreferences!.setBool(azanTime.toLowerCase(), false);
                }

                for (var iqamahTime in _iqamahTimes.keys) {
                  _iqamahTimes[iqamahTime] = false;

                  sharedPreferences!
                      .setBool("${iqamahTime.toLowerCase()}Iqamah", false);
                }
                setState(() {});

                await AwesomeNotifications().cancelAll();
                // await homeController.setNotifications();`
              } else {
                for (var azanTime in _azanTimes.keys) {
                  _azanTimes[azanTime] = true;

                  sharedPreferences!.setBool(azanTime.toLowerCase(), true);
                }
                for (var iqamahTime in _iqamahTimes.keys) {
                  _iqamahTimes[iqamahTime] = true;

                  sharedPreferences!
                      .setBool("${iqamahTime.toLowerCase()}Iqamah", true);
                }
                setState(() {});

                await homeController.setPrayerTimes();
              }
            },
            child: Container(
              width: double.maxFinite,
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text(
                    _azanTimes.values.every((val) => val)
                        ? "Turn off Notification"
                        : "Turn on Notification",
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: popinsMedium,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    _azanTimes.values.every((val) => val)
                        ? Icons.check_circle_outline
                        : Icons.circle_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildAzanSelection(),
          const SizedBox(height: 20),
          _buildAzanTimeSelection(),
        ],
      ),
    );
  }

  Widget _buildAzanSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adhan Sound',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: popinsSemiBold),
          ),
          // const SizedBox(height: 10),
          Column(
            children: [
              _buildAzanOption('Disable', 'disable_channel'),
              _buildAzanOption('Default', 'beep_channel'),
              _buildAzanOption('Adhan - Makkah', 'makkah_channel'),
              _buildAzanOption('Adhan - Madina', 'madina_channel'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAzanOption(String title, String channel) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Radio<String>(
        activeColor: primaryColor,
        value: channel,
        groupValue: _selectedAzan,
        onChanged: (String? value) async {
          sharedPreferences?.setString("selectedSound", value!);

          setState(() {
            _selectedAzan = value!;
          });

          await homeController.setPrayerTimes();
        },
      ),
      title: Text(
        title,
        style: TextStyle(fontFamily: popinsRegulr),
      ),
      trailing: title != 'Disable' && title != 'Default'
          ? IconButton(
              icon: _isPlaying[title] == true
                  ? Icon(
                      Icons.pause,
                      color: primaryColor,
                    )
                  : Icon(
                      Icons.play_arrow,
                      color: primaryColor,
                    ),
              onPressed: () async {
                if (_isPlaying[title] == true) {
                  // Stop the current audio if playing
                  await player.stop();
                  setState(() {
                    _isPlaying[title] = false;
                  });
                } else {
                  // Stop any audio currently playing
                  for (var key in _isPlaying.keys) {
                    _isPlaying[key] = false;
                  }

                  // Play the selected Azan sound
                  if (title == "Adhan - Makkah") {
                    await player.play(AssetSource("azan.mp3"));
                  } else if (title == "Adhan - Madina") {
                    await player.play(AssetSource("azanmadina.mp3"));
                  }

                  setState(() {
                    _isPlaying[title] = true;
                  });
                }
              },
            )
          : null,
    );
  }

  Widget _buildAzanTimeSelection() {
    // Your Azan time selection code (unchanged)
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Prayer Time',
                      style: TextStyle(
                        fontFamily: popinsMedium,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    'Adhan',
                    style: TextStyle(
                      fontFamily: popinsMedium,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Iqamah',
                    style: TextStyle(
                      fontFamily: popinsMedium,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Column(
                children: homeController.prayerTimes?.data?.prayerTime!
                        .toJson()
                        .entries
                        .map((MapEntry<String, dynamic> time) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              time.key,
                              style: TextStyle(
                                fontFamily: popinsRegulr,
                                color: time.key == "Sunrise"
                                    ? primaryColor
                                    : Colors.black,
                                fontWeight: time.key == "Sunrise"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: Text(
                          //     homeController.prayerTimes!
                          //         .convertTimeFormat(time.value.toString()),
                          //     style: TextStyle(
                          //       fontFamily: popinsRegulr,
                          //       color: time.key == "Sunrise"
                          //           ? primaryColor
                          //           : Colors.black,
                          //       fontWeight: time.key == "Sunrise"
                          //           ? FontWeight.bold
                          //           : FontWeight.normal,
                          //     ),
                          //   ),
                          // ),
                          Checkbox(
                            value: _azanTimes[time.key],
                            activeColor: primaryColor,
                            onChanged: (bool? value) async {
                              setState(() {
                                _azanTimes[time.key] = value!;
                              });

                              sharedPreferences!
                                  .setBool(time.key.toLowerCase(), value!);

                              await homeController.setPrayerTimes();
                            },
                          ),
                          Checkbox(
                            value: _iqamahTimes[time.key]!,
                            activeColor: primaryColor,
                            onChanged: (bool? value) async {
                              setState(() {
                                _iqamahTimes[time.key] = value!;
                              });

                              sharedPreferences!.setBool(
                                  "${time.key.toLowerCase()}Iqamah", value!);

                              await homeController.setPrayerTimes();
                            },
                          ),
                        ],
                      );
                    }).toList() ??
                    [],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 10,
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Event & Announcement Notifications',
                        style: TextStyle(fontFamily: popinsRegulr),
                      ),
                      IconButton(
                          onPressed: () =>
                              Get.to(() => NotificationSettingsPage()),
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                            size: 15,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
