import 'dart:convert';

Rate rateFromJson(String str) => Rate.fromJson(json.decode(str));

String rateToJson(Rate data) => json.encode(data.toJson());

class Rate {
  Rate({
    this.success,
    this.base,
    this.date,
    this.rates,
  });

  bool success;
  String base;
  DateTime date;
  Map<String, double> rates;

  // returns Rate object after json decoding
  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        success: json["success"],
        base: json["base"],
        date: DateTime.parse(json["date"]),
        rates: Map.from(json["rates"]).map((k, v) => MapEntry<String, double>(
            k, v.toDouble())), // String, dynamic to String, double
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "base": base,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
