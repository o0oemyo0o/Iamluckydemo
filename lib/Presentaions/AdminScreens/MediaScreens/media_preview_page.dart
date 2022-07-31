import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/tasks_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';
import 'package:video_player/video_player.dart';

import '../../../GetControllers/admin_controller.dart';

class MediaPreviewPage extends StatefulWidget {
  final String url;

  const MediaPreviewPage({Key? key, required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MediaPreviewPageState();
}

class _MediaPreviewPageState extends State<MediaPreviewPage> {
  late VideoPlayerController _controller;
  final _firebaseAuthClass = Get.put(FirebaseAuthClass());
  final _adminController = Get.put(AdminController());
  final _taskController = Get.put(TasksController());

  bool isInitialized = false;

  loadVideoPlayer() {
    _controller = VideoPlayerController.network(widget.url);
    _controller.addListener(() {
      setState(() {
        /// Check if video completed
        if (_controller.value.position == _controller.value.duration) {
          if (SharedText.userModel.role! == 1) {
            _firebaseAuthClass.changeUserPoints(
                _firebaseAuthClass.currentPoints.value +
                    _taskController.taskRewardPoints);

            _adminController.updateUserWatchedVideosCount();
          }
          Get.back();
        }
      });
    });
    _controller.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint('timeStamp: ${DateTime.now().millisecondsSinceEpoch}');

    loadVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: AppConstants.mainColor),
      body: Center(
        child: _controller.value.isInitialized
            ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: SharedText.screenHeight * 0.5,
                width: SharedText.screenWidth,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Text("${'Total_duration'.tr}: " +
                  _controller.value.position.toString() +
                  _controller.value.duration.toString()),
              SizedBox(
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: false,
                  colors: const VideoProgressColors(
                    backgroundColor: AppConstants.finishedEasyTaskColor,
                    playedColor: AppConstants.mainColor,
                    bufferedColor: AppConstants.easyTaskColor,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  icon: Icon(_controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow)),
              getSpaceHeight(15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('complete_watching_to_win_points'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        )
            : const Center(
          child: CircularProgressIndicator(
            backgroundColor: AppConstants.mainColor,
            color: AppConstants.easyTaskColor,
          ),
        ),
      ),
    );
  }
}
