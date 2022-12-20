import 'dart:convert';

SettingModel settingModelFromMap(String str) => SettingModel.fromMap(json.decode(str));

String settingModelToMap(SettingModel data) => json.encode(data.toMap());

class SettingModel {
  SettingModel({
    required this.id,
    required this.iosVersi,
    required this.androidVersi,
    required this.playstore,
    required this.appstore,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int iosVersi;
  int androidVersi;
  String playstore;
  String appstore;
  String createdAt;
  String updatedAt;

  factory SettingModel.fromMap(Map<dynamic, dynamic> json) => SettingModel(
    id: json["id"] ?? 0,
    iosVersi: json["ios_versi"] ?? 0,
    androidVersi: json["android_versi"] ?? 0,
    playstore: json["playstore"] ?? "",
    appstore: json["appstore"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "ios_versi": iosVersi,
    "android_versi": androidVersi,
    "playstore": playstore,
    "appstore": appstore,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
