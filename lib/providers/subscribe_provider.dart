import 'package:flutter/material.dart';
import 'package:sub4sub_2023/config/helper.dart';
import 'package:sub4sub_2023/model/subscribe_model.dart';


class SubscribeProvider with ChangeNotifier {
  List<SubscribeModel> _list = [];

  List<SubscribeModel> get list => _list;

  Future<void> getData(int idCampaign) async {
    var dbHelper = Helper();
    _list = await dbHelper.getSubscribe(idCampaign);
    notifyListeners();
  }
}
