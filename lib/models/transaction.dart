class TransactionModel {
  final int? id;
  final double amount;
  final String type;
  final int? categoryId;
  final String? categoryName;
  final String note;
  final DateTime date;

  TransactionModel({
    this.id,
    this.categoryName,
    this.categoryId,
    required this.type,
    required this.amount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'categoryId': categoryId,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      amount: map['amount'] as double,
      type: map['type'] as String,
      categoryId: map['categoryId'] as int?,
      categoryName: map['categoryName'] as String?,
      note: map['note'] as String,
      date: DateTime.parse(map['date']),
    );
  }
}
