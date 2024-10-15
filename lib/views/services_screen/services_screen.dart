import 'package:community_islamic_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/project_background.dart';

class ServicesScreen extends StatelessWidget {
  // Sample data for services
  final List<Service> services = [
    Service(
      title: "5 Daily Prayers",
      description: "Join us for the 5 daily prayers at the community mosque.",
      icon: Icons.access_time,
    ),
    Service(
      title: "Free Quran Classes",
      description: "Learn the Quran for free with experienced instructors.",
      icon: Icons.book,
    ),
    Service(
      title: "Youth Sira Series",
      description:
          "Engaging series for youth on the life of the Prophet Muhammad (PBUH).",
      icon: Icons.group,
    ),
    Service(
      title: "Girls Halaqa",
      description:
          "A safe space for girls to learn and discuss Islamic teachings.",
      icon: Icons.girl,
    ),
    Service(
      title: "Youth Islamic Studies Program",
      description: "In-depth studies on Islamic teachings for youth.",
      icon: Icons.school,
    ),
    Service(
      title: "Youth Soccer Club",
      description: "Join the youth soccer club for fun and fitness.",
      icon: Icons.sports_soccer,
    ),
    Service(
      title: "Adult Soccer and Cricket Club",
      description: "Participate in soccer and cricket activities for adults.",
      icon: Icons.sports,
    ),
    Service(
      title: "Mommy and Me Toddler Stay Time",
      description: "Interactive sessions for moms and toddlers to bond.",
      icon: Icons.child_care,
    ),
  ];

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
        // title: const Text(
        //   'Services',
        //   style: TextStyle(fontFamily: popinsSemiBold, color: Colors.white),
        // ),
      ),
      body: Column(
        children: [
          Projectbackground(
            title: 'Services',
          ),
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceCard(service: service);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(service.icon, size: 40.0),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(
                        fontSize: 20, fontFamily: popinsSemiBold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(service.description,
                      style: const TextStyle(fontFamily: popinsRegulr)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle button press for service
              },
              child: Text('Details',
                  style:
                      TextStyle(fontFamily: popinsMedium, color: primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}

class Service {
  final String title;
  final String description;
  final IconData icon;

  Service({required this.title, required this.description, required this.icon});
}
