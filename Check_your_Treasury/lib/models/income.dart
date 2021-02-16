import 'dart:convert';

Income incomeFromJson(String str) => Income.fromJson(json.decode(str));

String incomeToJson(Income data) => json.encode(data.toJson());

class Income {
  Income({
    this.incomename,
    this.category,
    this.amount,
    this.date,
  });

  String incomename;
  String category;
  double amount;
  DateTime date;

  factory Income.fromJson(Map<String, dynamic> json) => Income(
        incomename: json["expensename"],
        category: json["category"],
        amount: json["amount"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "incomename": incomename,
        "category": category,
        "amount": amount,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}
