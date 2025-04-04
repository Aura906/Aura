import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Position? _position;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";

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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
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
                  print("${_position}");
                  print("${_currentAddress}");
                },
                child: Text("get location"))
          ],
        ),
      ),
    );
  }
}
