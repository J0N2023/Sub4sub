import 'package:flutter/material.dart';
import 'package:sub4sub_2023/config/helper.dart';
import 'package:sub4sub_2023/model/campaign_model.dart';


class CurrentCampaignProvider with ChangeNotifier {
  List<CampaignModel> _list = [];

  List<CampaignModel> get list => _list;

  Future<void> getData() async {
    var dbHelper = Helper();
    _list = await dbHelper.getCurrentCampaign();
    notifyListeners();
  }
}
