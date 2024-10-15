import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/widgets/project_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:community_islamic_app/controllers/project_controller.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final ProjectController projectController = Get.put(ProjectController());
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    projectController
        .fetchProjectApi(); // Fetch data when the widget is initialized
  }

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
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          const Projectbackground(
            title: 'OUR PROJECTS',
          ),
          Expanded(
            child: Obx(() {
              if (projectController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (projectController.projectData.value.data.x.isEmpty) {
                return const Center(child: Text("No data available."));
              } else {
                return ListView.builder(
                  itemCount: projectController.projectData.value.data.x.length,
                  itemBuilder: (context, index) {
                    final project =
                        projectController.projectData.value.data.x[index];
                    final isExpanded = expandedIndex == index;

                    return Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                color: primaryColor,
                                child: Center(
                                  child: Text(
                                    projectController
                                        .formatDate(project.projectDate ??
                                            DateTime.now())
                                        .split(' ')[0],
                                    style: const TextStyle(
                                      fontFamily: popinsRegulr,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              5.widthBox,
                              Expanded(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project.projectDescription,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: popinsRegulr,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      project.projectTitle,
                                      style: const TextStyle(
                                        fontFamily: popinsRegulr,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    expandedIndex = isExpanded ? null : index;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (isExpanded) ...[
                            const SizedBox(height: 10),
                            Image.network(
                              project.projectImage,
                              height: 200,
                            ).p12(),
                          ],
                        ],
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
