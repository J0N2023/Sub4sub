import 'package:flutter/material.dart';
import 'package:sub4sub_2023/config/helper.dart';
import 'package:sub4sub_2023/model/statisitic_model.dart';


class StatisticProvider with ChangeNotifier {
  StatisticModel _model = StatisticModel(current: 0, finish: 0);

  StatisticModel get model => _model;

  Future<void> getData() async {
    var dbHelper = Helper();
    _model = await dbHelper.getStatistic();
    notifyListeners();
  }
}
