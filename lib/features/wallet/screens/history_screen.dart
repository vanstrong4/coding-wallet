import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text(
          "Transaction History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada transaksi",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final type = data['type'] ?? '';

              int amount = 0;

              if (type == 'topup') {
                amount = (data['amount'] ?? 0) as int;
              } else if (type == 'purchase') {
                amount = (data['total'] ?? 0) as int;
              }

              final status = data['status'] ?? 'success';

              final Timestamp? createdAt = data['createdAt'] as Timestamp?;

              final date = createdAt != null
                  ? DateFormat('dd MMM yyyy, HH:mm').format(createdAt.toDate())
                  : '-';

              final color = _getColor(type);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: color.withOpacity(0.15),
                      child: Icon(_getIcon(type), color: color),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTitle(type),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            type == 'topup'
                                ? "Saldo masuk ke wallet"
                                : "Pembelian di Marketplace",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      type == 'topup'
                          ? "+ Rp ${NumberFormat('#,###', 'id_ID').format(amount)}"
                          : "- Rp ${NumberFormat('#,###', 'id_ID').format(amount)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
