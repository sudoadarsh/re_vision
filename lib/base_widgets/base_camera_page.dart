import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:re_vision/base_widgets/base_text.dart';

class BaseCameraPage extends StatefulWidget {
  const BaseCameraPage({
    Key? key,
    required this.camera,
    required this.floatingButton, required this.callback,
  }) : super(key: key);

  final CameraDescription camera;
  final Widget floatingButton;
  final Function(XFile?) callback;

  @override
  State<BaseCameraPage> createState() => _BaseCameraPageState();
}

class _BaseCameraPageState extends State<BaseCameraPage> {
  late final CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController =
        CameraController(widget.camera, ResolutionPreset.medium);

    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();

    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_cameraController);
          } else if (snap.connectionState == ConnectionState.waiting) {
            // Otherwise, display a loading indicator.
            return const Center(child: CupertinoActivityIndicator());
          }
          return Column(
            children: const [
              Icon(Icons.error_outline_rounded),
              BaseText(
                "Unable to access camera.",
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ],
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          // Return the captured image here.

          try {
            // Ensure that the controller has been initialised.
            await _initializeControllerFuture;

            // Get the image.
            final XFile image = await _cameraController.takePicture();

            widget.callback(image);
          } catch (e) {
            debugPrint("Error taking picture: $e");

            widget.callback(null);
          }
        },
        child: widget.floatingButton,
      ),

      // Center the floating action button.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
