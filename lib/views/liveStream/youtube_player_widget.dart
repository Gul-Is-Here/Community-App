import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../controllers/live_stream_controller.dart';

class YouTubePlayerPage extends StatefulWidget {
  @override
  _YouTubePlayerPageState createState() => _YouTubePlayerPageState();
}

class _YouTubePlayerPageState extends State<YouTubePlayerPage> {
  final LiveStreamController controller = Get.find();
  late YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    String videoId =
        YoutubePlayer.convertUrlToId(controller.liveUrl.value) ?? "";

    if (videoId.isNotEmpty) {
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(autoPlay: true, mute: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YouTube Live Stream")),
      body: YoutubePlayer(
        controller: _ytController,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
