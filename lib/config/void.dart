
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub4sub_2023/config/const.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/model/setting_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/user_model.dart';

bool statusLogin(String text){
  Map map = stringToMap(text);
  String value = map['responseContext']['serviceTrackingParams'][1]['params'][0]['value'].toString();
  print("Status Login : $value");
  return (value == "1");
}

bool statusSubscribe(String text){
  Map map = stringToMap(text);
  bool isSubscribe = map['contents']['twoColumnWatchNextResults']['results']['results']['contents'][1]['videoSecondaryInfoRenderer']['subscribeButton']['subscribeButtonRenderer']['subscribed'];
  print("Subscribe : $isSubscribe");
  return isSubscribe;
}

bool statusLike(String text){
  Map map = stringToMap(text);
  bool isLike = map['contents']['twoColumnWatchNextResults']['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['videoActions']['menuRenderer']['topLevelButtons'][0]['segmentedLikeDislikeButtonRenderer']['likeButton']['toggleButtonRenderer']['isToggled'];
  print("Like : $isLike");
  return isLike;
}

String namaChannelKampanye(String text){
  if(!text.contains("videoSecondaryInfoRenderer")) return '';
  int cStart = text.indexOf("videoSecondaryInfoRenderer");
  String c1 =  text.substring(cStart);
  int end = c1.indexOf("itemSectionRenderer");
  Map hasil = json.decode('{"${text.substring(cStart, cStart + end - 3)}');
  return hasil['videoSecondaryInfoRenderer']['owner']['videoOwnerRenderer']['title']['runs'][0]['text'];
}

String idChannelKampanye(String text){
  if(!text.contains("videoSecondaryInfoRenderer")) return '';
  int cStart = text.indexOf("videoSecondaryInfoRenderer");
  String c1 =  text.substring(cStart);
  int end = c1.indexOf("itemSectionRenderer");
  Map hasil = json.decode('{"${text.substring(cStart, cStart + end - 3)}');
  return hasil['videoSecondaryInfoRenderer']['owner']['videoOwnerRenderer']['title']['runs'][0]['navigationEndpoint']['browseEndpoint']['browseId'];
}

String thumbnailsKampanye(String text){
  int cStart = text.indexOf('<meta property="og:image"') + 35;
  String c1 =  text.substring(cStart);
  int end = c1.indexOf(">");
  String x = text.substring(cStart, cStart + end - 1);
  return x;
}

String judulKampanye(String text){
  int cStart = text.indexOf('<meta property="og:title"') + 35;
  String c1 =  text.substring(cStart);
  int end = c1.indexOf(">");
  String x = text.substring(cStart, cStart + end - 1);
  return x;
}

String deskripsiKampanye(String text){
  int cStart = text.indexOf('<meta property="og:description"') + 41;
  String c1 =  text.substring(cStart);
  int end = c1.indexOf(">");
  String x = text.substring(cStart, cStart + end - 1);
  return x;
}

String idVideoKampanye(String text){
  int cStart = text.indexOf('//m.youtube.com/watch?v=');
  String c1 =  text.substring(cStart);
  int end = c1.indexOf(">");
  String x = text.substring(cStart + 24, cStart + end - 1);
  return x;
}

Future<String> myChannel(String text) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if(text.contains('community?show_create_dialog')) {
    int cari1 = text.indexOf('community?show_create_dialog');
    String x = text.substring(cari1 - 100, cari1 - 1);
    String id = x.substring(x.indexOf('/channel/') + 9);
    preferences.setString('id_channel', id);
    return id;
  }else{
    preferences.setString('id_channel', 'xxx');
    return 'xxx';
  }
}

Future<String> myIdChannel() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('id_channel')!;
}

// ------------------------------------------------------------------------------

Future<String> readJS(WebViewController controller) async{
  const script = "ytInitialData";
  String html = await controller.runJavascriptReturningResult(script);
  return html;
}

Future<String> readHtml(WebViewController controller) async{
  const script = "document.documentElement.outerHTML";
  String html = await controller.runJavascriptReturningResult(script);
  return html;
}

String formatCoin(int n) {
  final formatter = NumberFormat("#,###");
  return formatter.format(n);
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

Future<SettingModel> getSetting() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Map json = jsonDecode(preferences.getString('setting')!);
  return SettingModel.fromMap(json);
}

Future<void> bukaWeb(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

int appVersi(){
  if(Platform.isAndroid) {
    return androidAppVersion;
  }else{
    return iosAppVersion;
  }
}

String myAvatar(String text){
  if(!text.contains("userAvatar")) return '';
  int cStart = text.indexOf("userAvatar");
  String c1 =  text.substring(cStart);
  int cStart2 = c1.indexOf("url");
  String c2 =  c1.substring(cStart2);
  String x = c2.substring(7);
  int cStart3 = x.indexOf('"');
  return x.substring(0, cStart3);
}

String myChannelName(String text){
  String chName = text;
  if(!text.contains("displayName")) return 'xxx';
  int tanda = text.indexOf('displayName');
  chName = chName.substring(tanda);
  int stringStart = chName.indexOf('{');
  int stringEnd = chName.indexOf('}') + 1;
  Map hasil = json.decode(chName.substring(stringStart, stringEnd));
  return hasil['simpleText'];
}

String kFormat(int number){
  return NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '',
  ).format(number);
}

alertError(BuildContext context, String pesan) {
  return Alert(
    context: context,
    type: AlertType.error,
    title: "Ups !",
    desc: pesan,
    buttons: [
      DialogButton(
          onPressed: () => Navigator.pop(context),
          color: merah,
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
    ],
  ).show();
}

Future<bool> withGoogle() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('with_google')!;
}

Future<UserModel> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  Map json = jsonDecode(prefs.getString('user')!);
  UserModel model = UserModel.fromMap(json);
  return model;
}

Map stringToMap(String text){
  int tanda = text.indexOf('var ytInitialData') + 20;
  String hasil = text.substring(tanda);
  hasil = hasil.substring(0, hasil.indexOf('</script>') - 1);
  return json.decode(hasil);
}