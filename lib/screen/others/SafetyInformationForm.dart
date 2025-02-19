import 'package:aura/screen/others/Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetyInformationForm extends StatefulWidget {
  final String userId;
  SafetyInformationForm({required this.userId});

  @override
  _SafetyInformationFormState createState() => _SafetyInformationFormState();
}

class _SafetyInformationFormState extends State<SafetyInformationForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicalConditionsController =
      TextEditingController();

  List<Map<String, TextEditingController>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    emergencyContacts.add({
      'name': TextEditingController(),
      'relationship': TextEditingController(),
      'phone': TextEditingController(),
    });
  }

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

  void _removeEmergencyContact(int index) {
    setState(() {
      emergencyContacts.removeAt(index);
    });
  }

  Future<void> _submitSafetyInformation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      CollectionReference safetyInfoCollection = firestore
          .collection('users')
          .doc(widget.userId)
          .collection('SafetyInformation');

      List<Map<String, String>> emergencyContactsList =
          emergencyContacts.map((contact) {
        return {
          'name': contact['name']!.text,
          'relationship': contact['relationship']!.text,
          'phone': contact['phone']!.text,
        };
      }).toList();

      await safetyInfoCollection.doc('info').set({
        'bloodType': bloodTypeController.text,
        'allergies': allergiesController.text,
        'medicalConditions': medicalConditionsController.text,
        'emergencyContacts': emergencyContactsList,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Safety information submitted successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      Get.to(Dashboard(userId: widget.userId));
    } catch (e) {
      Get.snackbar(
          "Error", "Failed to submit safety information. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildEmergencyContactField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Emergency Contact ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          controller: emergencyContacts[index]['name'],
          decoration: InputDecoration(labelText: 'Contact Name'),
          validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
        ),
        TextFormField(
          controller: emergencyContacts[index]['relationship'],
          decoration: InputDecoration(labelText: 'Relationship'),
          validator: (value) =>
              value!.isEmpty ? 'Please enter relationship' : null,
        ),
        TextFormField(
          controller: emergencyContacts[index]['phone'],
          decoration: InputDecoration(labelText: 'Phone Number'),
          keyboardType: TextInputType.phone,
          validator: (value) =>
              value!.isEmpty ? 'Please enter phone number' : null,
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
    for (var contact in emergencyContacts) {
      contact['name']?.dispose();
      contact['relationship']?.dispose();
      contact['phone']?.dispose();
    }
    bloodTypeController.dispose();
    allergiesController.dispose();
    medicalConditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Safety Information Form'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          TextButton(
            onPressed: () => Get.to(Dashboard(userId: widget.userId)),
            child: const Text('Skip',
                style: TextStyle(color: Colors.white, fontSize: 16)),
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
              const Text('Emergency Contact Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...List.generate(emergencyContacts.length,
                  (index) => buildEmergencyContactField(index)),
              if (emergencyContacts.length < 4)
                ElevatedButton(
                    onPressed: _addEmergencyContact,
                    child: const Text('Add Another Emergency Contact')),
              const SizedBox(height: 20),
              const Text('Medical Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: bloodTypeController,
                decoration: InputDecoration(labelText: 'Enter Blood Type'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter blood type' : null,
              ),
              TextFormField(
                controller: allergiesController,
                decoration: InputDecoration(labelText: 'Enter Allergies'),
              ),
              TextFormField(
                controller: medicalConditionsController,
                decoration:
                    InputDecoration(labelText: 'Enter Medical Conditions'),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitSafetyInformation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 139, 3, 93),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Next",
                          style: GoogleFonts.comfortaa(
                              color: Colors.white, fontSize: 16.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
