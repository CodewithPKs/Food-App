import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      _user = _auth.currentUser;
      await _fetchUserData(userId);
    } else {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> _fetchUserData(String uid) async {
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (snapshot.exists) {
      _userData = snapshot.data() as Map<String, dynamic>;
      notifyListeners();
    }
  }

  void resetPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context); // Close dialog after sending email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Check your email to reset your password')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = credential.user;

      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
        'uid': _user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': DateTime.now(),
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.uid);

      await _fetchUserData(_user!.uid);
      notifyListeners();

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signIn(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    _user = credential.user;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', _user!.uid);

    await _fetchUserData(_user!.uid);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');


    _user = null;
    _userData = null;
    notifyListeners();
  }
}



// class AuthProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _user;
//   Map<String, dynamic>? _userData;
//
//   User? get user => _user;
//   Map<String, dynamic>? get userData => _userData;
//
//   AuthProvider() {
//     _auth.authStateChanges().listen((user) {
//       _user = user;
//       if (user != null) {
//         _fetchUserData(user.uid);
//       }
//       notifyListeners();
//     });
//   }
//
//   Future<void> _fetchUserData(String uid) async {
//     DocumentSnapshot snapshot =
//     await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     if (snapshot.exists) {
//       _userData = snapshot.data() as Map<String, dynamic>;
//       notifyListeners();
//     }
//   }
//
//   Future<void> signIn(String email, String password) async {
//     await _auth.signInWithEmailAndPassword(email: email, password: password);
//   }
//
//   Future<void> signUp(String email, String password, String name) async {
//     UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//     await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
//       'name': name,
//       'email': email,
//     });
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }
