import 'package:aura/screen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAN3f0Vv3-pQ9bcFHSs8TdhH3PUiNZiIps",
            authDomain: "aura-f3b37.firebaseapp.com",
            projectId: "aura-f3b37",
            storageBucket: "aura-f3b37.firebasestorage.app",
            messagingSenderId: "259950013463",
            appId: "1:259950013463:web:b55bfc35a22adbc793c052",
            measurementId: "G-ERXP1BLQVX"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aurasecure',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
