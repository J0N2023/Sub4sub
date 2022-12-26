import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sub4sub_2023/config/url.dart';
import 'package:sub4sub_2023/config/void.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/model/campaign_model.dart';
import 'package:sub4sub_2023/ui/youtube/youtube_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';

class DetailCampaign extends StatefulWidget {
  final CampaignModel model;
  const DetailCampaign({Key? key, required this.model}) : super(key: key);

  @override
  State<DetailCampaign> createState() => _DetailCampaignState();
}

class _DetailCampaignState extends State<DetailCampaign> {

  final String _newUA= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36";
  late final WebViewController _controller;
  bool _cekAksi = false;
  double _progress = 0;
  int _statusSubcribe = 0;
  int _statusLike = 0;
  bool _allDone = false;
  bool _showDialog = false;
  bool _goAgain = false;

  String html = "";

  _claimCoin(String id, String chName, String avatar)  async {
    UserModel userModel = await getUser();
    String email = userModel.email;
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'id_campaign': widget.model.id,
      'email': email,
      'channel_subscriber': id,
      'channel_name': chName,
      'avatar': avatar,
      'signature': generateMd5('claim${widget.model.id}$email$id')
    });
    Response response = await dio.post("$apiUrl/claim_coin",
      data: formData,
    );
    if(response.data) {
      _reloadProvider();
    }
  }

  _reloadProvider(){
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<UserProvider>().getData();
    });
  }

  _skip() async {
    UserModel userModel = await getUser();
    context.goNamed('loading_campaign', params: {'email': userModel.email});
  }

  _prosesCek(String hasil) async {
    String x = (Platform.isIOS) ? extracString(hasil) : hasil;

    // print("Is Login : ${statusLogin(x)}");
    // print("Subscribe : ${statusSubscribe(x)}");
    // print("Like : ${statusLike(x)}");
    // print("MyAvatar : ${myAvatar(x)}");
    // print("My Channel Name : ${myChannelName(x)}");
    // String idCh = await myChannelId(x);
    // print("My Channel ID : ${idCh}");

    bool ss = statusSubscribe(x);
    bool sl = statusLike(x);
    _statusSubcribe = (ss) ? 1 : 2;
    _statusLike = (sl) ? 1 : 2;
    _allDone = (ss && sl);
    if(_allDone) {
      String id = await myChannelId(x);
      String chName = myChannelName(x);
      String avatar = myAvatar(x);
      _claimCoin(id, chName, avatar);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: appBar('Detail Campaign'),
      body: Stack(
        children: [
          ListView(
            children: [
              (_cekAksi)
                  ? SizedBox(
                      height: 0,
                      width: 0,
                      child: WebView(
                        userAgent: _newUA,
                        initialUrl: 'https://m.youtube.com/watch?v=${widget.model.idVideo}',
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController webViewController) async {
                          _controller = webViewController;
                        },
                        onProgress: (int progress) {
                          setState(() {
                            _progress = progress.ceilToDouble();
                            _goAgain = (progress == 100);
                          });
                        },
                        navigationDelegate: (NavigationRequest request) {
                          return NavigationDecision.navigate;
                        },
                        onPageStarted: (String url) {

                        },
                        onPageFinished: (String url) async {
                          if(Platform.isAndroid) {
                            html = await readJS(_controller);
                          }else{
                            html = await readHtml(_controller);
                          }
                          _prosesCek(html);
                        },
                        gestureNavigationEnabled: true,
                        backgroundColor: const Color(0x00000000),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.6,
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                    imageUrl: widget.model.gambar),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.model.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: textHitam,
                          height: 1
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 5,),
                    Text(widget.model.channelName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textHitam,
                          height: 1
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 20,),
                    Text(widget.model.deskripsi,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: textHitam,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 110,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Instructions', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: textHitam
                          ),),
                          itemAturanYoutube('1.', 'Please wait until the countdown finishes', textHitam),
                          itemAturanYoutube('2.', 'Like and subscribe this channel', textHitam),
                          itemAturanYoutube('3.', 'Click OK to confirm your subscribe', textHitam),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedButton(
                      color: Colors.grey,
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Text('Skip',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _skip();
                      },
                    ),
                    AnimatedButton(
                      color: merah,
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Text('Go !',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _cekAksi = false;
                          _showDialog = true;
                        });
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePage(urlYoutube: 'https://m.youtube.com/watch?v=${widget.model.idVideo}')));
                        setState(() {
                          _cekAksi = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          (_showDialog)
              ? Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: (_allDone) ? _cekDone() : _cekStatus()
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _cekStatus(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text('Checking like and subscribe', style: TextStyle(
              color: textHitam,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),),
        ),
        const SizedBox(height: 10,),
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: CircularPercentIndicator(
              radius: 60.0,
              animation: false,
              lineWidth: 10.0,
              percent: _progress/100,
              center: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("${_progress.toStringAsFixed(0)}%",
                  style: const TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              circularStrokeCap: CircularStrokeCap.square,
              backgroundColor: Colors.red,
              progressColor: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 10,),
        _itemCheck(_statusLike, 'Like'),
        const SizedBox(height: 5,),
        _itemCheck(_statusSubcribe, 'Subscribe'),
        const SizedBox(height: 20,),
        (_goAgain)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedButton(
                    color: Colors.grey,
                    height: 50,
                    width: (MediaQuery.of(context).size.width - 150) / 2,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text('Skip',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _skip();
                    },
                  ),
                  AnimatedButton(
                    color: merah,
                    height: 50,
                    width: (MediaQuery.of(context).size.width - 150) / 2,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text('Go again',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePage(urlYoutube: 'https://m.youtube.com/watch?v=${widget.model.idVideo}')));
                      _controller.reload();
                    },
                  ),
                ],
              )
            : const SizedBox()
      ],
    );
  }

  Widget _cekDone(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text('Like and subscribe successful, you get coin reward',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textHitam,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),),
        ),
        const SizedBox(height: 10,),
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: LottieBuilder.asset('assets/img/lottie/coins.zip'),
          ),
        ),
        const SizedBox(height: 10,),
        _itemCheck(1, 'Like'),
        const SizedBox(height: 5,),
        _itemCheck(1, 'Subscribe'),
        const SizedBox(height: 20,),
        Center(
          child: AnimatedButton(
            color: merah,
            height: 50,
            width: 170,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text('Next Campaign',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            onPressed: () async {
              UserModel userModel = await getUser();
              context.goNamed('loading_campaign', params: {
                'email':  userModel.email
              });
            },
          ),
        )
      ],
    );
  }

  Widget _itemCheck(int stat, String title){
    Widget icon = const SizedBox();
    switch (stat) {
      case 0:
        icon = const Icon(Icons.hourglass_empty_rounded, color: Colors.amber, size: 20);
        break;
      case 1:
        icon = const Icon(Icons.check, color: Colors.green, size: 20);
        break;
      case 2:
        icon = const Icon(Icons.close, color: Colors.red, size: 20);
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 10,),
        Text(title, style: TextStyle(
          color: textHitam,
          fontSize: 18
        ),)
      ],
    );
  }

}
