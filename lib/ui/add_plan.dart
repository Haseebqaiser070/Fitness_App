import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/api/firebase_api.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class AddPlan extends StatefulWidget {
  const AddPlan({Key? key}) : super(key: key);

  @override
  _AddPlanState createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  String planname = 'PlanName';
  String plandescription = 'PlanDescription';
  String planprice = 'PlanPrice';

  // String _media = '';
  // List<dynamic>? _mediaPaths;
  UploadTask? task;
  File? file;

  bool? isLoading = false;

  bool? _success = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? link = '';

  Future? pp;

  var allUrls = [];
  var allTasks = [];
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signInAnonymously();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 160, 50, 10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.grey),
                    onChanged: (value) {
                      planname = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.grey),
                    onChanged: (value) {
                      plandescription = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: TextField(
                    controller: _priceController,
                    style: const TextStyle(color: Colors.grey),
                    onChanged: (value) {
                      planprice = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Price",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                //Title(color: Colors.black, child: Text('Upload Your Videos')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // uploadFiles();
                      // selectFile();
                      // pickVideos();
                      uploadFeed(context);
                    },
                    child: const Text("upload video"),
                  ),
                ),
                const SizedBox(height: 20),
                task != null ? buildUploadStatus(task!) : Container(),
                allTasks.length != 0
                    ? Text(
                        allTasks.length.toString() + ' Videos Selected',
                        style: const TextStyle(
                          color: Colors.amber,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 150,
                  child: TextButton(
                    onPressed: () {
                      savePlan();
                      print('yes');
                    },
                    child: Text(_success! ? 'Saved' : 'Save Plan'),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.grey,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;
    final paths = result.files; //.single.path!;
    await Future.wait(
      paths.map(
        (path) {
          setState(() => file = File(path.path!));
          final fileName = basename(file!.path);
          final destination = 'files/$fileName';

          task = FirebaseApi.uploadFile(destination, file!);

          // if (file == null) return
          return pp!;
        },
      ),
    );

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    setState(() {
      link = urlDownload;
    });
  }

////  copied

  // Future<List<String>> uploadFiles() async {
  //   final _images = await FilePicker.platform.pickFiles(allowMultiple: true);
  //   var imageUrls =
  //       await Future.wait(_images.map((_image) => uploadFile(_image)));
  //   print(imageUrls);
  //   return imageUrls;
  // }

  Future<String> uploadFile(File _image) async {
    var storageReference =
        FirebaseStorage.instance.ref().child('posts/${_image.path}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() => print('sad'));

    return await storageReference.getDownloadURL();
  }

////////newly copied
  List<UploadTask> _uploadTasks = [];

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask?> uploadFeed(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return null;
    final paths = result.files;
    if (paths == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    // Reference ref =
    //     FirebaseStorage.instance.ref().child('plays').child('/some-videos.mp4');

    // final metadata = SettableMetadata(
    //     contentType: 'video/mp4',
    //     customMetadata: {'picked-file-path': paths.elementAt(0).path!});

    // if (kIsWeb) {
    //   uploadTask = ref.putData(await file.readAsBytes(), metadata);
    // } else {
    int i = 0;
    while (i < paths.length) {
      print(i);
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('plans/${_nameController.text}')
          .child('/video#${i + 1} at ${DateTime.now().toIso8601String()}.mp4');

      final metadata = SettableMetadata(
          contentType: 'video/mp4',
          customMetadata: {'picked-file-path': paths.elementAt(i).path!});
      uploadTask = ref.putFile(File(paths.elementAt(i).path!), metadata);
      setState(() {
        task = uploadTask;
      });
      allTasks.add(uploadTask);
      setState(() {});
      uploadTask.then((p0) => print(p0.ref.getDownloadURL().then((value) {
            print(value);
            allUrls.add(value);
            setState(() {});
          })));
      // ref.getDownloadURL().then((value) => print(value));
      i++;
      print(allTasks);
    }
    // uploadTask = ref.putFile(File(paths.elementAt(0).path!), metadata);
    // }

    // return Future.value(uploadTask);
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Text(
              '$percentage %',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          } else {
            return Container();
          }
        },
      );

  void savePlan() {
    FirebaseFirestore.instance.collection('plans').doc().set({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'url': allUrls, // [link],
      'dateTime': DateTime.now().toString(),
    }).then((value) => debugPrint('Plan Added'));
    setState(() {
      isLoading = false;
      _success = true;
      _nameController.text = "";
      _descriptionController.text = "";
      _priceController.text = "";
    });
  }
}
