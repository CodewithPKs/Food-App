import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Login/Screen/registerScreen.dart';
import '../Controller/AuthController.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  void _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() => isLoading = true);
    try {
      await authProvider.signIn(_emailController.text, _passwordController.text);
      setState(() => isLoading = false);
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
      setState(() => isLoading = false);
    }
  }



  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    emailFocusNode.addListener(() {
      setState(() {});
    });

    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            child:  SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/halal-new.png"),

                    SizedBox(height: 50,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: emailFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Colors.white,
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white24, width: 0.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: emailFocusNode.hasFocus
                                  ? Colors.grey.withOpacity(0.4)
                                  : Colors.grey.withOpacity(0.8),
                              width: emailFocusNode.hasFocus ? 0.2 : 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: emailFocusNode.hasFocus
                                  ? Colors.grey.withOpacity(0.4)
                                  : Colors.grey.withOpacity(0.8),
                              width: emailFocusNode.hasFocus ? 0.2 : 0.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        focusNode: passwordFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white24, width: 0.0),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: emailFocusNode.hasFocus
                                  ? Colors.grey.withOpacity(0.4)
                                  : Colors.grey.withOpacity(0.8),
                              width: passwordFocusNode.hasFocus ? 0.2 : 0.5,
                            ),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.15,
                          vertical: height * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: isLoading
                            ? Center(
                          child: CircularProgressIndicator(color: Colors.white,),
                        )
                            : Text(
                          'LOGIN',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                            fontFamily: 'Myriad Pro',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Forget your Login Credentials?',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Passwordresetform()));
                            _showPasswordResetDialog(context);
                          },
                          child:   Text(
                            '  Reset now..',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 100,),


                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          Text(
                            'DON\'T HAVE AN ACCOUNT?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: width * 0.04,
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.2,
                                vertical: height * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(163, 177, 200, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'CREATE NEW ACCOUNT',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: width * 0.04,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              )
            )
          )
        ],
      ),
    );
  }

  void _showPasswordResetDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                authProvider.resetPassword(emailController.text.trim(), context);
              },
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }


}



// Spacer(),
// Image.asset("assets/login-bt.jpg", height: 300, width: double.infinity, fit: BoxFit.fitWidth,),