
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:sub4sub_2023/config/url.dart';
import 'package:sub4sub_2023/config/void.dart';
import 'package:sub4sub_2023/model/user_model.dart';
import 'package:dio/dio.dart';

class UserProvider with ChangeNotifier {
  UserModel _model = UserModel(
    id: 0,
    nama: "",
    email: "",
    coin: 0,
    idDevice: "",
    os: "",
    avatar: "",
    createdAt: "",
    updatedAt: "",
  );

  UserModel get model => _model;

  Future<void> getData() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String idDevice = '';
    String os = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      idDevice = androidInfo.fingerprint;
      os = 'ANDROID';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      idDevice = iosInfo.identifierForVendor ?? '';
      os = 'IOS';
    }

    UserModel userModel = await getUser();
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'email': userModel.email,
      'id_device': idDevice,
      'os': os,
    });
    Response response = await dio.post(
      "$apiUrl/akun",
      data: formData
    );
    _model = UserModel.fromMap(response.data);
    notifyListeners();
  }
}
