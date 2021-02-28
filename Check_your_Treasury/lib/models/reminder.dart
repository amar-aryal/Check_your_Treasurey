import 'dart:convert';

Reminder reminderFromJson(String str) => Reminder.fromJson(json.decode(str));

String reminderToJson(Reminder data) => json.encode(data.toJson());

class Reminder {
  Reminder({
    this.billName,
    this.billAmount,
    this.paymentDate,
  });

  String billName;
  double billAmount;
  DateTime paymentDate;

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        billName: json["billName"],
        billAmount: json["billAmount"],
        paymentDate: DateTime.parse(json["paymentDate"]),
      );

  Map<String, dynamic> toJson() => {
        "billName": billName,
        "billAmount": billAmount,
        "paymentDate":
            "${paymentDate.year.toString().padLeft(4, '0')}-${paymentDate.month.toString().padLeft(2, '0')}-${paymentDate.day.toString().padLeft(2, '0')}",
      };
}
