
import 'dart:convert';

HalamanModel halamanModelFromMap(String str) => HalamanModel.fromMap(json.decode(str));

String halamanModelToMap(HalamanModel data) => json.encode(data.toMap());

class HalamanModel {
  HalamanModel({
    required this.id,
    required this.nama,
    required this.isi,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String nama;
  String isi;
  String createdAt;
  String updatedAt;

  factory HalamanModel.fromMap(Map<dynamic, dynamic> json) => HalamanModel(
    id: json["id"] ?? 0,
    nama: json["nama"] ?? "",
    isi: json["isi"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nama": nama,
    "isi": isi,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
