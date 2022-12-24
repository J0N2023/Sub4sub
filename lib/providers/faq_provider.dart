import 'package:flutter/material.dart';
import 'package:sub4sub_2023/config/helper.dart';
import 'package:sub4sub_2023/model/faq_model.dart';


class FaqProvider with ChangeNotifier {
  List<FaqModel> _list = [];

  List<FaqModel> get list => _list;

  Future<void> getData() async {
    var dbHelper = Helper();
    _list = await dbHelper.getFaq();
    notifyListeners();
  }
}
