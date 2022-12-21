import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sub4sub_2023/config/warna.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GoogleSignInAccount? _currentUser;


  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      print(account!.displayName);
      setState(() {
        _currentUser = account;
        context.goNamed('main');
      });
    });
    googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = _currentUser;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
              child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LottieBuilder.asset('assets/img/lottie/subscribe.zip'),
                Text('Sub4sub Pro 2023', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                  color: textHitam
                ),),
                Text('More like, view and subscribe for your channel', style: TextStyle(
                  color: textHitam,
                  height: 0.8
                ),),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: AnimatedButton(
              color: merah,
              height: 60,
              width: 230,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/img/icon/google_putih.png')),
                      const SizedBox(width: 10,),
                      Text((user != null) ? 'Hi, ${user.displayName}' : 'Login with Google',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onPressed: () {
                if(user != null){
                  // _handleSignOut();
                }else{
                  _handleSignIn();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
