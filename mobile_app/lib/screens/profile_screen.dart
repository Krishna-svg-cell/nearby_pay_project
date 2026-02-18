import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants.dart';
import '../providers/wallet_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(title, style: TextStyle(color: Colors.white)),
        content: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new value",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.greenAccent)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenAccent),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title Updated!")));
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WalletProvider>(context).user!;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundColor: AppColors.greenAccent, child: Text(user['name'][0], style: TextStyle(fontSize: 40, color: Colors.white))),
            const SizedBox(height: 16),
            Text(user['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(user['phone'], style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            
            _settingItem(context, "Edit Profile", LucideIcons.user, () => _showEditDialog(context, "Edit Name")),
            _settingItem(context, "Security & Privacy", LucideIcons.shield, () => _showEditDialog(context, "Change PIN")),
            _settingItem(context, "Payment Methods", LucideIcons.creditCard, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bank Linking Coming Soon")))),
            _settingItem(context, "Help & Support", LucideIcons.helpCircle, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Contacting Support...")))),
            
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.1), foregroundColor: Colors.red, minimumSize: Size(double.infinity, 50)),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("Log Out"),
            )
          ],
        ),
      ),
    );
  }

  Widget _settingItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        tileColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}