import 'dart:convert';

Expense expenseFromJson(String str) => Expense.fromJson(json.decode(str));

String expenseToJson(Expense data) => json.encode(data.toJson());

class Expense {
  Expense({
    this.expensename,
    this.category,
    this.amount,
    this.date,
  });

  String expensename;
  String category;
  double amount;
  DateTime date;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        expensename: json["expensename"],
        category: json["category"],
        amount: json["amount"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "expensename": expensename,
        "category": category,
        "amount": amount,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}
