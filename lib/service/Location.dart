import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Position? _position;
  late bool servicePermission = false;
  late LocationPermission permission;
//
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

//
  String _currentAddress = "";
//
  String _storedAddress = "Fetching...";
//

  // /// ✅ Fetch stored location when the page loads
  @override
  void initState() {
    super.initState();
    _fetchStoredLocation();
  }

  //
  _storeLocationInFirebase() async {
    try {
      User? user = _auth.currentUser; // Get logged-in user
      if (user != null && _position != null) {
        String userId = user.uid; // Get user ID

        // Create reference path inside locationDetails
        DatabaseReference ref = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userId)
            .child("locationDetails");

        // Store location data
        await ref.set({
          "latitude": _position!.latitude,
          "longitude": _position!.longitude,
          "address": _currentAddress, // Optional
          "timestamp": DateTime.now().toString(),
        });

        print(
            "Location stored successfully in Firebase under locationDetails!");
      } else {
        print("User not logged in or position is null.");
      }
    } catch (error) {
      print("Error storing location: $error");
    }
  }

  //

  Future<Position> _getCurrentPosition() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service Disable");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position!.latitude, _position!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "locality :  ${place.locality} , Country : ${place.country} , subThoroughfare:  ${place.subThoroughfare},street: ${place.street}, street :${place.street}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.postalCode}";
      });

      /// ✅ Save to Firebase
      if (userId != null) {
        _dbRef.child('users').child(userId!).child('location').set({
          "latitude": _position!.latitude,
          "longitude": _position!.longitude,
          "locality": place.locality,
          "country": place.country,
          "street": place.street,
          "state": place.administrativeArea,
          "district": place.subAdministrativeArea,
          "postalCode": place.postalCode,
        }).then((_) {
          print("✅ Location saved to Firebase!");
        }).catchError((error) {
          print("❌ Failed to save location: $error");
        });
      } else {
        print("❌ User not logged in!");
      }
    }
//
    catch (e) {
      print(e);
    }
  }

  void _fetchStoredLocation() {
    if (userId != null) {
      _dbRef
          .child('users')
          .child(userId!)
          .child('location')
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          setState(() {
            _storedAddress =
                "Latitude: ${data['latitude']}, Longitude: ${data['longitude']}\n"
                "Locality: ${data['locality']}, Street: ${data['street']}, "
                "State: ${data['state']}, Postal Code: ${data['postalCode']}";
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Tracker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "location coordinates",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 6,
            ),
            Text("Coordinates"),
            SizedBox(
              height: 6,
            ),
            Text(
              "latitude = ${_position?.latitude} and longitude = ${_position?.longitude} and",
              // style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),

            Text("${_currentAddress}"),
            ElevatedButton(
              onPressed: () async {
                _position = await _getCurrentPosition();
                await _getAddressFromCoordinates();
                await _storeLocationInFirebase();
                print("${_position}");
                print("${_currentAddress}");
              },
              child: Text("get location"),
            ),
//

//
          ],
        ),
      ),
    );
  }
}
