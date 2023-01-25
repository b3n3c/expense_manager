import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:targyalo/camera_manager.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class TakeProfilePictureScreen extends StatefulWidget {
  const TakeProfilePictureScreen({super.key});

  @override
  State<TakeProfilePictureScreen> createState() => _TakeProfilePictureScreenState();
}

class _TakeProfilePictureScreenState extends State<TakeProfilePictureScreen> {
  var camera;

  @override
  Widget build(BuildContext context) {
    availableCameras().then((availableCameras) {
      setState(() {
        camera = availableCameras.first;
      });
    });

    if (camera == null)
      return CircularProgressIndicator();
    else{
      return TakeProfilePicture(camera: camera);
    }
  }
}

class TakeProfilePicture extends StatefulWidget {
  final CameraDescription camera;

  TakeProfilePicture({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _TakeProfilePictureState createState() => _TakeProfilePictureState();
}

class _TakeProfilePictureState extends State<TakeProfilePicture> {
  late Future<void> _initializeControllerFuture;
  late CameraManager cameraManager;

  void initState() {
    super.initState();

    cameraManager = CameraManager(camera: widget.camera);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = cameraManager.initialize();
  }

  @override
  void dispose() {
    cameraManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kép készítése"),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // A kamera inicializálódott, meg lehet mutatni az előképet
            return CameraPreview(cameraManager.cameraController);
          } else {
            // Még nincs áll rendelkezésre a kamera, betöltő ikon-t mutatunk addig.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            // Inicializáljuk a kamerát
            await _initializeControllerFuture;

            // A kép mentésének a helye.
            final path = join(
              (await getApplicationDocumentsDirectory()).path,
              DateTime.now().millisecondsSinceEpoch.toString() + '.png',
            );
            final file = File(path);
            if (file.existsSync()) {
              file.deleteSync();
            }
            // Készítunk egy képet
            final picture = await cameraManager.cameraController.takePicture();
            final pictureFile = File(picture.path);
            await pictureFile.copy(file.path);

            // Visszaadjuk a mentett fájlt az előző képernyőnek.
            Navigator.pop(context, file);
          } catch (e) {
            // Valami hiba volt...
            print(e);
          }
        },
      ),
    );
  }
}