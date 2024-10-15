import 'package:community_islamic_app/app_classes/app_class.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/views/home_screens/EventsAndannouncements/events_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_events_controller.dart';

class EventsScreen extends StatelessWidget {
  final HomeEventsController eventsController = Get.put(HomeEventsController());

  EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Community Events',
          style: TextStyle(fontFamily: popinsSemiBold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (eventsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (eventsController.events.value == null ||
            eventsController.events.value!.data.events.isEmpty) {
          return const Center(
            child: Text(
              'No Events Found',
              style: TextStyle(fontFamily: popinsMedium),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: eventsController.events.value!.data.events.length,
            itemBuilder: (context, index) {
              var event = eventsController.events.value!.data.events[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.grey.withOpacity(0.3),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => EventsDetailsScreen(
                            eventDate: event.eventDate.toString(),
                            eventDetails: event.eventDetail,
                            eventLink: event.eventLink,
                          ));
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Date with icon
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 18, color: primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                eventsController.formatDateString(
                                    event.eventDate.toString()),
                                style: const TextStyle(
                                  fontFamily: popinsMedium,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Event Description
                          Text(
                            event.eventDetail,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: popinsMedium,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Action Button Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // View More Button
                              ElevatedButton.icon(
                                onPressed: () {
                                  AppClass().launchURL(event.eventLink);
                                },
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Visit',
                                  style: TextStyle(
                                      fontFamily: popinsSemiBold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                              // Event Time
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 18, color: primaryColor),
                                  const SizedBox(width: 5),
                                  Text(
                                    eventsController.formatDateString(
                                        event.eventDate.toString()),
                                    style: const TextStyle(
                                      fontFamily: popinsMedium,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
