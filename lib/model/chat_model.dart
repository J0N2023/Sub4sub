import 'dart:convert';

ChatModel chatModelFromMap(String str) => ChatModel.fromMap(json.decode(str));

String chatModelToMap(ChatModel data) => json.encode(data.toMap());

class ChatModel {
  ChatModel({
    required this.id,
    required this.idUser,
    required this.pair,
    required this.pesan,
    required this.createdAt,
    required this.updatedAt,
    required this.nama,
  });

  int id;
  int idUser;
  String pair;
  String pesan;
  String createdAt;
  String updatedAt;
  String nama;

  factory ChatModel.fromMap(Map<dynamic, dynamic> json) => ChatModel(
    id: json["id"] ?? 0,
    idUser: json["id_user"] ?? 0,
    pair: json["pair"] ?? "",
    pesan: json["pesan"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    nama: json["nama"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_user": idUser,
    "pair": pair,
    "pesan": pesan,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "nama": nama,
  };
}
