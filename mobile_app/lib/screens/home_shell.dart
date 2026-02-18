import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants.dart';
import 'home_screen.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _idx = 0;
  final _pages = [
    const HomeScreen(),
    const SizedBox(), // Placeholder for Scan
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _idx == 1 ? const ScanScreen() : SafeArea(child: _pages[_idx]),
      
      appBar: _idx == 1 ? null : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _idx == 0 ? const Text("NearbyPay", style: TextStyle(fontWeight: FontWeight.bold)) : const Text("History"),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                backgroundColor: AppColors.border,
                child: Icon(LucideIcons.user, color: Colors.white),
              ),
            ),
          )
        ],
      ),

      bottomNavigationBar: Container(
        height: 80,
        color: AppColors.cardBg,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(LucideIcons.home, color: _idx == 0 ? AppColors.greenAccent : Colors.grey),
              onPressed: () => setState(() => _idx = 0),
            ),
            
            // Floating Scan Button
            GestureDetector(
              onTap: () => setState(() => _idx = 1),
              child: Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.greenAccent.withOpacity(0.4), blurRadius: 15)]
                ),
                child: const Icon(LucideIcons.scan, color: Colors.white, size: 28),
              ),
            ),

            IconButton(
              icon: Icon(LucideIcons.fileText, color: _idx == 2 ? AppColors.greenAccent : Colors.grey),
              onPressed: () => setState(() => _idx = 2),
            ),
          ],
        ),
      ),
    );
  }
}