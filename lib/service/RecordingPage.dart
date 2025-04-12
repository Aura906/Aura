// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:permission_handler/permission_handler.dart'; // Import Permission Handler

// class AudioRecorder extends StatefulWidget {
//   @override
//   _AudioRecorderState createState() => _AudioRecorderState();

//   stop() {}

//   hasPermission() {}

//   start(RecordConfig recordConfig, {required String path}) {}
// }

// class _AudioRecorderState extends State<AudioRecorder> {
//   final _recorder = AudioRecorder();
//   bool _isRecording = false;
//   String? _filePath;
//   Timer? _timer;

//   // Future<void> _startRecording() async {
//   //   if (await _recorder.hasPermission()) {
//   //     final path =
//   //         '/storage/emulated/0/Download/audio_record.m4a'; // Change if needed
//   //     await _recorder.start(const RecordConfig(), path: path);

//   @override
//   void initState() {
//     super.initState();
//     requestPermissions(); // Request microphone permission when the app starts
//   }

//   Future<void> requestPermissions() async {
//     await Permission.microphone.request();
//   }

//   Future<void> _startRecording() async {
//     bool hasPermission =
//         (await _recorder.hasPermission()) ?? false; // Handle null case

//     if (hasPermission) {
//       final path =
//           '/storage/emulated/0/Download/audio_record.m4a'; // Change if needed
//       await _recorder.start(const RecordConfig(), path: path);

//       setState(() {
//         _isRecording = true;
//         _filePath = path;
//       });
//     } else {
//       print("Microphone permission denied");
//     }
//   }

//   // Stop recording after 2 minutes
//   //     _timer = Timer(Duration(minutes: 2), () {
//   //       if (_isRecording) {
//   //         _stopRecording();
//   //       }
//   //     });
//   //      } else {
//   //   print("Permission denied");
//   //   }
//   // }

//   // Future<void> _stopRecording() async {
//   //   await _recorder.stop();
//   //   setState(() {
//   //     _isRecording = false;
//   //   });
//   //   _timer?.cancel(); // Cancel the timer if recording is stopped manually
//   //   if (_filePath != null) {
//   //     _uploadToFirebase(_filePath!);
//   //   }
//   // }

//   // Future<void> _uploadToFirebase(String filePath) async {
//   //   File file = File(filePath);
//   //   try {
//   //     final storageRef =
//   //         FirebaseStorage.instance.ref().child('recordings/audio.m4a');
//   //     await storageRef.putFile(file);
//   //     String downloadUrl = await storageRef.getDownloadURL();
//   //     print("Download URL: $downloadUrl");
//   //   } catch (e) {
//   //     print("Error uploading: $e");
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Audio Recorder")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _isRecording ? null : _startRecording,
//           child: Text(_isRecording ? "Recording...." : "Start Recording"),
//         ),
//       ),
//     );
//   }
// }

// myself

// import 'dart:io';
// import 'package:path/path.dart' as p;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
// import 'package:audioplayers/audioplayers.dart';

// class RecordingPage extends StatefulWidget {
//   const RecordingPage({super.key});
//   @override
//   State<RecordingPage> createState() => _RecordingPage();
// }

// class _RecordingPage extends State<RecordingPage> {
//   final AudioRecorder audiorecorder = AudioRecorder();
//   final AudioPlayer audioPlayer = AudioPlayer();
//   bool isRecording = false, isPlaying = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: _recordingButton(),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return SizedBox(
//       width: MediaQuery.sizeOf(context).width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (recordingPath != null)
//             MaterialButton(
//               onPressed: () async {
//                 if (audioPlayer.playing) {
//                   audioPlayer.stop();
//                   setState(() {
//                     isPlaying = false;
//                   });
//                 } else {
//                   await audioPlayer.setFilePath(recordingPath!);
//                   audioPlayer.play();
//                   setState(() {
//                     isPlaying = true;
//                   });
//                 }
//               },
//               color: Theme.of(context).colorScheme.primary,
//               child: Text(
//                 isPlaying
//                     ? "Stop playing Recording"
//                     : "Start Playing Recording ",
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           if (recordingPath == null) const Text("No Recording Found:(")
//         ],
//       ),
//     );

//   }

//   Widget _recordingButton() {
//     return FloatingActionButton(
//         onPressed: () async {
//           if (isRecording) {
//             String? filePath = await audioRecorder.stop();
//             if (filePath != null) {
//               setState(() {
//                 isRecording = false;
//                 recordingPath = filePath;
//               });
//             }
//           } else {
//             if (await audioRecorder.hasPermission()) {
//               final Directory appDocumentDir =
//                   await getApplicationDocumentsDirectory();
//               final String filePath =
//               p.join(appDocumentsDir, "recording.wav");
//               await audiorecorder.start(
//                 const RecordConfig(),
//                 path: filePath,
//               );
//               setState(() {
//                 isRecording = true;
//                 recordingPath = null;
//               });
//             }
//           }
//         },
//         child: Icon(isRecording ? Icons.stop : Icons.mic));
//   }
// }

// // class AudioRecorder {}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  String? recordingPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recordingButton(),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (recordingPath != null)
            MaterialButton(
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.stop();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  await audioPlayer.play(DeviceFileSource(recordingPath!));
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                isPlaying
                    ? "Stop Playing Recording"
                    : "Start Playing Recording",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (recordingPath == null) const Text("No Recording Found :("),
        ],
      ),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          String? filePath = await audioRecorder.stop();
          if (filePath != null) {
            setState(() {
              isRecording = false;
              recordingPath = filePath;
            });
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            final Directory appDocumentsDir =
                await getApplicationDocumentsDirectory();
            final String filePath =
                p.join(appDocumentsDir.path, "recording.wav");
            await audioRecorder.start(
              const RecordConfig(),
              path: filePath,
            );
            setState(() {
              isRecording = true;
              recordingPath = null;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: RecordingPage(),
  ));
}
