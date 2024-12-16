// import 'package:aura/screen/others/Dashboard.dart';
import 'package:aura/home_screen.dart';
import 'package:aura/screen/AuthScreens/LoginScreen.dart';
import 'package:aura/screen/others/KYCFormWithID.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final _auth = AuthService();

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? _selectedGender = "Female";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // @override
  // void dispose() {
  //   _usernameController.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  // Validation Methods
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      Fluttertoast.showToast(
        msg: "Passwords do not match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return 'Passwords do not match'; // Return validation error
    }
    return null; // No error, passwords match
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Navigate to the next page if validation passes
      Get.to(KYCFormWithID());
      Get.snackbar('Success', 'Signed up successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } else {
      Fluttertoast.showToast(
        msg: "Please fix the errors in the form",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 237, 247),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            Get.back();
          },
        ),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.comfortaa(
              fontSize: 28.0,
              color: Colors.black,
            ),
            children: const <TextSpan>[
              TextSpan(
                text: 'Aura',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfba7fc),
                ),
              ),
              TextSpan(
                text: 'Secure',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputField(emailController, "Email Address",
                  "Enter Your Email", _validateEmail),
              buildPasswordField(
                  passwordController, "Password", _isPasswordVisible,
                  (visible) {
                setState(() {
                  _isPasswordVisible = visible;
                });
              }),
              buildPasswordField(confirmPasswordController, "Confirm Password",
                  _isConfirmPasswordVisible, (visible) {
                setState(() {
                  _isConfirmPasswordVisible = visible;
                });
              }),
              buildFirstAndLastNameFields(),
              buildInputField(
                  phoneController,
                  "Phone Number",
                  "Enter Your Phone Number",
                  (value) => _validateField(value, "Phone Number"),
                  keyboardType: TextInputType.phone),
              buildGenderDropdown(),
              const SizedBox(height: 15),
              GestureDetector(
                // onTap:_
                onTap: _submitForm, // Trigger form submission on tap
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
                        offset: Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.comfortaa(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    TextEditingController controller,
    String labelText,
    String hintText,
    String? Function(String?) validator, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
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

  Widget buildPasswordField(TextEditingController controller, String labelText,
      bool isVisible, Function(bool) onVisibilityChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: const Color(0xFFedf0f8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: labelText == "Confirm Password"
              ? _validateConfirmPassword
              : _validatePassword,
          decoration: InputDecoration(
            hintText: labelText,
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
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () => onVisibilityChanged(!isVisible),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFirstAndLastNameFields() {
    return Row(
      children: [
        Expanded(
          child: buildInputField(
              firstNameController,
              "First Name",
              "Enter Your First Name",
              (value) => _validateField(value, "First Name")),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildInputField(
              lastNameController,
              "Last Name",
              "Enter Your Last Name",
              (value) => _validateField(value, "Last Name")),
        ),
      ],
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: "Gender",
          filled: true,
          fillColor: const Color(0xFFedf0f8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: ["Male", "Female", "Other"]
            .map((gender) =>
                DropdownMenuItem(value: gender, child: Text(gender)))
            .toList(),
        onChanged: (value) => setState(() => _selectedGender = value),
        validator: (value) =>
            value == null ? "Please select your gender" : null,
      ),
    );

    //    goToSignup(BuildContext context) => Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const LoginScreen()),
    //     );

    // goToHome(BuildContext context) => Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const HomeScreen()),
    //     );

    // _signup() async {
    //   final user = await _auth.createUserWithEmailAndPassword(
    //       _email.text, _password.text);
    //   if (user != null) {
    //     log("User Created Succesfully");
    //     goToHome(context);
    //   }
    // }
  }
}
