
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub4sub_2023/config/helper.dart';
import 'package:sub4sub_2023/config/url.dart';
import 'package:sub4sub_2023/config/void.dart';
import 'package:sub4sub_2023/model/campaign_model.dart';
import 'package:sub4sub_2023/model/chat_model.dart';
import 'package:sub4sub_2023/model/halaman_model.dart';
import 'package:sub4sub_2023/model/setting_model.dart';
import 'package:sub4sub_2023/model/user_model.dart';

import '../model/faq_model.dart';
import '../model/subscribe_model.dart';

var dio = Dio();
var dbHelper = Helper();

loadMyCampaign() async {
  UserModel userModel = await getUser();
  String last = await dbHelper.getUpdateCampaign();
  Response response = await dio.get('$apiUrl/my_campaign/$last/${userModel.email}');
  List newData = response.data['new_data'];
  String allID = response.data['all_id'];
  String newID = response.data['new_id'];
  List<CampaignModel> listModel = [];
  for (var e in newData) {
    CampaignModel model = CampaignModel.fromMap(e);
    listModel.add(model);
  }
  dbHelper.insertCampaign(listModel, allID, newID);
}

loadFaq() async {
  String last = await dbHelper.getUpdateFaq();
  Response response = await dio.get('$apiUrl/load/$last/faq');
  List newData = response.data['new_data'];
  String allID = response.data['all_id'];
  String newID = response.data['new_id'];
  List<FaqModel> listModel = [];
  for (var e in newData) {
    FaqModel model = FaqModel.fromMap(e);
    listModel.add(model);
  }
  dbHelper.insertFaq(listModel, allID, newID);
}

loadHalaman() async {
  String last = await dbHelper.getUpdateHalaman();
  Response response = await dio.get('$apiUrl/load/$last/halaman');
  List newData = response.data['new_data'];
  String allID = response.data['all_id'];
  String newID = response.data['new_id'];
  List<HalamanModel> listModel = [];
  for (var e in newData) {
    HalamanModel model = HalamanModel.fromMap(e);
    listModel.add(model);
  }
  dbHelper.insertHalaman(listModel, allID, newID);
}

loadChat() async {
  UserModel userModel = await getUser();
  String last = await dbHelper.getUpdateChat();
  Response response = await dio.get('$apiUrl/load/$last/chat/${userModel.email}');
  List newData = response.data['new_data'];
  String allID = response.data['all_id'];
  String newID = response.data['new_id'];
  List<ChatModel> listModel = [];
  for (var e in newData) {
    ChatModel model = ChatModel.fromMap(e);
    listModel.add(model);
  }
  dbHelper.insertChat(listModel, allID, newID);
}

loadSetting() async {
  Response response = await dio.get('$apiUrl/setting');
  SettingModel model = SettingModel.fromMap(response.data);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('setting', jsonEncode(model.toMap()));
  print('setting loaded');
}

loadSubscribe() async {
  UserModel userModel = await getUser();
  String last = await dbHelper.getUpdateSubscribe();
  Response response = await dio.get('$apiUrl/load/$last/subscribe/${userModel.email}');
  List newData = response.data['new_data'];
  String allID = response.data['all_id'];
  String newID = response.data['new_id'];
  List<SubscribeModel> listModel = [];
  for (var e in newData) {
    SubscribeModel model = SubscribeModel.fromMap(e);
    listModel.add(model);
  }
  dbHelper.insertSubscribe(listModel, allID, newID);
}
