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

  Future<void> topUp() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final amount = int.tryParse(amountController.text) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nominal tidak valid")));
      return;
    }

    setState(() => loading = true);

    try {
      final walletRef = FirebaseFirestore.instance
          .collection('wallets')
          .doc(uid);

      await FirebaseFirestore.instance.runTransaction((trx) async {
        final walletSnap = await trx.get(walletRef);

        final currentBalance = (walletSnap.data()?['balance'] ?? 0) as int;

        trx.update(walletRef, {'balance': currentBalance + amount});
      });

      await FirebaseFirestore.instance.collection('transactions').add({
        'userId': uid,
        'type': 'topup',
        'amount': amount,
        'status': 'success',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Top Up berhasil")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }

    setState(() => loading = false);
  }

  Widget quickButton(int amount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = amount;
          amountController.text = amount.toString();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selectedAmount == amount
              ? const Color(0xFF1565C0)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1565C0)),
        ),
        child: Text(
          "Rp ${amount ~/ 1000}K",
          style: TextStyle(
            color: selectedAmount == amount
                ? Colors.white
                : const Color(0xFF1565C0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
