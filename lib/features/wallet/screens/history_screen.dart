import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Color _getColor(String type) {
    switch (type) {
      case 'topup':
        return Colors.green;
      case 'purchase':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'topup':
        return Icons.add_circle;
      case 'purchase':
        return Icons.shopping_cart;
      default:
        return Icons.receipt_long;
    }
  }

  String _getTitle(String type) {
    switch (type) {
      case 'topup':
        return "Top Up";
      case 'purchase':
        return "Pembelian";
      default:
        return "Transaksi";
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(backgroundColor: const Color(0xFFF5F7FB));
  }
}
