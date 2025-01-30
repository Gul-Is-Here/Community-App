import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../controllers/live_stream_controller.dart';

class LiveStreamPage extends StatefulWidget {
  @override
  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  final LiveStreamController controller = Get.put(LiveStreamController());
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    controller.fetchLiveUrl(); // Fetch live URL

    // Initialize WebViewController
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Stream")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Load the live stream URL dynamically
        webViewController.loadRequest(Uri.parse(controller.liveUrl.value));

        return WebViewWidget(controller: webViewController);
      }),
    );
  }
}
