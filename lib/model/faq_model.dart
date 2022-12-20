import 'dart:convert';

FaqModel faqModelFromMap(String str) => FaqModel.fromMap(json.decode(str));

String faqModelToMap(FaqModel data) => json.encode(data.toMap());

class FaqModel {
  FaqModel({
    required this.id,
    required this.pertanyaan,
    required this.jawaban,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String pertanyaan;
  String jawaban;
  String createdAt;
  String updatedAt;

  factory FaqModel.fromMap(Map<dynamic, dynamic> json) => FaqModel(
    id: json["id"] ?? 0,
    pertanyaan: json["pertanyaan"] ?? "",
    jawaban: json["jawaban"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "pertanyaan": pertanyaan,
    "jawaban": jawaban,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
