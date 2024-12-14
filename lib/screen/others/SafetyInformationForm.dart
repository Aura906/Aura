import 'package:aura/screen/others/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetyInformationForm extends StatefulWidget {
  @override
  _SafetyInformationFormState createState() => _SafetyInformationFormState();
}

class _SafetyInformationFormState extends State<SafetyInformationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for safety information fields
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicalConditionsController =
      TextEditingController();

  List<Map<String, TextEditingController>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    // Initialize with one empty emergency contact field
    emergencyContacts.add({
      'name': TextEditingController(),
      'relationship': TextEditingController(),
      'phone': TextEditingController(),
    });
  }

  // Add new emergency contact
  void _addEmergencyContact() {
    if (emergencyContacts.length < 4) {
      setState(() {
        emergencyContacts.add({
          'name': TextEditingController(),
          'relationship': TextEditingController(),
          'phone': TextEditingController(),
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You can add a maximum of 4 emergency contacts.')),
      );
    }
  }

  // Remove emergency contact
  void _removeEmergencyContact(int index) {
    setState(() {
      emergencyContacts.removeAt(index);
    });
  }

  // Build the input field for emergency contact details
  Widget buildEmergencyContactField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Emergency Contact ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: emergencyContacts[index]['name'],
            decoration: InputDecoration(
              hintText: 'Contact Name',
              hintStyle: GoogleFonts.comfortaa(
                  color: Color(0xFFb2b7bf), fontSize: 18.0),
              filled: true,
              fillColor: Color(0xFFedf0f8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: emergencyContacts[index]['relationship'],
            decoration: InputDecoration(
              hintText: 'Relationship',
              hintStyle: GoogleFonts.comfortaa(
                  color: Color(0xFFb2b7bf), fontSize: 18.0),
              filled: true,
              fillColor: Color(0xFFedf0f8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: emergencyContacts[index]['phone'],
            decoration: InputDecoration(
              hintText: 'Phone Number',
              hintStyle: GoogleFonts.comfortaa(
                  color: Color(0xFFb2b7bf), fontSize: 18.0),
              filled: true,
              fillColor: Color(0xFFedf0f8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
        if (emergencyContacts.length > 1)
          IconButton(
            onPressed: () => _removeEmergencyContact(index),
            icon: Icon(Icons.remove_circle, color: Colors.red),
          ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    emergencyContacts.forEach((contact) {
      contact['name']?.dispose();
      contact['relationship']?.dispose();
      contact['phone']?.dispose();
    });
    bloodTypeController.dispose();
    allergiesController.dispose();
    medicalConditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Safety Information Form'),
      //   centerTitle: true,
      //   backgroundColor: Colors.pinkAccent,
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the default back button
        title: const Text('Safety Information Form'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton(
            onPressed: () {
              // Skip the form or perform any action here
              Get.to(Dashboard());
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
                'Emergency Contact Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Dynamically display emergency contact fields
              ...List.generate(emergencyContacts.length, (index) {
                return buildEmergencyContactField(index);
              }),

              // Add "+" button to add emergency contacts
              if (emergencyContacts.length < 4)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: _addEmergencyContact,
                    child: const Text('Add Another Emergency Contact'),
                  ),
                ),

              const SizedBox(height: 20),
              const Text(
                'Medical Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Blood Type
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: bloodTypeController,
                  decoration: InputDecoration(
                    hintText: 'Enter Blood Type',
                    hintStyle: GoogleFonts.comfortaa(
                        color: Color(0xFFb2b7bf), fontSize: 18.0),
                    filled: true,
                    fillColor: Color(0xFFedf0f8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Allergies
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: allergiesController,
                  decoration: InputDecoration(
                    hintText: 'Enter Allergies',
                    hintStyle: GoogleFonts.comfortaa(
                        color: Color(0xFFb2b7bf), fontSize: 18.0),
                    filled: true,
                    fillColor: Color(0xFFedf0f8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Medical Conditions
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: medicalConditionsController,
                  decoration: InputDecoration(
                    hintText: 'Enter Medical Conditions',
                    hintStyle: GoogleFonts.comfortaa(
                        color: Color(0xFFb2b7bf), fontSize: 18.0),
                    filled: true,
                    fillColor: Color(0xFFedf0f8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       if (_formKey.currentState!.validate()) {
              //         // Process the form data
              //         print('Safety Information Form Submitted');
              //         emergencyContacts.forEach((contact) {
              //           print(
              //               'Emergency Contact Name: ${contact['name']!.text}');
              //           print('Relationship: ${contact['relationship']!.text}');
              //           print('Phone Number: ${contact['phone']!.text}');
              //         });
              //         print('Blood Type: ${bloodTypeController.text}');
              //         print('Allergies: ${allergiesController.text}');
              //         print(
              //             'Medical Conditions: ${medicalConditionsController.text}');
              //       }
              //     },
              //     child: const Text('Submit'),
              //   ),
              // ),

              GestureDetector(
                onTap: () {
                  // Check if the form is valid before submitting
                  if (_formKey.currentState!.validate()) {
                    print('Safety Information Form Submitted');
                    emergencyContacts.forEach((contact) {
                      print('Emergency Contact Name: ${contact['name']!.text}');
                      print('Relationship: ${contact['relationship']!.text}');
                      print('Phone Number: ${contact['phone']!.text}');
                    });
                    print('Blood Type: ${bloodTypeController.text}');
                    print('Allergies: ${allergiesController.text}');
                    print(
                        'Medical Conditions: ${medicalConditionsController.text}');
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
