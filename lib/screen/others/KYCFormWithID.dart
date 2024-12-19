import 'dart:io';
import 'package:aura/screen/others/SafetyInformationForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KYCFormWithID extends StatefulWidget {
  final String userId;

  KYCFormWithID({required this.userId});

  @override
  _KYCFormWithIDState createState() => _KYCFormWithIDState();
}

class _KYCFormWithIDState extends State<KYCFormWithID> {
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();
  final TextEditingController nationalityController = TextEditingController();

  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController issueDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController issuingCountryController =
      TextEditingController();

  String selectedIDType = 'Passport';
  File? idProof;
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
          emailController.text = data['email'] ?? '';
          phoneNumberController.text = data['phoneNumber'] ?? '';
        }
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
  void dispose() {
    fullNameController.dispose();
    dobController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    emergencyContactController.dispose();
    nationalityController.dispose();
    idNumberController.dispose();
    issueDateController.dispose();
    expiryDateController.dispose();
    issuingCountryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('KYC Form with ID Proof'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton(
            onPressed: () {
              Get.to(SafetyInformationForm());
            },
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    buildInputField(
                        fullNameController, 'Enter Your Full Name', null,
                        noneeditable: true, validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    }),
                    buildInputField(
                        dobController, 'Enter Date of Birth (DD/MM/YYYY)', null,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your date of birth';
                      }
                      return null;
                    }),
                    buildInputField(
                        phoneNumberController, 'Enter Phone Number', null,
                        noneeditable: true, validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    }),
                    buildInputField(
                        emailController, 'Enter Email Address', null,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      return null;
                    }),
                    buildInputField(
                        addressController, 'Enter Residential Address', null,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    }),
                    buildInputField(
                        emergencyContactController,
                        'Enter Emergency Contact Number',
                        null, validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an emergency contact number';
                      }
                      return null;
                    }),
                    buildInputField(
                        nationalityController, 'Enter Nationality', null,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your nationality';
                      }
                      return null;
                    }),
                    const SizedBox(height: 20),
                    const Text(
                      'Government-issued ID Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedIDType,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFedf0f8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Passport', child: Text('Passport')),
                        DropdownMenuItem(
                            value: 'National ID', child: Text('National ID')),
                        DropdownMenuItem(
                            value: 'Driver\'s License',
                            child: Text('Driver\'s License')),
                        DropdownMenuItem(
                            value: 'Aadhaar Card', child: Text('Aadhaar Card')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedIDType = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an ID type';
                        }
                        return null;
                      },
                    ),
                    buildInputField(idNumberController, 'Enter ID Number', null,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID number';
                      }
                      return null;
                    }),
                    buildInputField(
                        issueDateController, 'Enter Issue Date', null,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the issue date';
                      }
                      return null;
                    }),
                    if (selectedIDType == 'Passport' ||
                        selectedIDType == 'Driver\'s License')
                      buildInputField(
                          expiryDateController, 'Enter Expiry Date', null,
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the expiry date';
                        }
                        return null;
                      }),
                    if (selectedIDType == 'Passport')
                      buildInputField(issuingCountryController,
                          'Enter Issuing Country', null, validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the issuing country';
                        }
                        return null;
                      }),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Upload ID Proof'),
                    ),
                    idProof == null
                        ? const Text('No ID Proof Selected')
                        : Text('ID Proof Selected: ${idProof!.path}'),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // Process the form data
                          print('KYC Form Submitted');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 15.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 139, 3, 93),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Next",
                            style: GoogleFonts.comfortaa(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
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
}

Widget buildInputField(
  TextEditingController controller,
  String hintText,
  String? labelText, {
  bool noneeditable = false,
  required String? Function(String?) validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      readOnly: noneeditable,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.comfortaa(
          color: const Color(0xFFb2b7bf),
          fontSize: 18.0,
        ),
        filled: true,
        fillColor: const Color(0xFFedf0f8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    ),
  );
}
