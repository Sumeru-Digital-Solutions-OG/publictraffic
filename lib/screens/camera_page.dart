// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fcamera/model/data.dart';
import 'package:fcamera/screens/image_viewer.dart';

class Camera extends StatefulWidget {
  List<CameraDescription>? cameras;
  XFile? image;

   Camera({super.key,this.image});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController cameraController;
  late XFile pictureFile;

  late Info info;
  late String status;
  late String reward;
  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
        print(e);
    });
    info = Info(title: "", date: DateTime.now(), desc: "", photos: "");
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  // clickPhoto() async {
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

  //   if (file == null) {
  //     return;
  //   }
  //   String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
  //   Reference ref = FirebaseStorage.instance.ref();
  //   Reference image = ref.child(uniqueName);
  //   try {
  //     await image.putFile(File(file!.path));
  //     _image = await image.getDownloadURL();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text("Camera")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    width: 400,
                    child: Center(
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          CameraPreview(cameraController),
                          IconButton(
                            onPressed: () async {
                              pictureFile =
                                  await cameraController.takePicture();

                              if (pictureFile == null) return;

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Preview(file: pictureFile!)));
                            },
                            icon: const Icon(
                              Icons.camera,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ignore: unnecessary_null_comparison
                  if (pictureFile != null)
                    Column(
                      children: [
                        Image.file(
                          File(pictureFile!.path),
                          height: 150,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}