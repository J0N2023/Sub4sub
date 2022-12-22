import 'dart:convert';
import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub4sub_2023/config/url.dart';
import 'package:sub4sub_2023/config/warna.dart';

import '../../config/void.dart';
import '../../model/user_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController _nama = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  void _singup() async {
    if(_nama.text.isEmpty) return alertError(context, 'Name cannot be empty');
    if(_email.text.isEmpty) return alertError(context, 'Email cannot be empty');
    if(_password.text.isEmpty) return alertError(context, 'Password cannot be empty');
    Dio dio = Dio();
    Map formData = {
      'nama': _nama.text,
      'email': _email.text,
      'password': _password.text,
      'os': Platform.isAndroid ? 'ANDROID' : 'IOS',
      'signature': generateMd5('signup${_email.text}${_password.text}')
    };
    Response response = await dio.post("$apiUrl/signup",
      data: formData,
    );
    if(response.data['status']) {
      UserModel model = UserModel.fromMap(response.data['akun']);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(model.toMap()));
      prefs.setBool('isLogin', true);
      prefs.setBool('with_google', false);
      context.goNamed('cek_login');
    }else{
      alertError(context, 'Email has been registered');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: merah,
        title: Text('Sign Up'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nama,
            decoration: InputDecoration(
              label: Text('Name'),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              hintText: 'Name',
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: _email,
            decoration: InputDecoration(
              label: Text('Email'),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              label: Text('Password'),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              hintText: 'Password',
            ),
          ),
          SizedBox(height: 10,),
          AnimatedButton(
            color: merah,
            height: 60,
            width: MediaQuery.of(context).size.width - 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text('Sign Up',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onPressed: () {
              _singup();
            },
          ),
        ],
      ),
    );
  }
}
