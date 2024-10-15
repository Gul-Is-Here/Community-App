import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community_islamic_app/constants/color.dart';
import 'package:community_islamic_app/views/Gallery_Events/gallery_images_screen.dart';
import 'package:community_islamic_app/views/Gallery_Events/gallery_videos_screen.dart';
import 'package:community_islamic_app/widgets/project_background.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../controllers/gallery_controller.dart';

class GalleyScreen extends StatelessWidget {
  const GalleyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _showGalleryEventsDialog(BuildContext context,
        {required String categoryName}) {
      Get.dialog(
        AlertDialog(
          title: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                primaryColor,
                const Color.fromARGB(255, 157, 210, 212),
              ]),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: Colors.black, width: 1),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: const Center(
              child: Text(
                'Gallery',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: popinsRegulr),
              ),
            ),
          ),
          content: const Text(
            'Choose an option:',
            style: TextStyle(
              fontFamily: popinsRegulr,
              fontSize: 18,
              color: CupertinoColors.black,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Get.back(); // Close the dialog
                Get.to(() => GalleryImagesScreen(
                      catHash: 'images',
                      categoryName:
                          categoryName, // Pass content type as 'images'
                    )); // Navigate to Images screen with catHash and contentType parameters
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Images',
                  style: TextStyle(
                    fontFamily: popinsRegulr,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Get.back(); // Close the dialog
                Get.to(() => GalleryVideosScreen(
                      catHash: 'Video',
                      categoryName:
                          categoryName, // Pass content type as 'videos'
                    )); // Navigate to Videos screen with catHash and contentType parameters
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'Videos',
                  style: TextStyle(
                    fontFamily: popinsRegulr,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final GalleryController controller = Get.put(GalleryController());

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
          const Projectbackground(title: 'GALLERY'),
          10.heightBox,
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'EVENTS LIST',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: popinsSemiBold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          10.heightBox,
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.gallerySubcategories.isEmpty) {
                  return const Center(
                      child: Text(
                    'No events found.',
                    style: TextStyle(fontFamily: popinsRegulr),
                  ));
                } else {
                  return ListView.builder(
                    itemCount: controller.gallerySubcategories.length,
                    itemBuilder: (context, index) {
                      final subcategory =
                          controller.gallerySubcategories[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  _showGalleryEventsDialog(
                                    context,
                                    categoryName:
                                        subcategory.gallerySubcategoryHash,
                                  );
                                },
                                child: Text(
                                  subcategory.gallerySubcategoryName,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 24, fontFamily: popinsSemiBold,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 3,
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.elliptical(1, 25),
                                  ),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
