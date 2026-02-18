class TransactionModel {
  final String id;
  final String senderName;
  final String receiverName;
  final double amount;
  final DateTime timestamp;
  final String? note;

  TransactionModel({
    required this.id,
    required this.senderName,
    required this.receiverName,
    required this.amount,
    required this.timestamp,
    this.note,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? '',
      senderName: json['sender_name'] ?? 'Unknown',
      receiverName: json['receiver_name'] ?? 'Unknown',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      note: json['note'],
    );
  }
}