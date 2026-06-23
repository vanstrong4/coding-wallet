import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/services/auth_service.dart';
import '../../auth/screens/login_screen.dart';
// import 'history_screen.dart';
// import 'topup_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService auth = AuthService();

  Future<Map<String, dynamic>> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final walletDoc = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(uid)
        .get();

    return {
      'name': userDoc.data()?['name'] ?? 'User',
      'email': userDoc.data()?['email'] ?? '',
      'balance': walletDoc.data()?['balance'] ?? 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text(
          "Coding Wallet",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
        automaticallyImplyLeading: false,
        actions: [],
      ),
    );
  }
}
