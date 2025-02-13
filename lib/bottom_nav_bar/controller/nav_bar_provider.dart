import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NavBarProvider with ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isKrishiNewsEnabled = false;
  bool get isKrishiNewsEnabled => _isKrishiNewsEnabled;
  void setKrishiNewsEnabled(bool value) {
    log('Krishi News Status updated to $value');
    _isKrishiNewsEnabled = value;
    notifyListeners();
  }

  Future<bool> fetchKrishiNewsStatus() async {
    try {

      log('Fetching Krishi News Status...');

      final docSnapshot = await firestore
          .collection('DynamicSection')
          .doc('HomeSection')
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();

        if (data == null) {

          log('Data is Null...Returned..!!');

          setKrishiNewsEnabled(false);
          return false;
        }

        bool isKrishiNewsEnabled = data['isKrishiNewsEnabled'] ?? false;

        log('Stutus is ${data['isKrishiNewsEnabled']}');

        setKrishiNewsEnabled(isKrishiNewsEnabled);
        return isKrishiNewsEnabled;
      }

      return false;

    } catch (e) {
      log("Error fetching Krishi News status: $e");
      return false;
    }
  }

  bool _isNetCoreBotEnabled = false;
  bool get isNetCoreBotEnabled => _isNetCoreBotEnabled;

  bool _isAddPostEnabled = false;
  bool get isAddPostEnabled => _isAddPostEnabled;

  Future<void> fetchNetcoreBotStatus() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('DynamicSection')
          .doc('ChatBots')
          .get();

      if (snapshot.exists) {

        Map<String, dynamic>? data = snapshot.data();

        bool netcoreStatus = data?['NetCore'] ?? false;
        bool postStatus = data?['CreatePost'] ?? false;

        _isNetCoreBotEnabled = netcoreStatus;
        _isAddPostEnabled = postStatus;
        notifyListeners();
      }

    } catch (e) {
      log('Error fetching SalesIQ status: $e');
    }
  }

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;
  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}