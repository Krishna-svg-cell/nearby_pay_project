import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("My Wallet", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Big Balance Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border)
              ),
              child: Column(
                children: [
                  Icon(LucideIcons.wallet, size: 50, color: AppColors.greenAccent),
                  SizedBox(height: 20),
                  Text("Available Balance", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                  Text("₹${wallet.balance.toStringAsFixed(2)}", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 30),
            
            // Payment Methods List
            Align(alignment: Alignment.centerLeft, child: Text("Linked Methods", style: TextStyle(color: Colors.grey, fontSize: 16))),
            SizedBox(height: 10),
            
            ListTile(
              tileColor: AppColors.cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: Icon(Icons.account_balance, color: Colors.white),
              title: Text("HDFC Bank **** 1234", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.check_circle, color: AppColors.greenAccent),
            ),
            SizedBox(height: 10),
            ListTile(
              tileColor: AppColors.cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: Icon(Icons.credit_card, color: Colors.white),
              title: Text("Add New Card", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.add, color: Colors.white),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Card Scanner Opened...")));
              },
            )
          ],
        ),
      ),
    );
  }
}