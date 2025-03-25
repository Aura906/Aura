import 'package:audioplayers/audioplayers.dart';
import 'package:aura/screen/others/AuraSecureLogo.dart';
import 'package:aura/screen/others/ProfileScreen.dart';
// import 'package:aura/service/Panic_mode.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';

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

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DatabaseReference? _panicModeRef;
  bool isUpdatingPanicMode = false;
  String userName = "Loading...";
  String? email;
  String? phoneNumber;
  String? gender;
  bool isPlaying = false;

  List<Map<String, dynamic>> kycDetails = [];
  List<Map<String, dynamic>> safetyDetails = [];

  late AudioPlayer player; // Made instance variable

  final List<Map<String, dynamic>> featureItems = [
    {
      "title": "SOS Alert",
      "icon": "images/sos-button.png",
      "color": Colors.red
    },
    {
      "title": "Panic Mode",
      "icon": "images/panic1.png",
      "color": Colors.orange
    },
    {"title": "Live Camera", "icon": "images/camera.png", "color": Colors.blue},
    {
      "title": "Share Location",
      "icon": "images/location.png",
      "color": Colors.purple
    },
  ];

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _setupAudio();
    fetchUserDetails();

    // Initialize Realtime Database reference
    _panicModeRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(widget.userId)
        .child('panicMode');

    // Listen to real-time updates
    _setupPanicModeListener();
  }

  Future<void> _setupAudio() async {
    try {
      await player.setSource(AssetSource('sound_alert.mp3'));
      await player.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print("Error setting up audio: $e");
    }
  }

  void _setupPanicModeListener() {
    if (_panicModeRef != null) {
      _panicModeRef!.onValue.listen((event) {
        final value = event.snapshot.value;
        if (value != null && mounted) {
          final panicState = value == 1;
          setState(() {
            isPlaying = panicState;
          });
          // Sync audio with database state
          if (panicState) {
            player.resume();
          } else {
            player.stop();
          }
        }
      }, onError: (error) {
        print("Error listening to panic mode: $error");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error syncing panic mode: $error')),
          );
        }
      });
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(widget.userId).get();
      QuerySnapshot kycSnapshot = await firestore
          .collection('users')
          .doc(widget.userId)
          .collection("KYCData")
          .get();
      QuerySnapshot safetySnapshot = await firestore
          .collection('users')
          .doc(widget.userId)
          .collection("SafetyInformation")
          .get();

      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      List<Map<String, dynamic>> kycData = kycSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      List<Map<String, dynamic>> safetyData = safetySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (mounted) {
        setState(() {
          userName = userData?['name'] ?? 'User';
          email = userData?['email'] ?? 'example@gmail.com';
          gender = userData?['gender'] ?? 'Not specified';
          phoneNumber = userData?['phoneNumber'] ?? 'Not provided';
          kycDetails = kycData;
          safetyDetails = safetyData;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isNotSafe
                ? [Colors.red[900]!, Colors.red[400]!]
                : [Colors.pink[100]!, Colors.purple[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        FadeInDown(child: _buildWelcomeSection()),
                        const SizedBox(height: 20),
                        FadeInUp(child: _buildSafetyGrid()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: isNotSafe ? Colors.white : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AuraSecureLogo(
            size: 60,
            showShadow: true,
          ),
          ZoomIn(
            child: InkWell(
              onTap: () => Get.to(() => ProfileScreen(
                  userId: widget.userId, userData: widget.userData)),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.userData['profileImage'] ??
                        'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Welcome, $userName 👋",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your safety is our priority",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 15),
          const Text(
            "Current Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() => isNotSafe = !isNotSafe);
              if (isNotSafe) {
                _showSafetyAlertDialog();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isNotSafe ? Colors.red[700] : Colors.green[600],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              isNotSafe ? "HELP! I'M IN DANGER" : "I'M SAFE",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: featureItems.length,
      itemBuilder: (context, index) {
        return ElasticIn(
          child: _buildFeatureCard(
            featureItems[index]['title'],
            featureItems[index]['icon'],
            featureItems[index]['color'],
            index,
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(String title, String icon, Color color, int index) {
    return GestureDetector(
      onTap: () => _handleFeatureTap(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Image.asset(icon, width: 50),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleFeatureTap(int index) {
    switch (index) {
      case 0: // SOS Alert
        _sendSOSAlert();
        break;
      case 1: // Panic Mode
        _activatePanicMode();
        break;
      case 2: // Live Camera
        _startLiveCamera();
        break;
      case 3: // Share Location
        _shareLocation();
        break;
    }
  }

  void _showSafetyAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:
            Text("Emergency Alert", style: TextStyle(color: Colors.red[800])),
        content: const Text(
          "Would you like to notify your emergency contacts and local authorities?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _sendEmergencyNotification();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            child: const Text("Yes, Send Help"),
          ),
        ],
      ),
    );
  }

  void _sendSOSAlert() {
    print("SOS Alert triggered");
  }

  // void _activatePanicMode() async {
  //   try {
  //     if (isPlaying) {
  //       await player.stop();
  //       isNotSafe = false;
  //     } else {
  //       await player.resume();
  //       isNotSafe = true;
  //     }
  //     setState(() {
  //       isPlaying = !isPlaying;
  //     });
  //     // if (!isPlaying) {
  //     //   Get.to(() => const PanicMode());
  //     // }
  //   } catch (e) {
  //     print("Error in panic mode: $e");
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error in panic mode: $e')),
  //       );
  //     }
  //   }
  // }

  void _activatePanicMode() async {
    if (isUpdatingPanicMode) return; // Prevent multiple simultaneous updates

    try {
      setState(() => isUpdatingPanicMode = true);

      if (isPlaying) {
        await player.stop();
        isNotSafe = false;
        await _panicModeRef!.set(0);
      } else {
        await player.resume();
        isNotSafe = true;
        await _panicModeRef!.set(1);
      }

      if (mounted) {
        setState(() {
          isPlaying = !isPlaying;
          isUpdatingPanicMode = false;
        });
      }

      // if (!isPlaying) {
      //   Get.to(() => const PanicMode());
      // }
    } catch (e) {
      print("Error updating panic mode: $e");
      if (mounted) {
        setState(() => isUpdatingPanicMode = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating panic mode: $e')),
        );
      }
    }
  }

  void _startLiveCamera() {
    print("Live Camera started");
  }

  void _shareLocation() {
    print("Location shared");
  }

  void _sendEmergencyNotification() {
    print("Emergency notification sent");
  }
}
