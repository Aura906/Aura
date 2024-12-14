import 'package:aura/screen/AuthScreens/SignupPage.dart';
import 'package:aura/screen/others/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers and Variables
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Form and Validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

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

  void _performLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulated login process
        await Future.delayed(const Duration(seconds: 2));
        Get.to(Dashboard());
        // Navigate to Dashboard
        Get.snackbar(
          'Success',
          'Logged in successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        // Handle login errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: RichText(
            text: TextSpan(
              style: GoogleFonts.comfortaa(
                fontSize: 28.0,
                color: Colors.black,
              ),
              children: const [
                TextSpan(
                  text: 'Aura',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfba7fc),
                  ),
                ),
                TextSpan(
                  text: 'Secure',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  "images/ALogo.png",
                  width: width * 1,
                  height: height * 0.4,
                ),

                const SizedBox(height: 20),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
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
                  validator: _validateEmail,
                ),

                const SizedBox(height: 20),

                // Password Input
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
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
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),

                const SizedBox(height: 20),

                // Login Button
                _isLoading
                    ? const CircularProgressIndicator(
                        color: Color(0xFFf5aedd),
                      )
                    : GestureDetector(
                        onTap: _performLogin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 15.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 139, 3, 93),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: GoogleFonts.comfortaa(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 20),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.comfortaa(fontSize: 16.0),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => SignupPage()),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.comfortaa(
                          fontSize: 16.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
