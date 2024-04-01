import 'package:fitness_app/checkout.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:fitness_app/ui/main_player.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key, this.videos}) : super(key: key);
  final List? videos;
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  // VideoPlayerController? _videoPlayerController;
  // var link =
  // 'https://firebasestorage.googleapis.com/v0/b/plans-4bbcb.appspot.com/o/files%2F766eb4c88ed746a3988fad17087a361c.mp4?alt=media&token=a240b726-e114-40af-9fc2-2ca110d54735';
  // @override
  // void initState() {
  //   super.initState();
  //   _videoPlayerController =
  //       VideoPlayerController.network(widget.videos!.elementAt(1))
  //         ..addListener(() {
  //           setState(() {});
  //         })
  //         ..setLooping(true)
  //         ..initialize().then((value) => _videoPlayerController!.pause());
  //   setState(() {});
  //   // setLandscape();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: widget.videos!.length,
          itemBuilder: (BuildContext context, int index) {
            return VideoThumbnail(link: widget.videos!.elementAt(index));
            // VideoItem(videoLink: widget.videos!.elementAt(index));
          },
        ),
      ),
    );
  }
}

class VideoThumbnail extends StatefulWidget {
  const VideoThumbnail({Key? key, this.link}) : super(key: key);
  final String? link;

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  var futureImage;

  @override
  void initState() {
    super.initState();
    setState(() {
      futureImage = GenThumbnailImage(
        thumbnailRequest: ThumbnailRequest(
          video: widget.link,
          thumbnailPath: null,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 256, // _sizeH,
          maxWidth: 256, // _sizeW,
          timeMs: 1000, // 10 * 1000, // _timeMs,
          quality: 100,
        ),
      );
    });
    getThumbnail();
  }

  getThumbnail() async {
    final fileName = await VideoThumbnail(
      link:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      // thumbnailPath: null, // (await getTemporaryDirectory()).path,
      // imageFormat: ImageFormat.WEBP,s
      // maxHeight:
      //     64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      // quality: 75,
    );
    setState(() {
      futureImage = fileName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 1, top: 1),
          margin: const EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3.5,
          child: futureImage != null ? futureImage : Container(),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 1, top: 1),
          margin: const EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3.5,
          color: Colors.blueGrey.withOpacity(0.8),
          child: const Icon(
            Icons.play_circle_outline_outlined,
            size: 64,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class VideoItem extends StatefulWidget {
  final String? videoLink;

  const VideoItem({Key? key, this.videoLink}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController? _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoLink!)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((value) => _videoPlayerController!.pause());
    setState(() {});
    // setLandscape();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 1, top: 1),
            margin: const EdgeInsets.all(2),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.5,
            color: Colors.blueGrey,
            child: VideoPlayer(_videoPlayerController!),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPLayer(
                    videoLink: widget.videoLink,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 1, top: 1),
              margin: const EdgeInsets.all(2),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              color: Colors.blueGrey.withOpacity(0.8),
              child: const Icon(
                Icons.play_circle_outline_outlined,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
