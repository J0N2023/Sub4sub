import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sub4sub_2023/config/void.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/model/campaign_model.dart';

import '../../config/url.dart';

class LoadingCampaign extends StatefulWidget {
  final String email;
  const LoadingCampaign({Key? key, required this.email}) : super(key: key);

  @override
  State<LoadingCampaign> createState() => _LoadingCampaignState();
}

class _LoadingCampaignState extends State<LoadingCampaign> {

  _initData() async {
    String idCh = await idChannelTersimpan();
    Dio dio = Dio();
    Response response = await dio.get("$apiUrl/load_campaign/${widget.email}/$idCh");
    if(response.data['status']){
      CampaignModel model = CampaignModel.fromMap(response.data['campaign']);
      _goDetail(model);
    }else{
      _goHome();
    }
  }

  _goDetail(CampaignModel model){
    context.goNamed('detail_campaign', extra: model);
  }

  _goHome(){
    context.goNamed('no_campaign');
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset('assets/img/lottie/subscribe.zip'),
            Text('Please wait ...', style: TextStyle(
              fontSize: 22,
              color: textHitam,
            ),)
          ],
        ),
      ),
    );
  }
}
