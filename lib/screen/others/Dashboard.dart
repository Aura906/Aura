import 'package:aura/screen/AuthScreens/LoginScreen.dart';
import 'package:aura/screen/others/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const Dashboard({required this.userId, required this.userData, Key? key})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late double height, width;
  bool isNotSafe = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  String userName = "Loading...";
  String? email;
  String? phonenumber;
  String? gender;
  List<Map<String, dynamic>> kycDetails = [];
  List<Map<String, dynamic>> safetyDetails = [];

  List<String> imageSource = [
    "images/sos-button.png",
    "images/panic1.png",
    "images/camera.png",
    "images/location.png",
  ];
  List<String> dataTitle = ["SOS", "PANIC", "CAMERA", "LOCATION"];

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      // Fetch user document
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(widget.userId).get();

      // Fetch all documents from KYCData subcollection
      QuerySnapshot kycSnapshot = await firestore
          .collection('users')
          .doc(widget.userId)
          .collection("KYCData")
          .get();

      // Fetch all documents from SafetyInformation subcollection
      QuerySnapshot safetySnapshot = await firestore
          .collection('users')
          .doc(widget.userId)
          .collection("SafetyInformation")
          .get();

      // Process User Data
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      // Process KYC Data
      List<Map<String, dynamic>> kycData = kycSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Process Safety Information Data
      List<Map<String, dynamic>> safetyData = safetySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Update state
      setState(() {
        userName = userData?['name'] ?? 'User';
        email = userData?['email'] ?? 'example@gmail.com';
        gender = userData?['gender'] ?? 'gender';
        phonenumber = userData?['phoneNumber'] ?? '999999999';

        // Save fetched KYC & Safety Info data
        kycDetails = kycData;
        safetyDetails = safetyData;
      });

      print("User Data: $userName");
      print("KYC Data: $kycData");
      print("Safety Data: $safetyData");
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isNotSafe ? Colors.redAccent : const Color(0xFFF8D1D1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Dashboard',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: const Icon(Icons.sort, color: Colors.white, size: 30),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => ProfileScreen(
                  userId: widget.userId, userData: widget.userData));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.userData['profileImage'] ??
                    'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png'),
              ),
            ),
          ),
        ],
      ),
      // drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            _buildTopSection(),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 25,
                ),
                itemCount: imageSource.length,
                itemBuilder: (context, index) {
                  return _buildFeatureButton(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDrawer() {
  //   return Drawer(
  //     child: Container(
  //       color: const Color(0xFFF1E6E6),
  //       child: ListView(
  //         padding: EdgeInsets.zero,
  //         children: [
  //           DrawerHeader(
  //             padding: EdgeInsets.zero,
  //             child: Container(
  //               decoration: const BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [Color(0xFFF9A8D4), Color(0xFFFFC0CB)],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //               ),
  //               padding: const EdgeInsets.all(20),
  //               child: Row(
  //                 children: [
  //                   const CircleAvatar(
  //                     radius: 40,
  //                     backgroundImage: NetworkImage(
  //                       'https://purepng.com/public/uploads/large/purepng.com-female-studentstudentcollege-studentschool-studentfemale-student-14215269231647tn6r.png',
  //                     ),
  //                   ),
  //                   const SizedBox(width: 15),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         userName,
  //                         style: const TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       const Text(
  //                         'abc@gmail.com',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.white70,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           ...dataTitle
  //               .map((title) => _buildDrawerItem(Icons.dashboard, title, () {}))
  //               .toList(),
  //           const Divider(),
  //           _buildDrawerItem(Icons.logout, "Logout", _logout),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$userName 😊",
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("$email", style: const TextStyle(fontSize: 15)),
          const Text("Are You Safe?", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          // ...kycDetails
          //     .map((kyc) => Text("KYC ID: ${kyc['idNumber'] ?? 'N/A'}")),
          // ...kycDetails.map((kyc) => Text("KYC ID: ${kyc['idType'] ?? 'N/A'}")),
          // ...safetyDetails.map(
          //     (safety) => Text("Blood Type: ${safety['bloodType'] ?? 'N/A'}")),
          // ...safetyDetails.map((safety) =>
          //     Text("Blood Type: ${safety['emergencyContacts'] ?? 'N/A'}")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isNotSafe = !isNotSafe;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isNotSafe ? Colors.red : Colors.green,
            ),
            child: Text(isNotSafe ? "I am Not Safe" : "I am Safe"),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black26, spreadRadius: 1, blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageSource[index], width: 100),
            Text(dataTitle[index],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.pinkAccent),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
