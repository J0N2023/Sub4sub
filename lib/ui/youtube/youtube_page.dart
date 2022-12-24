import 'dart:async';

import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/warna.dart';
import '../../config/widget.dart';

class YoutubePage extends StatefulWidget {
  final String urlYoutube;
  const YoutubePage({Key? key, required this.urlYoutube}) : super(key: key);

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {

  bool _isCoundown = true;
  bool _inVideo = true;

  late final WebViewController _controller;

  Timer? _timer;
  int _waktu = 3;
  final int _durasi = 3;

  void _waktuTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_waktu == 0) {
          setState(() {
            timer.cancel();
            _isCoundown = false;
          });
        } else {
          setState(() {
            _waktu--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }


  @override
  void initState() {
    _waktuTimer();
    super.initState();
  }

  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (_waktu < 1) ? true : false;
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: WebView(
                  initialUrl: widget.urlYoutube,
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) {
                    if(request.url.startsWith('https://accounts')){
                      _inVideo = false;
                    }else{
                      _inVideo = true;
                    }
                    return NavigationDecision.navigate;
                  },
                  onWebViewCreated: (WebViewController webViewController) async {
                    _controller = webViewController;
                  },
                  onPageStarted: (String text){
                    print(text);
                  },
                  onPageFinished: (String url) async {
                    const script = 'var video = document.querySelector("video");video.play();';
                    // _controller.runJavascriptReturningResult(script);
                  },
                  gestureNavigationEnabled: true,
                  backgroundColor: const Color(0x00000000),
                ),
              ),
              (_inVideo)
                ? (_isCoundown)
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.black.withOpacity(0),
                            height: 60,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.5,
                          ),
                          Expanded(child: InkWell(
                              onTap: (){},
                              child: Container(
                                color: Colors.red.withOpacity(0),
                              ))),
                          Container(
                            color: Colors.black.withOpacity(0.8),
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 20,),
                                    SizedBox(
                                      width: 100,
                                      child: CircularPercentIndicator(
                                        radius: 50.0,
                                        animation: false,
                                        lineWidth: 10.0,
                                        percent: _waktu / _durasi,
                                        center: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(_waktu.toString(),
                                            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        circularStrokeCap: CircularStrokeCap.square,
                                        backgroundColor: Colors.green,
                                        progressColor: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 140,
                                      child:  const Text('Please wait until the countdown finishes',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.white,
                                          height: 1
                                      ),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Expanded(child: SizedBox()),
                          Container(
                            color: Colors.black.withOpacity(0.8),
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: LottieBuilder.asset('assets/img/lottie/like.zip'),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - 110,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Instructions', style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: Colors.white
                                                ),),
                                                itemAturanYoutube('1.', 'Like and subscribe this channel', Colors.white),
                                                itemAturanYoutube('2.', 'Click Claim your coin', Colors.white),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: AnimatedButton(
                                        color: merah,
                                        height: 50,
                                        width: MediaQuery.of(context).size.width - 30,
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Center(
                                            child: Text('Claim your coin',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

}
