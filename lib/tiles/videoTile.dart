import 'package:flutter/material.dart';
import 'package:wwatch/main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTile extends StatefulWidget {
  final BuildContext context;
  final AsyncSnapshot snapshot;
  final int index;

  VideoTile(this.context, this.snapshot, this.index);
  @override
  _VideoTileState createState() => _VideoTileState(context, snapshot, index);
}

YoutubePlayerController _controller;

class _VideoTileState extends State<VideoTile> {
  BuildContext context;
  AsyncSnapshot snapshot;
  int index;
  bool _isPlayerReady = false;
  @override
  void initState() {
    super.initState();
    String initialVideo = snapshot.data['results'][index]['key'];
    void listener() {
      if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
        setState(() {});
      }
    }

    _controller = YoutubePlayerController(
      initialVideoId: initialVideo,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
  }

  _VideoTileState(this.context, this.snapshot, this.index);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: YoutubePlayer(
        aspectRatio: 16 / 9,
        controller: _controller,
        bottomActions: <Widget>[
          const Expanded(child: SizedBox()),
          IconButton(
            icon: const Icon(
              Icons.ondemand_video,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              launchInBrowser(
                  "https://www.youtube.com/watch?v=${snapshot.data['results'][index]['key']}");
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
    );
  }
}
