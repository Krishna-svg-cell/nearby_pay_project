import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WalletProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  
  Map<String, dynamic>? _user;
  double _balance = 0.0;
  
  // Local list to store transactions immediately
  List<Map<String, dynamic>> _transactions = [];

  Map<String, dynamic>? get user => _user;
  double get balance => _balance;
  List<Map<String, dynamic>> get transactions => _transactions;

  void setUser(Map<String, dynamic> userData) {
    _user = userData;
    _balance = (userData['balance'] as num).toDouble();
    // Add initial dummy data for demonstration if empty
    if (_transactions.isEmpty) {
      _transactions.add({
        'type': 'received',
        'name': 'Welcome Bonus',
        'amount': 100.0,
        'date': DateTime.now().subtract(Duration(days: 1))
      });
    }
    notifyListeners();
  }

  // Handle Add Money
  void addMoney(double amount) {
    _balance += amount;
    _transactions.insert(0, {
      'type': 'added',
      'name': 'Bank Deposit',
      'amount': amount,
      'date': DateTime.now()
    });
    notifyListeners();
  }

  // Handle Withdraw
  void withdrawMoney(double amount) {
    if (_balance >= amount) {
      _balance -= amount;
      _transactions.insert(0, {
        'type': 'withdrawn',
        'name': 'Bank Withdrawal',
        'amount': amount,
        'date': DateTime.now()
      });
      notifyListeners();
    }
  }

  // Handle Paying a Request or User
  void payUser(String name, double amount) {
    if (_balance >= amount) {
      _balance -= amount;
      _transactions.insert(0, {
        'type': 'sent',
        'name': name,
        'amount': amount,
        'date': DateTime.now()
      });
      notifyListeners();
    }
  }

  // Handle Receiving Money (Simulated)
  void receiveMoney(String sender, double amount) {
    _balance += amount;
    _transactions.insert(0, {
      'type': 'received',
      'name': sender,
      'amount': amount,
      'date': DateTime.now()
    });
    notifyListeners();
  }
}