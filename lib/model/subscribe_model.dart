import 'dart:convert';

SubscribeModel subscribeModelFromMap(String str) => SubscribeModel.fromMap(json.decode(str));

String subscribeModelToMap(SubscribeModel data) => json.encode(data.toMap());

class SubscribeModel {
  SubscribeModel({
    required this.id,
    required this.idCampaign,
    required this.email,
    required this.channelSubscriber,
    required this.channelName,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int idCampaign;
  String email;
  String channelSubscriber;
  String channelName;
  String avatar;
  String createdAt;
  String updatedAt;

  factory SubscribeModel.fromMap(Map<dynamic, dynamic> json) => SubscribeModel(
    id: json["id"] ?? 0,
    idCampaign: json["id_campaign"] ?? 0,
    email: json["email"] ?? "",
    channelSubscriber: json["channel_subscriber"] ?? "",
    channelName: json["channel_name"] ?? "",
    avatar: json["avatar"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_campaign": idCampaign,
    "email": email,
    "channel_subscriber": channelSubscriber,
    "channel_name": channelName,
    "avatar": avatar,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
