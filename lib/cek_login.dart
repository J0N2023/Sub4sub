import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub4sub_2023/config/load_data.dart';
import 'package:sub4sub_2023/providers/setting_provider.dart';

class CekLoginPage extends StatefulWidget {
  const CekLoginPage({Key? key}) : super(key: key);

  @override
  State<CekLoginPage> createState() => _CekLoginPageState();
}

class _CekLoginPageState extends State<CekLoginPage> {

  _initProses() async {
    await loadSetting();
    _go();
  }

  _go(){
    Future.delayed(const Duration(milliseconds: 500), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool isLogin = preferences.containsKey('isLogin');
      context.read<SettingProvider>().getData();
      (isLogin) ? context.goNamed('main') : context.goNamed('login');
    });
  }

  @override
  void initState() {
    _initProses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: SizedBox(
              width: 300,
              child: Image.asset('assets/img/icon/logo.png')),
        ),
      ),
    );
  }
}
