// import 'package:aura/service/RecordingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:aura/service/notification_service.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:aura/screen/splashscreen.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  if (kIsWeb) {
    // Initialize Firebase for Web`
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAN3f0Vv3-pQ9bcFHSs8TdhH3PUiNZiIps",
        authDomain: "aura-f3b37.firebaseapp.com",

        projectId: "aura-f3b37",
        storageBucket:
            "aura-f3b37.appspot.com", // Corrected the storage bucket URL
        messagingSenderId: "259950013463",
        appId: "1:259950013463:web:b55bfc35a22adbc793c052",
        measurementId: "G-ERXP1BLQVX",
      ),
    );
  } else {
    // Initialize Firebase for Mobile
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class DefaultFirebaseOptions {
  static var currentPlatform;
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aurasecure',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => AudioRecorder()),
//       );
//     });

//     return Scaffold(
//       body: Center(child: Text("home page.....")),
//     );
//   }
// }




// // import 'package:flutter/material.dart';
// // import 'package:url_launcher/url_launcher.dart';

// void sendWhatsAppMessage(String phoneNumber, String message) async {
//   String url = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

//   Uri uri = Uri.parse(url); // Convert to Uri format

//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   } else {
//     print("Could not open WhatsApp");
//   }
// }

// class PanicButton extends StatelessWidget {
//   final String trustedPerson;
//   final String alertMessage;

//   // Constructor to accept values
//   const PanicButton({super.key, required this.trustedPerson, required this.alertMessage});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         sendWhatsAppMessage(trustedPerson, alertMessage);
//       },
//       child: const Text("Panic Alert 🚨"),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.red,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(title: const Text("Female Safety App")),
//       body: Center(
//         child: PanicButton(
//           trustedPerson: "+919876543210", // Replace with actual phone number
//           alertMessage: "⚠️ EMERGENCY! I'm in danger. Please help! 📍 Location: http://maps.google.com/?q=latitude,longitude",
//         ),
//       ),
//     ),
//   ));
// }
// }











// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:aura/screen/splashscreen.dart';
// import 'package:flutter/foundation.dart'; // For kIsWeb
// import 'package:url_launcher/url_launcher.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();


//   // Initialize Firebase
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//         apiKey: "AIzaSyAN3f0Vv3-pQ9bcFHSs8TdhH3PUiNZiIps",
//         authDomain: "aura-f3b37.firebaseapp.com",
//         projectId: "aura-f3b37",
//         storageBucket: "aura-f3b37.appspot.com",
//         messagingSenderId: "259950013463",
//         appId: "1:259950013463:web:b55bfc35a22adbc793c052",
//         measurementId: "G-ERXP1BLQVX",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Aurasecure',
//       theme: ThemeData(
//         useMaterial3: true,
//       ),
//       home: SplashScreen(),
//     );
//   }
// }

// // WhatsApp Message Function
// void sendWhatsAppMessage(String phoneNumber, String message) async {
//   String url =
//       "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
//   Uri uri = Uri.parse(url); // Convert to Uri format

//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   } else {
//     print("Could not open WhatsApp");
//   }
// }

// // Panic Button Widget
// class PanicButton extends StatelessWidget {
//   final String trustedPerson;
//   final String alertMessage;

//   // Constructor
//   const PanicButton(
//       {super.key, required this.trustedPerson, required this.alertMessage});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         sendWhatsAppMessage(trustedPerson, alertMessage);
//       },
//       child: const Text("Panic Alert 🚨"),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.red,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       ),
//     );
//   }
// }