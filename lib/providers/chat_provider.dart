import 'package:flutter/material.dart';
import 'package:sub4sub_2023/config/helper.dart';
import 'package:sub4sub_2023/model/chat_model.dart';


class ChatProvider with ChangeNotifier {
  List<ChatModel> _list = [];

  List<ChatModel> get list => _list;

  Future<void> getData() async {
    var dbHelper = Helper();
    _list = await dbHelper.getChat();
    notifyListeners();
  }
}
