import 'dart:convert';

Budget budgetFromJson(String str) => Budget.fromJson(json.decode(str));

String budgetToJson(Budget data) => json.encode(data.toJson());

class Budget {
  Budget({
    this.plan,
  });

  String plan;

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        plan: json["plan"],
      );

  Map<String, dynamic> toJson() => {
        "plan": plan,
      };
}
