import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../controllers/live_stream_controller.dart';
// import 'controller/live_stream_controller.dart';

class YouTubePlayerPage extends StatefulWidget {
  @override
  _YouTubePlayerPageState createState() => _YouTubePlayerPageState();
}

class _YouTubePlayerPageState extends State<YouTubePlayerPage> {
  final LiveStreamController controller = Get.put(LiveStreamController());
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    controller.fetchLiveUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YouTube Live Stream")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        String videoId =
            YoutubePlayer.convertUrlToId(controller.liveUrl.value) ?? "";

        if (videoId.isEmpty) {
          return Center(child: Text("Invalid YouTube URL"));
        }

        _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(autoPlay: true, mute: false),
        );

        return YoutubePlayer(
          controller: _ytController,
          showVideoProgressIndicator: true,
        );
      }),
    );
  }
}
