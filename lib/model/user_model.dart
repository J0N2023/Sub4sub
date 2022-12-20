import 'dart:convert';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.coin,
    required this.idDevice,
    required this.os,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String nama;
  String email;
  int coin;
  String idDevice;
  String os;
  String createdAt;
  String updatedAt;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? 0,
    nama: json["nama"] ?? "",
    email: json["email"] ?? "",
    coin: json["coin"] ?? 0,
    idDevice: json["id_device"] ?? "",
    os: json["os"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nama": nama,
    "email": email,
    "coin": coin,
    "id_device": idDevice,
    "os": os,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
