class TransactionModel {
  final int? id;
  final double amount;
  final String type;
  final String category;
  final String note;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'],
      note: map['note'],
      date: DateTime.parse(map['date']),
    );
  }
}
