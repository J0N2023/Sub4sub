import 'package:flutter/material.dart';
import 'package:sub4sub_2023/config/helper.dart';
import 'package:sub4sub_2023/model/campaign_model.dart';
import 'package:sub4sub_2023/model/faq_model.dart';

import '../model/halaman_model.dart';


class HalamanProvider with ChangeNotifier {
  HalamanModel _model = HalamanModel(
    id: 0,
    nama: "",
    isi: "",
    createdAt: "",
    updatedAt: "",
  );

  HalamanModel get model => _model;

  Future<void> getData(String nama) async {
    var dbHelper = Helper();
    _model = await dbHelper.getHalaman(nama);
    notifyListeners();
  }
}
