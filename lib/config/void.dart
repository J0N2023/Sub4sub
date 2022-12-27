
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
  Map data = json.decode(text);
  String x = data['responseContext']['serviceTrackingParams'][1]['params'][0]['value'];
  return (x == "1");
}

bool statusSubscribe(String text){
  Map data = json.decode(text);
  bool isSubscribe = data['contents']['twoColumnWatchNextResults']['results']['results']['contents'][1]['videoSecondaryInfoRenderer']['subscribeButton']['subscribeButtonRenderer']['subscribed'];
  return isSubscribe;
}

bool statusLike(String text){
  Map data = json.decode(text);
  bool isLike = data['contents']['twoColumnWatchNextResults']['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['videoActions']['menuRenderer']['topLevelButtons'][0]['segmentedLikeDislikeButtonRenderer']['likeButton']['toggleButtonRenderer']['isToggled'];
  return isLike;
}


// ------------------------------------------------------------------------------

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

// ------------------------------------------------------------------------------

Future<String> myChannelId(String text) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if(!text.contains('community?show_create_dialog')){
    UserModel model = await getUser();
    preferences.setString('id_channel', model.email);
    return model.email;
  }
  Map data = json.decode(text);
  String x = data
  ['topbar']
  ['desktopTopbarRenderer']
  ['topbarButtons']
  [0]
  ['topbarMenuButtonRenderer']
  ['menuRenderer']
  ['multiPageMenuRenderer']
  ['sections']
  [0]
  ['multiPageMenuSectionRenderer']
  ['items']
  [2]
  ['compactLinkRenderer']
  ['navigationEndpoint']
  ['browseEndpoint']
  ['browseId'];

  preferences.setString('id_channel', x);
  return x;
}


String myAvatar(String text){
  Map data = json.decode(text);
  String x = data
  ['topbar']
  ['desktopTopbarRenderer']
  ['topbarButtons']
  [2]
  ['topbarMenuButtonRenderer']
  ['avatar']
  ['thumbnails']
  [0]
  ['url'] ?? "";
  return x;
}

Future<String> idChannelTersimpan() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if(!preferences.containsKey('id_channel')) return 'xxx';
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

String extracString(String text){
  if(!text.contains('var ytInitialData')) return 'Tidak ditemukan';
  int tanda = text.indexOf('var ytInitialData') + 20;
  String hasil = text.substring(tanda);
  hasil = hasil.substring(0, hasil.indexOf('</script>') - 1);
  return hasil;
}