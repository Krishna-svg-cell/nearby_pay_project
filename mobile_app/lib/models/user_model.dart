class User {
  final String name;
  final String phone;
  final double balance;

  User({
    required this.name,
    required this.phone,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'Unknown',
      phone: json['phone'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "balance": balance,
    };
  }
}