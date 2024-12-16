import 'dart:io';
import 'package:aura/screen/others/SafetyInformationForm.dart';
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KYCFormWithID extends StatefulWidget {
  @override
  _KYCFormWithIDState createState() => _KYCFormWithIDState();
}

class _KYCFormWithIDState extends State<KYCFormWithID> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();
  final TextEditingController nationalityController = TextEditingController();

  // Controllers for ID Proof fields
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController issueDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController issuingCountryController =
      TextEditingController();

  String selectedIDType = 'Passport'; // Default selected ID type
  File? idProof;

  // Future<void> _pickIDProof() async {
  //   // Allow multiple file selection with custom file types
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false, // Allow multiple files to be selected
  //     type: FileType.custom, // Custom file type
  //     allowedExtensions: ['jpg', 'pdf', 'doc'], // Supported file extensions
  //   );

  //   // If files are selected
  //   if (result != null) {
  //     setState(() {
  //       // Use the path of the selected file (you can handle multiple files as needed)
  //       idProof = File(result.files.first.path!);
  //     });
  //   }
  // }

  @override
  void dispose() {
    // Dispose all controllers
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
        automaticallyImplyLeading: false, // Remove the default back button
        title: const Text('KYC Form with ID Proof'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton(
            onPressed: () {
              // Skip the form or perform any action here
              Get.to(SafetyInformationForm());
            },
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Full Name
              buildInputField(fullNameController, 'Enter Your Full Name', null,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return "null";
              }),

              // Date of Birth
              buildInputField(
                  dobController, 'Enter Date of Birth (DD/MM/YYYY)', null,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your date of birth';
                }
                return " null";
              }),

              // Phone Number
              buildInputField(phoneNumberController, 'Enter Phone Number', null,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return " Please enter a valid phone number";
              }),

              // Email Address
              buildInputField(emailController, 'Enter Email Address', null,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                return " Please enter a valid email address";
              }),

              // Address
              buildInputField(
                  addressController, 'Enter Residential Address', null,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return " Please enter your address";
              }),

              // Emergency Contact
              buildInputField(emergencyContactController,
                  'Enter Emergency Contact Number', null, validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an emergency contact number';
                }
                return " Please enter a valid phone number";
              }),

              // Nationality
              buildInputField(nationalityController, 'Enter Nationality', null,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your nationality';
                }
                return " Nationality: $value";
              }),

              const SizedBox(height: 20),
              const Text(
                'Government-issued ID Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Dropdown for selecting ID type
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
                  DropdownMenuItem(value: 'Passport', child: Text('Passport')),
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

              // ID Number
              buildInputField(idNumberController, 'Enter ID Number', null,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your ID number';
                }
                return " Invalid ID number";
              }),

              // Issue Date
              buildInputField(issueDateController, 'Enter Issue Date', null,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter issue date';
                }
                return " Please enter issue date in YYYY-MM-DD format";
              }),

              // Expiry Date (conditionally displayed)
              if (selectedIDType == 'Passport' ||
                  selectedIDType == 'Driver\'s License')
                buildInputField(expiryDateController, 'Enter Expiry Date', null,
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry date';
                  }
                  return " Expiry date must be after issue date";
                }),

              // Issuing Country (conditionally displayed)
              if (selectedIDType == 'Passport')
                buildInputField(
                    issuingCountryController, 'Enter Issuing Country', null,
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter issuing country';
                  }
                  return " Issuing country is required for Passport ID type";
                }),

              const SizedBox(height: 10),

              // ID Proof Upload
              ElevatedButton(
                onPressed: () {},
                // onPressed: _pickIDProof,
                child: const Text('Upload ID Proof'),
              ),
              idProof == null
                  ? const Text('No ID Proof Selected')
                  : Text('ID Proof Selected: ${idProof!.path}'),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  // Check if the form is valid before submitting
                  if (_formKey.currentState!.validate()) {
                    // Process the form data
                    print('KYC Form Submitted');
                    print('Selected ID Type: $selectedIDType');
                    print('ID Number: ${idNumberController.text}');
                    print('Issue Date: ${issueDateController.text}');
                    if (selectedIDType == 'Passport' ||
                        selectedIDType == 'Driver\'s License') {
                      print('Expiry Date: ${expiryDateController.text}');
                    }
                    if (selectedIDType == 'Passport') {
                      print(
                          'Issuing Country: ${issuingCountryController.text}');
                    }
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
                        offset: Offset(0, 4),
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
    TextEditingController controller, String hintText, String? labelText,
    {required String Function(String?) validator}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
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
