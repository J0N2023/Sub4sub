import 'dart:convert';

CampaignModel campaignModelFromMap(String str) => CampaignModel.fromMap(json.decode(str));

String campaignModelToMap(CampaignModel data) => json.encode(data.toMap());

class CampaignModel {
  CampaignModel({
    required this.id,
    required this.idUser,
    required this.idChannel,
    required this.channelName,
    required this.idVideo,
    required this.title,
    required this.deskripsi,
    required this.currentSub,
    required this.finishSub,
    required this.gambar,
    required this.lastView,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int idUser;
  String idChannel;
  String channelName;
  String idVideo;
  String title;
  String deskripsi;
  int currentSub;
  int finishSub;
  String gambar;
  String lastView;
  String createdAt;
  String updatedAt;

  factory CampaignModel.fromMap(Map<dynamic, dynamic> json) => CampaignModel(
    id: json["id"] ?? 0,
    idUser: json["id_user"] ?? 0,
    idChannel: json["id_channel"] ?? "",
    channelName: json["channel_name"] ?? "",
    idVideo: json["id_video"] ?? "",
    title: json["title"] ?? "",
    deskripsi: json["deskripsi"] ?? "",
    currentSub: json["current_sub"] ?? 0,
    finishSub: json["finish_sub"] ?? 0,
    gambar: json["gambar"] ?? "",
    lastView: json["last_view"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "id_user": idUser,
    "id_channel": idChannel,
    "channel_name": channelName,
    "id_video": idVideo,
    "title": title,
    "deskripsi": deskripsi,
    "current_sub": currentSub,
    "finish_sub": finishSub,
    "gambar": gambar,
    "last_view": lastView,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
