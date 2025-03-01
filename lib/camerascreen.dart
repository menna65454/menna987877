// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   bool _isRecording = false;
//   int _recordDuration = 0; // العداد الزمني
//   Timer? _timer; // مؤقت لتحديث العداد

//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }

//   Future<void> _initCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras == null || _cameras!.isEmpty) {
//       print("No cameras found");
//       return;
//     }

//     // اختيار الكاميرا الأمامية
//     final frontCamera = _cameras!.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front,
//     );

//     _controller = CameraController(frontCamera, ResolutionPreset.medium);

//     await _controller!.initialize();
//     if (!mounted) return;
//     setState(() {});
//   }

//   void _startTimer() {
//     _recordDuration = 0; // إعادة ضبط العداد
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         _recordDuration++;
//       });
//     });
//   }

//   void _stopTimer() {
//     _timer?.cancel();
//   }

//   Future<void> _startRecording() async {
//     if (_controller == null || _controller!.value.isRecordingVideo) return;

//     await _controller!.startVideoRecording();
//     setState(() => _isRecording = true);

//     _startTimer(); // بدء العداد
//   }

//   Future<void> _stopRecording() async {
//     if (_controller == null || !_controller!.value.isRecordingVideo) return;

//     final file = await _controller!.stopVideoRecording();
//     print('Video recorded to: ${file.path}');

//     setState(() => _isRecording = false);
//     _stopTimer(); // إيقاف العداد
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     _stopTimer();
//     super.dispose();
//   }

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Camera Recorder")),
//       body: _controller == null || !_controller!.value.isInitialized
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Expanded(child: CameraPreview(_controller!)),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     "Recording Time: $_recordDuration s",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _isRecording ? null : _startRecording,
//                       child: Text("Start Recording"),
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: _isRecording ? _stopRecording : null,
//                       child: Text("Stop Recording"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:video_player/video_player.dart'; // إضافة مكتبة تشغيل الفيديو

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  int _recordDuration = 0; // العداد الزمني
  Timer? _timer; // مؤقت لتحديث العداد

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      print("No cameras found");
      return;
    }

    // اختيار الكاميرا الأمامية
    final frontCamera = _cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.medium);

    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  void _startTimer() {
    _recordDuration = 0; // إعادة ضبط العداد
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _startRecording() async {
    if (_controller == null || _controller!.value.isRecordingVideo) return;

    await _controller!.startVideoRecording();
    setState(() => _isRecording = true);

    _startTimer(); // بدء العداد
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;

    final file = await _controller!.stopVideoRecording();
    print('Video recorded to: ${file.path}');

    setState(() => _isRecording = false);
    _stopTimer(); // إيقاف العداد

    // الانتقال إلى الشاشة الجديدة لتشغيل الفيديو
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoPath: file.path),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Recorder")),
      body: _controller == null || !_controller!.value.isInitialized
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: CameraPreview(_controller!)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Recording Time: $_recordDuration s",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isRecording ? null : _startRecording,
                      child: Text("Start Recording"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isRecording ? _stopRecording : null,
                      child: Text("Stop Recording"),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreen({required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player")),
      body: _controller == null || !_controller!.value.isInitialized
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
    );
  }
}
