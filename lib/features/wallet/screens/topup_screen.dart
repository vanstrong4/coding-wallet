import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController amountController = TextEditingController();

  bool loading = false;
  int selectedAmount = 0;

  final List<int> quickAmounts = [10000, 20000, 50000, 100000, 200000, 500000];

  Future<int> getBalance() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(uid)
        .get();

    return (doc.data()?['balance'] ?? 0) as int;
  }
}
