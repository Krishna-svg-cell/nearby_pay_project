import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants.dart';
import '../providers/wallet_provider.dart';
import 'wallet_screen.dart'; // We will create this below

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasRequest = true; // Simulating one pending request

  void _handleTransaction(String type) {
    TextEditingController amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(type, style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: "₹ ",
            hintText: "Enter Amount",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.greenAccent)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenAccent),
            onPressed: () {
              double? amount = double.tryParse(amountCtrl.text);
              if (amount != null && amount > 0) {
                final wallet = Provider.of<WalletProvider>(context, listen: false);
                if (type == "Withdraw" && wallet.balance < amount) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Insufficient Balance!")));
                } else {
                  if (type == "Add Money") wallet.addMoney(amount);
                  if (type == "Withdraw") wallet.withdrawMoney(amount);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.greenAccent, content: Text("$type Successful!")));
                }
              }
            },
            child: Text("Confirm", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.gradientPrimary,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: AppColors.greenAccent.withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10))]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Balance", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text("₹${wallet.balance.toStringAsFixed(2)}", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionBtn(LucideIcons.plus, "Add Money", () => _handleTransaction("Add Money")),
                    _actionBtn(LucideIcons.arrowUpRight, "Withdraw", () => _handleTransaction("Withdraw")),
                    // WALLET BUTTON NOW WORKS
                    _actionBtn(LucideIcons.wallet, "Wallet", () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                    }),
                  ],
                )
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Search Field (Working UI)
          TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search contacts...",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(LucideIcons.search, color: Colors.grey),
              filled: true,
              fillColor: AppColors.cardBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),

          const SizedBox(height: 30),
          
          Text("Requests Received", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          
          if (_hasRequest)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: AppColors.border, child: Text("JD", style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      Text("Requested ₹500", style: TextStyle(color: AppColors.greenAccent)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _hasRequest = false),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (wallet.balance >= 500) {
                        wallet.payUser("John Doe", 500);
                        setState(() => _hasRequest = false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.greenAccent, content: Text("Paid ₹500 to John Doe")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Insufficient Balance")));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenAccent),
                    child: Text("Pay", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text("No pending requests", style: TextStyle(color: Colors.grey))),
            ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))
        ],
      ),
    );
  }
}