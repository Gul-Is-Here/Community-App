import 'package:community_islamic_app/widgets/project_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/color.dart';
import '../../controllers/gallery_controller.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryImagesScreen extends StatelessWidget {
  final String catHash;
  final String categoryName;

  const GalleryImagesScreen({
    required this.catHash,
    required this.categoryName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GalleryController galleryController = Get.put(GalleryController());

    // Fetch gallery data only once when the controller is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      galleryController.fetchGalleryData(catHash, categoryName);
    });

    return Scaffold(
        body: Column(
      children: [
        const Projectbackground(title: 'GALLERY'),
        Container(
          height: 45,
          width: double.infinity,
          decoration: BoxDecoration(color: primaryColor),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'MEET & GREET',
              style: TextStyle(
                fontFamily: popinsSemiBold,
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (galleryController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (galleryController.galleryList.isEmpty) {
              return const Center(child: Text('No images found.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: galleryController.galleryList.length,
              itemBuilder: (context, index) {
                final galleryItem = galleryController.galleryList[index];
                return GestureDetector(
                  onTap: () {
                    _showFullScreenImage(context, galleryItem.galleryImage);
                  },
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        galleryItem.galleryImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        )
      ],
    ));
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color.fromARGB(0, 144, 78, 78),
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: 1,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * .5,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                color: Colors.black,
              ),
              pageController: PageController(),
            ),
            Positioned(
              top: 40,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
