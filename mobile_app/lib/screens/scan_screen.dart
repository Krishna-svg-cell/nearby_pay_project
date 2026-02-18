import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';
import '../services/api_service.dart';
import '../providers/wallet_provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ApiService _api = ApiService();
  List<dynamic> _nearbyUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    final myPhone = Provider.of<WalletProvider>(context, listen: false).user!['phone'];
    final users = await _api.getNearbyUsers(myPhone);
    
    setState(() {
      _nearbyUsers = users;
      _isLoading = false;
    });
  }

  void _showReceiveDialog() {
    final user = Provider.of<WalletProvider>(context, listen: false).user!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Center(child: Text("Receive Money", style: TextStyle(color: Colors.white))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 150, height: 150, color: Colors.white, child: Center(child: Icon(Icons.qr_code_2, size: 100, color: Colors.black))),
            SizedBox(height: 20),
            Text("Show to sender", style: TextStyle(color: Colors.grey)),
            Text(user['name'], style: TextStyle(color: AppColors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Close"))],
      ),
    );
  }

  void _showRequestDialog() {
    TextEditingController amtCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text("Request Money", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: amtCtrl,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: "₹ ", hintText: "Amount", hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.greenAccent)),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenAccent),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request Broadcasted to ${ _nearbyUsers.length} users!")));
            },
            child: Text("Request", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _payUser(dynamic targetUser) {
    TextEditingController amountCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Pay to ${targetUser['name']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.greenAccent),
              decoration: InputDecoration(prefixText: "₹ ", filled: true, fillColor: AppColors.background, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenAccent, minimumSize: Size(double.infinity, 50)),
              onPressed: () async {
                Navigator.pop(ctx);
                final wallet = Provider.of<WalletProvider>(context, listen: false);
                double amount = double.tryParse(amountCtrl.text) ?? 0.0;
                
                if(amount > 0 && wallet.balance >= amount) {
                   wallet.payUser(targetUser['name'], amount); // Updates history immediately
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.greenAccent, content: Text("Payment Successful!")));
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Insufficient Balance")));
                }
              },
              child: Text("Confirm Payment", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading)
            Center(
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.greenAccent.withOpacity(0.2))),
              ).animate(onPlay: (c) => c.repeat()).scale(duration: 2.seconds).fadeOut(duration: 2.seconds),
            ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(_isLoading ? "Scanning..." : "Nearby Users Found", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _nearbyUsers.length,
                    itemBuilder: (ctx, i) {
                      final u = _nearbyUsers[i];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: AppColors.border, child: Text(u['name'][0], style: TextStyle(color: Colors.white))),
                          title: Text(u['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Text("2m away", style: TextStyle(color: AppColors.greenAccent, fontSize: 12)),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blueAccent),
                            onPressed: () => _payUser(u),
                            child: Text("Pay", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ).animate().fadeIn().slideY(begin: 0.2);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: AppColors.background,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _scanAction(LucideIcons.upload, "Send", () => _startScan()),
                      _scanAction(LucideIcons.download, "Receive", _showReceiveDialog),
                      _scanAction(LucideIcons.banknote, "Request", _showRequestDialog),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _scanAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.cardBg, shape: BoxShape.circle, border: Border.all(color: AppColors.border)), child: Icon(icon, color: Colors.white)),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey))
        ],
      ),
    );
  }
}