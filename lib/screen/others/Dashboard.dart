import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late double height, width;
  bool isSafe = true;
  bool isNotSafe = false;

  List imageSource = [
    "images/sos-button.png", // SOS button
    "images/panic1.png", // Panic button
    "images/camera.png", // Camera button
    "images/location.png", // Location button
  ];

  List dataTitle = [
    "SOS",
    "PANIC",
    "CAMERA",
    "LOCATION",
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isNotSafe
          ? const Color.fromARGB(255, 248, 105, 95)
          : const Color(0xFFF8D1D1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFF1E6E6),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF9A8D4), Color(0xFFFFC0CB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://purepng.com/public/uploads/large/purepng.com-female-studentstudentcollege-studentschool-studentfemale-student-14215269231647tn6r.png',
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rima Pal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'abc@gmail.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _buildDrawerItem(Icons.person, 'Profile'),
              _buildDrawerItem(Icons.phone, 'SOS'),
              _buildDrawerItem(Icons.warning, 'Panic'),
              _buildDrawerItem(Icons.camera_alt, 'Camera'),
              _buildDrawerItem(Icons.location_on, 'Location'),
              _buildDrawerItem(Icons.logout, 'Log Out'),
            ],
          ),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              // Top section of the dashboard
              Container(
                height: height * 0.2,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Rima", // The name text
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Color.fromARGB(255, 83, 83, 83),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: " 😊", // Emoji added here
                                  style: TextStyle(
                                    fontSize:
                                        30, // Same size as the name text for consistency
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Are You Safe?",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 83, 83, 83),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isNotSafe = !isNotSafe;
                                  });
                                  print(isNotSafe
                                      ? 'I am Not Safe'
                                      : 'I am Safe ');
                                },
                                child: isNotSafe
                                    ? Text(
                                        "I am Not Safe",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Text("I am Safe"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isNotSafe
                                      ? Colors.red
                                      : Colors.green[300],
                                  side: BorderSide(
                                      color: isNotSafe
                                          ? Colors.red
                                          : const Color.fromARGB(
                                              255, 183, 248, 98)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom section with safety features
              Container(
                height: height * 0.67,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  width: width,
                  child: Center(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 25,
                      ),
                      shrinkWrap: true,
                      itemCount: imageSource.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Implement functionality for each feature
                            if (dataTitle[index] == "SOS" ||
                                dataTitle[index] == "PANIC") {
                              // Add functionality for panic and SOS buttons
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  imageSource[index],
                                  width: 100,
                                ),
                                Text(
                                  dataTitle[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ).scrollVertical(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.pinkAccent),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    );
  }
}
