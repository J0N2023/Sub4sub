import 'dart:convert';

StatisticModel statisticModelFromMap(String str) => StatisticModel.fromMap(json.decode(str));

String statisticModelToMap(StatisticModel data) => json.encode(data.toMap());

class StatisticModel {
  StatisticModel({
    required this.current,
    required this.finish,
  });

  int current;
  int finish;

  factory StatisticModel.fromMap(Map<dynamic, dynamic> json) => StatisticModel(
    current: json["current"],
    finish: json["finish"],
  );

  Map<String, dynamic> toMap() => {
    "current": current,
    "finish": finish,
  };
}
