// ignore_for_file: deprecated_member_use

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:blackcoffer/Widgets/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'create_post.dart';
import '../Services/functions.dart';
import 'model/vedio_model.dart';

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  final VideoModel model;

  const VideoApp({super.key, required this.model});
  @override
  // ignore: library_private_types_in_public_api
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late CustomVideoPlayerController _controller;
  late VideoPlayerController videoPlayerController;

  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.model.videoUrl)
      ..initialize().then((value) => setState(() {}));
    _controller = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiHelper.header(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: UiHelper.dashbox(),
                child: _controller.videoPlayerController.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomVideoPlayer(
                            customVideoPlayerController: _controller))
                    : const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
              ),
              UiHelper.heading(widget.model.title, 22),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child:
                    UiHelper.heading1("location: ${widget.model.address}", 16),
              ),
              Row(
                children: [
                  UiHelper.heading1("#450views", 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: UiHelper.heading1(
                        "#${timeago.format(widget.model.timestamp).trim()}",
                        16),
                  ),
                  UiHelper.heading1("#${widget.model.videoCategory}", 16),
                ],
              ),
              Row(
                children: [
                  UiHelper.symbolBox(Ionicons.thumbs_up),
                  UiHelper.symbolBox(Ionicons.thumbs_down),
                  UiHelper.symbolBox(Ionicons.share_social),
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Position position = await getGeoLocationPosition();
            uploadFileToFirebase()!.then((value) {
              if (value == null) {
                AppUtils.showSnackMessage("Something Went Wrong");
              } else {
                navigateslide(
                    CreatePost(
                      position: position,
                      imageUrl: value,
                    ),
                    context);
              }
            });
          },
          child: const Icon(
            Ionicons.add,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
