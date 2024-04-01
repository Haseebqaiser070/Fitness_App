import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class MainPLayer extends StatefulWidget {
  const MainPLayer({Key? key, this.videoLink}) : super(key: key);
  final String? videoLink;
  @override
  _MainPLayerState createState() => _MainPLayerState();
}

class _MainPLayerState extends State<MainPLayer> {
  VideoPlayerController? _videoPlayerController;
  // var link =
  // 'https://firebasestorage.googleapis.com/v0/b/plans-4bbcb.appspot.com/o/files%2F766eb4c88ed746a3988fad17087a361c.mp4?alt=media&token=a240b726-e114-40af-9fc2-2ca110d54735';
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

  // Future setLandscape() async {
  //   await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // }

  Future setAllOrientations() async {
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    setAllOrientations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? Scaffold(
                backgroundColor: Colors.blue,
                body: Center(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height, //* 0.8,
                        color: Colors.blue, //.shade200,
                        child: Center(
                          child: _videoPlayerController!.value.isInitialized
                              ? buildMaxPlayer()
                              : buildLoadingWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          // (2.5 * zoom),
                          child: VideoPlayer(
                            _videoPlayerController!,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.4),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _videoPlayerController!.value.isPlaying
                                    ? _videoPlayerController!.pause()
                                    : _videoPlayerController!.play();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                _videoPlayerController!.value.isPlaying
                                    ? Icons.pause_outlined
                                    : Icons.play_arrow_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.4),
                          ),
                          child: InkWell(
                            onTap: () {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown,
                              ]);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.fullscreen_exit,
                                color: Colors.white,
                              ),
                            ),
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

  /////////////////////  Max Player    /////////////////////

  Widget buildMaxPlayer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.85,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(
              _videoPlayerController!,
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.brown.shade200.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // InkWell(
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color: Colors.brown.shade200
                              //           .withOpacity(0.4),
                              //       borderRadius: BorderRadius.circular(24),
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: Icon(
                              //         Icons.camera_alt_outlined,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Icon(
                              //   Icons.location_searching_sharp,
                              //   color: Colors.white,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 4.0),
                              //   child: InkWell(
                              //     onTap: () {
                              //       setState(() {
                              //         if (zoom > 0.4) {
                              //           zoom = zoom - 0.2;
                              //         }
                              //       });
                              //     },
                              //     child: Icon(
                              //       Icons.zoom_out_sharp,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 8.0),
                              //   child: InkWell(
                              //     onTap: () {
                              //       setState(() {
                              //         // _videoPlayerController.setPlaybackSpeed(2.0);
                              //         if (zoom < 2.4) {
                              //           zoom = zoom + 0.2;
                              //         }
                              //       });
                              //     },
                              //     child: Icon(
                              //       Icons.zoom_in_sharp,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_videoPlayerController!
                                          .value.isPlaying) {
                                        _videoPlayerController!.pause();
                                      } else {
                                        _videoPlayerController!.play();
                                      }
                                    });
                                  },
                                  child: Icon(
                                    _videoPlayerController!.value.isPlaying
                                        ? Icons.pause_outlined
                                        : Icons.play_arrow_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     left: 8.0,
                              //     right: 4.0,
                              //   ),
                              //   child: Text(
                              //     'Live'.toUpperCase(),
                              //     style: const TextStyle(
                              //       color: Colors.red,
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
                                  child: VideoProgressIndicator(
                                    _videoPlayerController!,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      backgroundColor: Colors.white,
                                      playedColor: Colors.blue,
                                      bufferedColor: Colors.blue.shade100,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${_videoPlayerController!.value.position.inSeconds} / ${_videoPlayerController!.value.duration.inSeconds}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //     Icon(
                              //       Icons.settings,
                              //       color: Colors.white,
                              //     ),
                              InkWell(
                                onTap: () {
                                  // fullScreenWidget();
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeRight,
                                    DeviceOrientation.landscapeLeft,
                                  ]);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /////////////  Loading Widget   ////////////////

  Widget buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Video is loading...'),
          ),
        ],
      ),
    );
  }
}
