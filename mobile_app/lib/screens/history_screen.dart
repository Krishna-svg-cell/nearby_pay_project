import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../providers/wallet_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<WalletProvider>(context).transactions;

    return Column(
      children: [
        // Filter Buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: ["All", "Sent", "Received", "Requests"].map((f) => Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: f == "All" ? AppColors.greenAccent : AppColors.cardBg, borderRadius: BorderRadius.circular(20)),
              child: Text(f, style: TextStyle(color: f == "All" ? Colors.white : Colors.grey)),
            )).toList(),
          ),
        ),

        // List
        Expanded(
          child: transactions.isEmpty 
          ? Center(child: Text("No transactions yet", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, i) {
              final tx = transactions[i];
              final isReceived = tx['type'] == 'received' || tx['type'] == 'added';
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isReceived ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      child: Icon(isReceived ? Icons.arrow_downward : Icons.arrow_upward, color: isReceived ? Colors.green : Colors.red),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          Text(DateFormat('MMM d, h:mm a').format(tx['date']), style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      "${isReceived ? '+' : '-'} ₹${tx['amount']}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isReceived ? Colors.green : Colors.red),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}