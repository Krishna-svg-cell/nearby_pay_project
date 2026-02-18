import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../services/api_service.dart';
import '../providers/wallet_provider.dart';
import 'home_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;

  void _submit() async {
    setState(() => _loading = true);
    final api = ApiService();
    try {
      Map<String, dynamic> res;
      if (_isLogin) {
        res = await api.login(_phoneCtrl.text, _pinCtrl.text);
        Provider.of<WalletProvider>(context, listen: false).setUser(res['user']);
      } else {
        res = await api.register(_nameCtrl.text, _phoneCtrl.text, _pinCtrl.text);
        Provider.of<WalletProvider>(context, listen: false).setUser({
          "name": _nameCtrl.text,
          "phone": _phoneCtrl.text,
          "balance": res['balance']
        });
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("NearbyPay", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.greenAccent)),
              const SizedBox(height: 40),
              if (!_isLogin) _buildField("Full Name", _nameCtrl, false),
              _buildField("Phone Number", _phoneCtrl, false),
              _buildField("Create PIN", _pinCtrl, true),
              const SizedBox(height: 20),
              _loading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50)
                    ),
                    onPressed: _submit,
                    child: Text(_isLogin ? "Login" : "Create Account"),
                  ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? "New user? Create Account" : "Already have account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, bool secret) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        obscureText: secret,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.cardBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}