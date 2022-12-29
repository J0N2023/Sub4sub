import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub4sub_2023/model/setting_model.dart';


class SettingProvider with ChangeNotifier {

  SettingModel _setting =  SettingModel(
    id: 0,
    iosVersi: 0,
    androidVersi: 0,
    playstore: "",
    appstore: "",
    isDev: 1,
    createdAt: "",
    updatedAt: "",
  );

  SettingModel get setting => _setting;

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    Map json = jsonDecode(prefs.getString('setting')!);
    _setting = SettingModel.fromMap(json);
    notifyListeners();
  }
}
