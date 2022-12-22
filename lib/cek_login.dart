import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CekLoginPage extends StatefulWidget {
  const CekLoginPage({Key? key}) : super(key: key);

  @override
  State<CekLoginPage> createState() => _CekLoginPageState();
}

class _CekLoginPageState extends State<CekLoginPage> {

  _initProses() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLogin = preferences.containsKey('isLogin');
    (isLogin) ? context.goNamed('main') : context.goNamed('login');
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
