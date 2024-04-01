// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:media_picker/media_picker.dart';
// import 'package:video_player/video_player.dart';

// // void main() => runApp(VideoUpload());

// class VideoUpload extends StatefulWidget {
//   const VideoUpload({Key? key}) : super(key: key);

//   @override
//   _VideoUploadState createState() => _VideoUploadState();
// }

// class _VideoUploadState extends State<VideoUpload> {
//   String _media = '';
//   List<dynamic>? _mediaPaths;

//   String textt = 'Sign In';

//   // VideoPlayerController? controller;

//   @override
//   initState() {
//     super.initState();
//   }

//   pickImages({quantity = 1}) async {
//     try {
//       _mediaPaths =
//           await MediaPicker.pickImages(withVideo: true, quantity: quantity);

// //      filter only images from mediaPaths and send them to the compressor
// //      List<dynamic> listCompressed = await MediasPicker.compressImages(imgPaths: [firstPath], maxWidth: 600, maxHeight: 600, quality: 100);
// //      print(listCompressed);

//     } on PlatformException {}

//     if (!mounted) return;

//     convertPath(_mediaPaths!.first.toString());
//   }

//   convertPath(String uri) async {
//     final filePath = await FlutterAbsolutePath.getAbsolutePath(uri);
//     setState(() {
//       _media = filePath;
//     });
//   }

//   pickVideos() async {
//     try {
//       _mediaPaths = await MediaPicker.pickVideos(quantity: 7);
//     } on PlatformException {}

//     if (!mounted) return;

//     setState(() {
//       _media = _mediaPaths!.first.toString();
//     });

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ButterFlyAssetVideo(
//           filepath: _media,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Image.file(File.fromUri(Uri.parse(_media))),
//               // VideoPlayer(controller!),
//               Text('media: $_media\n'),
//               MaterialButton(
//                 child: const Text(
//                   "Pick images and videos",
//                 ),
//                 onPressed: () => pickImages(),
//               ),
//               MaterialButton(
//                 child: const Text(
//                   "Pick just videos",
//                 ),
//                 onPressed: () => pickVideos(),
//               ),
//               MaterialButton(
//                 child: const Text(
//                   "Delete temp folder (automatic on ios)",
//                 ),
//                 onPressed: () async {
//                   if (await MediaPicker.deleteAllTempFiles()) {
//                     setState(() {
//                       _media = "deleted";
//                     });
//                   } else {
//                     setState(() {
//                       _media = "not deleted";
//                     });
//                   }
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   FirebaseAuth.instance.signInAnonymously().whenComplete(() {
//                     setState(() {
//                       textt = 'Ok';
//                     });
//                   });
//                 },
//                 child: Text(textt),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   uploadToStorage().then((value) {
//                     print('value is $value');
//                   });
//                 },
//                 child: const Text('Upload'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ButterFlyAssetVideo extends StatefulWidget {
//   final String? filepath;

//   const ButterFlyAssetVideo({Key? key, this.filepath}) : super(key: key);
//   @override
//   _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
// }

// class _ButterFlyAssetVideoState extends State<ButterFlyAssetVideo> {
//   VideoPlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.contentUri(Uri.file(widget.filepath!));
//     //asset('assets/Butterfly-209.mp4');

//     _controller!.addListener(() {
//       setState(() {});
//     });
//     _controller!.setLooping(true);
//     _controller!.initialize().then((_) => setState(() {}));
//     _controller!.play();
//   }

//   @override
//   void dispose() {
//     _controller!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.only(top: 20.0),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('With assets mp4'),
//             ),
//             Container(
//               padding: const EdgeInsets.all(20),
//               child: AspectRatio(
//                 aspectRatio: _controller!.value.aspectRatio,
//                 child: Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: <Widget>[
//                     VideoPlayer(_controller!),
//                     _ControlsOverlay(controller: _controller!),
//                     VideoProgressIndicator(_controller!, allowScrubbing: true),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ControlsOverlay extends StatelessWidget {
//   const _ControlsOverlay({Key? key, required this.controller})
//       : super(key: key);

//   static const _examplePlaybackRates = [
//     0.25,
//     0.5,
//     1.0,
//     1.5,
//     2.0,
//     3.0,
//     5.0,
//     10.0,
//   ];

//   final VideoPlayerController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 50),
//           reverseDuration: const Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? const SizedBox.shrink()
//               : Container(
//                   color: Colors.black26,
//                   child: const Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 100.0,
//                     ),
//                   ),
//                 ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//         Align(
//           alignment: Alignment.topRight,
//           child: PopupMenuButton<double>(
//             initialValue: controller.value.playbackSpeed,
//             tooltip: 'Playback speed',
//             onSelected: (speed) {
//               controller.setPlaybackSpeed(speed);
//             },
//             itemBuilder: (context) {
//               return [
//                 for (final speed in _examplePlaybackRates)
//                   PopupMenuItem(
//                     value: speed,
//                     child: Text('${speed}x'),
//                   )
//               ];
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 // Using less vertical padding as the text is also longer
//                 // horizontally, so it feels like it would need more spacing
//                 // horizontally (matching the aspect ratio of the video).
//                 vertical: 12,
//                 horizontal: 16,
//               ),
//               child: Text('${controller.value.playbackSpeed}x'),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// Future uploadToStorage() async {
//   debugPrint('1');
//   try {
//     final DateTime now = DateTime.now();
//     final int millSeconds = now.millisecondsSinceEpoch;
//     final String month = now.month.toString();
//     final String date = now.day.toString();
//     final String storageId = (millSeconds.toString() + 'uid');
//     final String today = ('$month-$date');
//     debugPrint('2');

//     XFile? xfile = await ImagePicker().pickVideo(source: ImageSource.gallery);
//     File? file = File(xfile!.path);
//     Reference ref = FirebaseStorage.instance
//         .ref()
//         .child("video")
//         .child(today)
//         .child(storageId);
//     UploadTask? uploadTask =
//         ref.putFile(file, SettableMetadata(contentType: 'video/mp4'));
//     // ref.putFile(file, StorageMetadata(contentType: 'video/mp4'));
//     // <- this content type does the trick
//     debugPrint('3');

//     // Uri? downloadUrl =
//     //     (await (uploadTask.storage).ref().getDownloadURL()) as Uri?;
//     debugPrint('4');

//     final String url = 'downloadUrl.toString()';

//     print(url);
//   } catch (error) {
//     debugPrint('5');

//     print(error);
//   }
// }

// Future uploadVideoToStorage() async {
//   debugPrint('1');
//   Reference ref = FirebaseStorage.instance.ref('/notes.txt');
//   try {
//     final DateTime now = DateTime.now();
//     final int millSeconds = now.millisecondsSinceEpoch;
//     final String month = now.month.toString();
//     final String date = now.day.toString();
//     final String storageId = (millSeconds.toString() + 'uid');
//     final String today = ('$month-$date');
//     debugPrint('2');

//     XFile? xfile = await ImagePicker().pickVideo(source: ImageSource.gallery);
//     File? file = File(xfile!.path);
//     Reference ref = FirebaseStorage.instance
//         .ref()
//         .child("video")
//         .child(today)
//         .child(storageId);
//     UploadTask? uploadTask =
//         ref.putFile(file, SettableMetadata(contentType: 'video/mp4'));
//     // ref.putFile(file, StorageMetadata(contentType: 'video/mp4'));
//     // <- this content type does the trick
//     debugPrint('3');

//     Uri? downloadUrl =
//         (await (uploadTask.storage).ref().getDownloadURL()) as Uri?;

//     final String url = downloadUrl.toString();
//     debugPrint('4');
//     print(url);
//   } catch (error) {
//     print('catch error');
//     print(error);
//   }
// }
