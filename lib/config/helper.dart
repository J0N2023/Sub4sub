import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io' as io;

import 'package:sub4sub_2023/model/campaign_model.dart';
import 'package:sub4sub_2023/model/chat_model.dart';
import 'package:sub4sub_2023/model/faq_model.dart';
import 'package:sub4sub_2023/model/subscribe_model.dart';

import '../model/halaman_model.dart';
import '../model/statisitic_model.dart';

class Helper {
  static final Helper _instance = Helper.internal();

  factory Helper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "sub4sub_9.db");
    var theDb = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          create table campaign (
          id_table integer primary key autoincrement, 
          id integer,
          id_user integer,
          id_channel text,
          channel_name text,
          id_video text,
          title text,
          deskripsi text,
          current_sub integer,
          finish_sub integer,
          gambar text,
          last_view text,
          created_at text,
          updated_at text
          )'''); // campaign
      await db.execute('''
          create table faq (
          id_table integer primary key autoincrement, 
          id integer,
          pertanyaan text,
          jawaban text,
          created_at text,
          updated_at text
          )'''); // faq
      await db.execute('''
          create table halaman (
          id_table integer primary key autoincrement, 
          id integer,
          nama text,
          isi text,
          created_at text,
          updated_at text
          )'''); // Halaman
      await db.execute('''
          create table chat (
          id_table integer primary key autoincrement, 
          id integer,
          id_user integer,
          pair text,
          pesan text,
          created_at text,
          updated_at text,
          nama text
          )'''); // Chat
      await db.execute('''
          create table subscribe (
          id_table integer primary key autoincrement, 
          id integer,
          id_campaign integer,
          email text,
          channel_subscriber text,
          channel_name text,
          avatar text,
          created_at text,
          updated_at text
          )'''); // Subscribe

    });
    return theDb;
  }

  Helper.internal();

  //----------------------------------------------------------------------------

  Future<String> getUpdateCampaign() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT updated_at FROM campaign ORDER BY updated_at DESC");
    String up;
    if(result.isEmpty){
      up = "2000-02-02 02:02:02";
    }else{
      up = "${result[0]['updated_at']}";
    }
    return up;
  }

  Future<bool> insertCampaign(List<CampaignModel> newData, String allID, String newID) async {
    var dbClient = await db;
    await dbClient.rawQuery("DELETE FROM campaign WHERE id NOT IN ($allID)");
    await dbClient.rawQuery("DELETE FROM campaign WHERE id IN ($newID)");
    Batch batch = dbClient.batch();
    for (var element in newData) {
      batch.insert('campaign', element.toMap());
    }
    await batch.commit();
    return true;
  }

  Future<List<CampaignModel>> getCampaign() async {
    var dbClient = await db;
    List<CampaignModel> list = [];
    List<Map> maps = await dbClient.query('campaign', orderBy: 'id DESC');
    for (var element in maps) {
      CampaignModel model = CampaignModel.fromMap(element);
      list.add(model);
    }
    return list;
  }

  Future<List<CampaignModel>> getCurrentCampaign() async {
    var dbClient = await db;
    List<CampaignModel> list = [];
    List<Map> maps = await dbClient.query('campaign', orderBy: 'id DESC', where: 'finish_sub > current_sub');
    for (var element in maps) {
      CampaignModel model = CampaignModel.fromMap(element);
      list.add(model);
    }
    return list;
  }

  Future<StatisticModel> getStatistic() async {
    var dbClient = await db;
    List<Map> c = await dbClient.query('campaign', where: 'finish_sub > current_sub');
    List<Map> f = await dbClient.query('campaign', where: 'finish_sub <= current_sub');
    return StatisticModel(current: c.length, finish: f.length);
  }

  //----------------------------------------------------------------------------

  Future<String> getUpdateFaq() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT updated_at FROM faq ORDER BY updated_at DESC");
    String up;
    if(result.isEmpty){
      up = "2000-02-02 02:02:02";
    }else{
      up = "${result[0]['updated_at']}";
    }
    return up;
  }

  Future<bool> insertFaq(List<FaqModel> newData, String allID, String newID) async {
    var dbClient = await db;
    await dbClient.rawQuery("DELETE FROM faq WHERE id NOT IN ($allID)");
    await dbClient.rawQuery("DELETE FROM faq WHERE id IN ($newID)");
    Batch batch = dbClient.batch();
    for (var element in newData) {
      batch.insert('faq', element.toMap());
    }
    await batch.commit();
    return true;
  }

  Future<List<FaqModel>> getFaq() async {
    var dbClient = await db;
    List<FaqModel> list = [];
    List<Map> maps = await dbClient.query('faq', orderBy: 'pertanyaan');
    for (var element in maps) {
      FaqModel model = FaqModel.fromMap(element);
      list.add(model);
    }
    return list;
  }

  //----------------------------------------------------------------------------

  Future<String> getUpdateHalaman() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT updated_at FROM halaman ORDER BY updated_at DESC");
    String up;
    if(result.isEmpty){
      up = "2000-02-02 02:02:02";
    }else{
      up = "${result[0]['updated_at']}";
    }
    return up;
  }

  Future<bool> insertHalaman(List<HalamanModel> newData, String allID, String newID) async {
    var dbClient = await db;
    await dbClient.rawQuery("DELETE FROM halaman WHERE id NOT IN ($allID)");
    await dbClient.rawQuery("DELETE FROM halaman WHERE id IN ($newID)");
    Batch batch = dbClient.batch();
    for (var element in newData) {
      batch.insert('halaman', element.toMap());
    }
    await batch.commit();
    return true;
  }

  Future<HalamanModel> getHalaman(String nama) async {
    var dbClient = await db;
    HalamanModel model = HalamanModel(
      id: 0,
      nama: "",
      isi: "",
      createdAt: "",
      updatedAt: "",
    );
    List<Map> maps = await dbClient.query('halaman', where: 'nama = ?', whereArgs: [nama]);
    if(maps.isNotEmpty) return HalamanModel.fromMap(maps[0]);
    return model;
  }

  //----------------------------------------------------------------------------

  Future<String> getUpdateChat() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT updated_at FROM chat ORDER BY updated_at DESC");
    String up;
    if(result.isEmpty){
      up = "2000-02-02 02:02:02";
    }else{
      up = "${result[0]['updated_at']}";
    }
    return up;
  }

  Future<bool> insertChat(List<ChatModel> newData, String allID, String newID) async {
    var dbClient = await db;
    await dbClient.rawQuery("DELETE FROM chat WHERE id NOT IN ($allID)");
    await dbClient.rawQuery("DELETE FROM chat WHERE id IN ($newID)");
    Batch batch = dbClient.batch();
    for (var element in newData) {
      batch.insert('chat', element.toMap());
    }
    await batch.commit();
    return true;
  }

  Future<List<ChatModel>> getChat() async {
    var dbClient = await db;
    List<ChatModel> list = [];
    List<Map> maps = await dbClient.query('chat', orderBy: 'id DESC');
    for (var element in maps) {
      ChatModel model = ChatModel.fromMap(element);
      list.add(model);
    }
    return list;
  }

  //----------------------------------------------------------------------------

  Future<String> getUpdateSubscribe() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT updated_at FROM subscribe ORDER BY updated_at DESC");
    String up;
    if(result.isEmpty){
      up = "2000-02-02 02:02:02";
    }else{
      up = "${result[0]['updated_at']}";
    }
    return up;
  }

  Future<bool> insertSubscribe(List<SubscribeModel> newData, String allID, String newID) async {
    var dbClient = await db;
    await dbClient.rawQuery("DELETE FROM subscribe WHERE id NOT IN ($allID)");
    await dbClient.rawQuery("DELETE FROM subscribe WHERE id IN ($newID)");
    Batch batch = dbClient.batch();
    for (var element in newData) {
      batch.insert('subscribe', element.toMap());
    }
    await batch.commit();
    return true;
  }

  Future<List<SubscribeModel>> getSubscribe(int idCampaign) async {
    var dbClient = await db;
    List<SubscribeModel> list = [];
    List<Map> maps = await dbClient.query('subscribe', where: 'id_campaign = $idCampaign');
    for (var element in maps) {
      SubscribeModel model = SubscribeModel.fromMap(element);
      list.add(model);
    }
    return list;
  }

  //----------------------------------------------------------------------------

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}