// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfileScreen extends StatefulWidget {
//   final String userId;
//   final Map<String, dynamic> userData;

//   const ProfileScreen({required this.userId, required this.userData, Key? key})
//       : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late String userName, email, phoneNumber, gender, profileImage;
//   List<Map<String, dynamic>> kycDetails = [];
//   List<Map<String, dynamic>> safetyDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   void loadUserData() {
//     userName = widget.userData['name'] ?? 'User';
//     email = widget.userData['email'] ?? 'example@gmail.com';
//     phoneNumber = widget.userData['phoneNumber'] ?? '9999999999';
//     gender = widget.userData['gender'] ?? 'Not Specified';
//     profileImage = widget.userData['profileImage'] ??
//         'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png';

//     kycDetails =
//         List<Map<String, dynamic>>.from(widget.userData['kycDetails'] ?? []);
//     safetyDetails =
//         List<Map<String, dynamic>>.from(widget.userData['safetyDetails'] ?? []);
//   }

//   void _logout() async {
//     await FirebaseAuth.instance.signOut();
//     Get.offAllNamed('/login'); // Redirect to login screen
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         backgroundColor: Colors.pinkAccent,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Profile Picture
//             Center(
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundImage: NetworkImage(profileImage),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               userName,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text(email,
//                 style: const TextStyle(fontSize: 16, color: Colors.grey)),
//             const SizedBox(height: 20),

//             // User Information
//             _buildInfoTile(Icons.phone, "Phone Number", phoneNumber),
//             _buildInfoTile(Icons.person, "Gender", gender),

//             // KYC Details
//             const SizedBox(height: 20),
//             const Text("KYC Details",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ...kycDetails.map((kyc) => _buildInfoTile(
//                 Icons.credit_card, "KYC ID", kyc['idNumber'] ?? 'N/A')),

//             // Safety Information
//             const SizedBox(height: 20),
//             const Text("Safety Information",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ...safetyDetails.map((safety) => _buildInfoTile(
//                 Icons.local_hospital,
//                 "Blood Type",
//                 safety['bloodType'] ?? 'N/A')),
//             ...safetyDetails.map((safety) => _buildInfoTile(Icons.contacts,
//                 "Emergency Contacts", safety['emergencyContacts'] ?? 'N/A')),

//             const SizedBox(height: 20),

//             // Edit Profile Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 Get.toNamed('/editProfile', arguments: widget.userData);
//               },
//               icon: const Icon(Icons.edit),
//               label: const Text("Edit Profile"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//             ),

//             const SizedBox(height: 10),

//             // Logout Button
//             ElevatedButton.icon(
//               onPressed: _logout,
//               icon: const Icon(Icons.logout),
//               label: const Text("Logout"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoTile(IconData icon, String title, String value) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.pinkAccent),
//         title: Text(title,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         subtitle: Text(value,
//             style: const TextStyle(fontSize: 14, color: Colors.grey)),
//       ),
//     );
//   }
// }

// import 'package:aura/screen/others/KYCFormWithID.dart';
// import 'package:aura/screen/others/SafetyInformationForm.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatefulWidget {
//   final String userId;
//   final Map<String, dynamic> userData;

//   const ProfileScreen({required this.userId, required this.userData, Key? key})
//       : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController nationalityController = TextEditingController();

// bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

// Future<void> _fetchUserData() async {
//     try {
//       DocumentSnapshot userDoc =
//           await firestore.collection('users').doc(widget.userId).get();

//       if (userDoc.exists) {
//         Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
//         if (data != null) {
//           fullNameController.text = data['name'] ?? '';
//           emailController.text = data['email'] ?? '';
//           phoneNumberController.text = data['phoneNumber'] ?? '';
//         }
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

// // Create a reference to the KYC subcollection under the user
//       CollectionReference kycCollection = firestore
//           .collection('users')
//           .doc(widget.userId)
//           .collection('KYCData');

//       // Add the KYC details
//       await kycCollection.add({
//         'fullName': fullNameController.text,
//         'dob': dobController.text,
//         'phoneNumber': phoneNumberController.text,
//         'email': emailController.text,
//         'address': addressController.text,
//         // 'emergencyContact': emergencyContactController.text,
//         'nationality': nationalityController.text,

//       });

//       Get.snackbar(
//         "Success",
//         "KYC data submitted successfully!",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );

//  @override
//   void dispose() {
//     fullNameController.dispose();
//     dobController.dispose();
//     phoneNumberController.dispose();
//     emailController.dispose();
//     addressController.dispose();
//     // emergencyContactController.dispose();
//     nationalityController.dispose();
//   }

//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('KYC Form with ID Proof'),
//         centerTitle: true,
//         backgroundColor: Colors.pinkAccent,
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Get.to(SafetyInformationForm());
//             },
//             child: const Text(
//               'Skip',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Personal Details',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     buildInputField(
//                         fullNameController, 'Enter Your Full Name', null,
//                         noneeditable: true, validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your full name';
//                       }
//                       return null;
//                     }),

//                       buildInputField(
//                         dobController, 'Enter Date of Birth (DD/MM/YYYY)', null,
//                         validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your date of birth';
//                       }
//                       return null;
//                     }),
//                     buildInputField(
//                         phoneNumberController, 'Enter Phone Number', null,
//                         noneeditable: true, validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }
//                       return null;
//                     }),
//                     buildInputField(
//                         emailController, 'Enter Email Address', null,
//                         validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email address';
//                       }
//                       return null;
//                     }),
//                     buildInputField(
//                         addressController, 'Enter Residential Address', null,
//                         validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your address';
//                       }
//                       return null;
//                     }),

//                     buildInputField(
//                         nationalityController, 'Enter Nationality', null,
//                         validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your nationality';
//                       }
//                       return null;
//                     }),

//                 ),
//               ),

// import 'package:aura/screen/others/KYCFormWithID.dart';
// import 'package:aura/screen/others/SafetyInformationForm.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatefulWidget {
//   final String userId;
//   final Map<String, dynamic> userData;

//   const ProfileScreen({required this.userId, required this.userData, Key? key})
//       : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController nationalityController = TextEditingController();

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   Future<void> _fetchUserData() async {
//     try {
//       DocumentSnapshot userDoc =
//           await firestore.collection('users').doc(widget.userId).get();

//       if (userDoc.exists) {
//         Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
//         if (data != null) {
//           fullNameController.text = data['name'] ?? '';
//           emailController.text = data['email'] ?? '';
//           phoneNumberController.text = data['phoneNumber'] ?? '';
//         }
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _submitKYCData() async {
//     try {
//       CollectionReference kycCollection = firestore
//           .collection('users')
//           .doc(widget.userId)
//           .collection('KYCData');

//       await kycCollection.add({
//         'fullName': fullNameController.text,
//         'dob': dobController.text,
//         'phoneNumber': phoneNumberController.text,
//         'email': emailController.text,
//         'address': addressController.text,
//         'nationality': nationalityController.text,
//       });

//       Get.snackbar(
//         "Success",
//         "KYC data submitted successfully!",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       print("Error submitting KYC data: $e");
//     }
//   }

//   @override
//   void dispose() {
//     fullNameController.dispose();
//     dobController.dispose();
//     phoneNumberController.dispose();
//     emailController.dispose();
//     addressController.dispose();
//     nationalityController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.pinkAccent,
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Get.to(SafetyInformationForm());
//             },
//             child: const Text(
//               'Edit',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Personal Details',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     buildInputField(
//                       fullNameController,
//                       'Enter Your Full Name',
//                       null,
//                       noneeditable: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your full name';
//                         }
//                         return null;
//                       },
//                     ),
//                     buildInputField(
//                       dobController,
//                       'Enter Date of Birth (DD/MM/YYYY)',
//                       null,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your date of birth';
//                         }
//                         return null;
//                       },
//                     ),
//                     buildInputField(
//                       phoneNumberController,
//                       'Enter Phone Number',
//                       null,
//                       noneeditable: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     buildInputField(
//                       emailController,
//                       'Enter Email Address',
//                       null,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email address';
//                         }
//                         return null;
//                       },
//                     ),
//                     buildInputField(
//                       addressController,
//                       'Enter Residential Address',
//                       null,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your address';
//                         }
//                         return null;
//                       },
//                     ),
//                     buildInputField(
//                       nationalityController,
//                       'Enter Nationality',
//                       null,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your nationality';
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatefulWidget {
//   final String userId;
//   final Map<String, dynamic> userData;

//   const ProfileScreen({required this.userId, required this.userData, Key? key})
//       : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController nationalityController = TextEditingController();

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   Future<void> _fetchUserData() async {
//     try {
//       DocumentSnapshot userDoc =
//           await firestore.collection('users').doc(widget.userId).get();

//       if (userDoc.exists) {
//         Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
//         if (data != null) {
//           fullNameController.text = data['name'] ?? '';
//           phoneNumberController.text = data['phoneNumber'] ?? '';
//         }
//       }

//       QuerySnapshot kycDocs = await firestore
//           .collection('users')
//           .doc(widget.userId)
//           .collection('KYCData')
//           .get();

//       if (kycDocs.docs.isNotEmpty) {
//         Map<String, dynamic> kycData =
//             kycDocs.docs.first.data() as Map<String, dynamic>;
//         emailController.text = kycData['email'] ?? '';
//         addressController.text = kycData['address'] ?? '';
//         nationalityController.text = kycData['nationality'] ?? '';
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.pinkAccent,
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'Edit',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildInputField(fullNameController, 'Full Name', true),
//                     buildInputField(
//                         phoneNumberController, 'Phone Number', true),
//                     buildInputField(emailController, 'Email', true),
//                     buildInputField(
//                         addressController, 'Residential Address', true),
//                     buildInputField(nationalityController, 'Nationality', true),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget buildInputField(
//       TextEditingController controller, String label, bool readOnly) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: TextFormField(
//         controller: controller,
//         readOnly: readOnly,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const ProfileScreen({required this.userId, required this.userData, Key? key})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(widget.userId).get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          fullNameController.text = data['name'] ?? '';
          phoneNumberController.text = data['phoneNumber'] ?? '';
          // idNumberController.text = data['idNumber'] ?? '';
        }
      }

      QuerySnapshot kycDocs = await firestore
          .collection('users')
          .doc(widget.userId)
          .collection('KYCData')
          .get();

      if (kycDocs.docs.isNotEmpty) {
        Map<String, dynamic> kycData =
            kycDocs.docs.first.data() as Map<String, dynamic>;
        emailController.text = kycData['email'] ?? '';
        addressController.text = kycData['address'] ?? '';
        nationalityController.text = kycData['nationality'] ?? '';
        idNumberController.text = kycData['aadharCardID'] ?? '';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,

                          backgroundImage: NetworkImage(widget
                                  .userData['profileImage'] ??
                              'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG.png'),
                          // backgroundImage: const AssetImage(
                          //     'assets/profile_placeholder.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pinkAccent,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 20),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField(fullNameController, 'Full Name', true),
                  _buildProfileField(
                      phoneNumberController, 'Phone Number', true),
                  _buildProfileField(emailController, 'Email', true),
                  _buildProfileField(
                      addressController, 'Residential Address', true),
                  _buildProfileField(
                      nationalityController, 'Nationality', true),
                  _buildProfileField(idNumberController, 'idNumber', true),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileField(
      TextEditingController controller, String label, bool readOnly) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          // prefixIcon: Icon(
          //   label == 'Full Name'
          //       ? Icons.person
          //       : label == 'Phone Number'
          //           ? Icons.phone
          //           : label == 'Email'
          //               ? Icons.email
          //               : label == 'Residential Address'
          //                   ? Icons.home
          //                   : Icons.language,
          //   color: Colors.pinkAccent,
          // ),
        ),
      ),
    );
  }
}
