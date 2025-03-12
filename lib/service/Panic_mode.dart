// import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:record/record.dart' as record;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart'; // Add for sharing

// class PanicModeService {
//   final String userId;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final record.AudioRecorder _recorder = record.AudioRecorder();
//   Position? _currentPosition;
//   Timer? _locationTimer;
//   String? _audioFilePath;
//   bool _isPanicModeActive = false;

//   PanicModeService(this.userId);

//   Future<void> _requestPermissions(BuildContext context) async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.locationAlways,
//       Permission.microphone,
//       Permission.storage,
//     ].request();

//     if (!statuses[Permission.locationAlways]!.isGranted ||
//         !statuses[Permission.microphone]!.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content:
//                 Text("Permissions denied. Panic Mode may not work fully.")),
//       );
//     }
//   }

//   Future<void> activatePanicMode(BuildContext context) async {
//     if (_isPanicModeActive) return;

//     _isPanicModeActive = true;
//     await _requestPermissions(context);

//     await _playAlarm();
//     await _startAudioRecording(context);
//     await _startLocationSharing();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Panic Mode Activated")),
//     );
//   }

//   Future<void> deactivatePanicMode(BuildContext context) async {
//     if (!_isPanicModeActive) return;

//     _isPanicModeActive = false;
//     await _stopAlarm();
//     await _stopAudioRecording(context);
//     _stopLocationSharing();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Panic Mode Deactivated")),
//     );
//   }

//   Future<void> _playAlarm() async {
//     try {
//       await _audioPlayer.play(AssetSource('sounds/sound_alert.mp3'),
//           volume: 1.0);
//       Timer(Duration(seconds: 30), () async {
//         if (_isPanicModeActive) await _audioPlayer.stop();
//       });
//     } catch (e) {
//       print("Error playing alarm: $e");
//     }
//   }

//   Future<void> _stopAlarm() async {
//     try {
//       await _audioPlayer.stop();
//     } catch (e) {
//       print("Error stopping alarm: $e");
//     }
//   }

//   Future<void> _startAudioRecording(BuildContext context) async {
//     try {
//       if (await _recorder.hasPermission()) {
//         final directory = await getExternalStorageDirectory();
//         _audioFilePath =
//             '${directory?.path}/panic_${DateTime.now().millisecondsSinceEpoch}.m4a';
//         await _recorder.start(const record.RecordConfig(),
//             path: _audioFilePath!);
//         print("Audio recording started: $_audioFilePath");

//         // Stop recording after 3 minutes and send to WhatsApp
//         Timer(Duration(minutes: 3), () async {
//           if (await _recorder.isRecording()) {
//             await _stopAudioRecording(context);
//           }
//         });
//       } else {
//         print("Microphone permission denied");
//       }
//     } catch (e) {
//       print("Error starting audio recording: $e");
//     }
//   }

//   Future<void> _stopAudioRecording(BuildContext context) async {
//     try {
//       if (await _recorder.isRecording()) {
//         await _recorder.stop();
//         print("Audio recording stopped: $_audioFilePath");
//         await _uploadAudioToFirestore();
//         await _sendToWhatsApp(context); // Send to WhatsApp
//       }
//     } catch (e) {
//       print("Error stopping audio recording: $e");
//     }
//   }

//   Future<void> _startLocationSharing() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         print("Location services disabled");
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return;
//       }

//       _currentPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       _shareLocation();

//       _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
//         if (!_isPanicModeActive) {
//           timer.cancel();
//           return;
//         }
//         _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         _shareLocation();
//       });
//     } catch (e) {
//       print("Error sharing location: $e");
//     }
//   }

//   void _stopLocationSharing() {
//     _locationTimer?.cancel();
//     _locationTimer = null;
//   }

//   Future<void> _shareLocation() async {
//     if (_currentPosition == null) return;

//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('SafetyInformation')
//           .doc('panic_${DateTime.now().millisecondsSinceEpoch}')
//           .set({
//         'timestamp': FieldValue.serverTimestamp(),
//         'latitude': _currentPosition!.latitude,
//         'longitude': _currentPosition!.longitude,
//         'type': 'panic_location',
//       });
//       print(
//           "Location shared: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");
//     } catch (e) {
//       print("Error sharing location: $e");
//     }
//   }

//   Future<void> _uploadAudioToFirestore() async {
//     if (_audioFilePath == null) return;

//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('SafetyInformation')
//           .doc('audio_${DateTime.now().millisecondsSinceEpoch}')
//           .set({
//         'timestamp': FieldValue.serverTimestamp(),
//         'audio_path': _audioFilePath,
//         'type': 'panic_audio',
//       });
//       print("Audio file logged: $_audioFilePath");
//     } catch (e) {
//       print("Error uploading audio: $e");
//     }
//   }

//   Future<void> _sendToWhatsApp(BuildContext context) async {
//     if (_currentPosition == null || _audioFilePath == null) {
//       print("Location or audio file missing");
//       return;
//     }

//     try {
//       // Fetch emergency contacts from Firestore
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//       Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
//       List<dynamic> contacts = userData?['contacts'] ?? [];

//       if (contacts.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("No emergency contacts found")),
//         );
//         return;
//       }

//       // Construct message with location
//       String locationUrl =
//           "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},${_currentPosition!.longitude}";
//       String message = "Emergency! My location: $locationUrl";

//       // Share to WhatsApp for each contact
//       for (var contact in contacts) {
//         String phoneNumber =
//             contact['phone'].replaceAll(RegExp(r'[^0-9+]'), '');
//         await Share.shareXFiles(
//           [XFile(_audioFilePath!)], // Share audio file
//           text: message,
//           subject: "Emergency Alert",
//           sharePositionOrigin:
//               Rect.fromLTWH(0, 0, 30, 12 / 2), // Optional: position for iPad
//           // Specify WhatsApp as the target (works if WhatsApp is installed)
//           // Note: This opens WhatsApp with the file pre-selected
//         );
//         print("Shared to WhatsApp: $phoneNumber");
//       }

//       print("Sent location and audio to WhatsApp contacts");
//     } catch (e) {
//       print("Error sending to WhatsApp: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send to WhatsApp: $e")),
//       );
//     }
//   }

//   bool get isPanicModeActive => _isPanicModeActive;

//   void dispose() {
//     _audioPlayer.dispose();
//     _locationTimer?.cancel();
//     _recorder.stop();
//     _recorder.dispose();
//   }
// }
