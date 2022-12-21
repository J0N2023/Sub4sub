
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub4sub_2023/config/const.dart';
import 'package:sub4sub_2023/model/setting_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

String namaChannel(String text){
  if(!text.contains("videoSecondaryInfoRenderer")) return '';
  int cStart = text.indexOf("videoSecondaryInfoRenderer");
  String c1 =  text.substring(cStart);
  int end = c1.indexOf("itemSectionRenderer");
  Map hasil = json.decode('{"${text.substring(cStart, cStart + end - 3)}');
  return hasil['videoSecondaryInfoRenderer']['owner']['videoOwnerRenderer']['title']['runs'][0]['text'];
}

String idChannel(String text){
  if(!text.contains("videoSecondaryInfoRenderer")) return '';
  int cStart = text.indexOf("videoSecondaryInfoRenderer");
  String c1 =  text.substring(cStart);
  int end = c1.indexOf("itemSectionRenderer");
  Map hasil = json.decode('{"${text.substring(cStart, cStart + end - 3)}');
  return hasil['videoSecondaryInfoRenderer']['owner']['videoOwnerRenderer']['title']['runs'][0]['navigationEndpoint']['browseEndpoint']['browseId'];
}

String viewCount(String text){
  if(!text.contains("videoPrimaryInfoRenderer")) return '';
  int cStart = text.indexOf("videoPrimaryInfoRenderer");
  String c1 =  text.substring(cStart);
  int end = c1.indexOf("videoSecondaryInfoRenderer");
  Map hasil = json.decode('{"${text.substring(cStart, cStart + end - 3)}');
  String x = hasil['videoPrimaryInfoRenderer']['viewCount']['videoViewCountRenderer']['viewCount']['simpleText'];
  return x;
}

String thumbnails(String text){
  int cStart = text.indexOf('<meta property="og:image"') + 35;
  String c1 =  text.substring(cStart);
  int end = c1.indexOf(">");
  String x = text.substring(cStart, cStart + end - 1);
  return x;
}

String judulVideo(String text){
  int cStart = text.indexOf('<meta property="og:title"') + 35;
  String c1 =  text.substring(cStart);
  int end = c1.indexOf(">");
  String x = text.substring(cStart, cStart + end - 1);
  return x;
}

String deskripsi(String text){
  int cStart = text.indexOf('<meta property="og:description"') + 41;
  String c1 =  text.substring(cStart);
  int end = c1.indexOf(">");
  String x = text.substring(cStart, cStart + end - 1);
  return x;
}

String idVideo(String text){
  int cStart = text.indexOf('//m.youtube.com/watch?v=');
  String c1 =  text.substring(cStart);
  int end = c1.indexOf(">");
  String x = text.substring(cStart + 24, cStart + end - 1);
  return x;
}

bool statusLogin(String text){
  if(text.contains('"logged_in"')) {
    int cStart = text.indexOf('"logged_in"');
    String x = text.substring(cStart);
    String z = x.replaceAll('\n', '').replaceAll(' ', '');
    int m = 18;
    String a = z.substring(m, m + 1);
    return (a == "1");
  }else{
    return false;
  }
}

bool statusSubscribe(String text){
  int cStart = text.indexOf('subscribed = ');
  String x = text.substring(cStart);
  String z = x.replaceAll('\n', '').replaceAll(' ', '');
  int m = 11;
  String a = z.substring(m, m + 1);
  return (a == "1");
}

bool statusLike(String text){
  int c1 = text.indexOf('segmentedLikeDislikeButtonRenderer');
  String x1 = text.substring(c1);
  // String z = x1.replaceAll('\n', '').replaceAll(' ', '');
  int c2 = x1.indexOf(' likeButton');
  String x2 = x1.substring(c2);
  int c3 = x2.indexOf('isToggled') + 12;
  String a = x2.substring(c3, c3+1);
  return (a == "1");
}

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
  if(!text.contains("displayName")) return '';
  int i1 = text.indexOf("displayName");
  String s1 =  text.substring(i1);
  int i2 = s1.indexOf('simpleText = "');
  String s2 = s1.substring(i2);
  int i3 = s2.indexOf('";');
  return s2.substring(14, i3);
}
String kFormat(int number){
  return NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '',
  ).format(number);
}