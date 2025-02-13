import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/AuthController.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _register() async {
    setState(() => isLoading = true);
    await Provider.of<AuthProvider>(context, listen: false).registerUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      context: context,
    );
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Image.asset("assets/bg-login.jpg", fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.8)),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/halal-new.png"),
                  SizedBox(height: 50),

                  _buildTextField(_nameController, "Name", nameFocusNode),
                  SizedBox(height: height * 0.02),
                  _buildTextField(_phoneController, "Phone", phoneFocusNode),
                  SizedBox(height: height * 0.02),
                  _buildTextField(_emailController, "Email", emailFocusNode),
                  SizedBox(height: height * 0.02),
                  _buildTextField(_passwordController, "Password", passwordFocusNode, isPassword: true),
                  SizedBox(height: height * 0.04),

                  GestureDetector(
                    onTap: isLoading ? null : _register,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.15, vertical: height * 0.015),
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(6)),
                      child: isLoading
                          ? Center(child: CircularProgressIndicator(color: Colors.white))
                          : Text('Sign Up', textAlign: TextAlign.center, style: TextStyle(
                          letterSpacing: 1.5, color: Colors.white, fontWeight: FontWeight.w600, fontSize: width * 0.04)),
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already Have an Account', style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(' Tap to Login!', style: TextStyle(color: Colors.white, fontSize: width * 0.04, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, FocusNode focusNode, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24, width: 0.0)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: focusNode.hasFocus ? Colors.grey.withOpacity(0.4) : Colors.grey.withOpacity(0.8), width: focusNode.hasFocus ? 0.2 : 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusNode.hasFocus ? Colors.grey.withOpacity(0.4) : Colors.grey.withOpacity(0.8), width: focusNode.hasFocus ? 0.2 : 0.5),
          ),
        ),
      ),
    );
  }
}
