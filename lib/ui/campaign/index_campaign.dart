import 'package:animated_button/animated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sub4sub_2023/config/load_data.dart';
import 'package:sub4sub_2023/config/url.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/providers/current_campaign_provider.dart';
import 'package:sub4sub_2023/providers/my_campaign_provider.dart';
import 'package:sub4sub_2023/providers/user_provider.dart';
import 'package:sub4sub_2023/ui/campaign/create_campaign.dart';

import '../../config/void.dart';
import '../../model/campaign_model.dart';

class IndexCampaign extends StatefulWidget {
  const IndexCampaign({Key? key}) : super(key: key);

  @override
  State<IndexCampaign> createState() => _IndexCampaignState();
}

class _IndexCampaignState extends State<IndexCampaign> {

  _initProvider(){
    loadMyCampaign();
    Future.delayed(const Duration(milliseconds: 1500), () {
      context.read<MyCampaignProvider>().getData();
      context.read<CurrentCampaignProvider>().getData();
      context.read<UserProvider>().getData();
    });
  }

  void _delete(int idCampaign) async {
    Dio dio = Dio();
    Map formData = {
      'id_campaign': idCampaign,
      'signature': generateMd5('delete_campaign$idCampaign')
    };
    Response response = await dio.post("$apiUrl/delete_campaign",
      data: formData,
    );
    if(response.data) {
      _initProvider();
    }
  }

  _alertDelete(int idCampaign) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Warning !",
      desc: "Are you sure to delete this campaign ?",
      buttons: [
        DialogButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.grey,
            child: const Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
        DialogButton(
          color: merah,
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            context.pop();
            _delete(idCampaign);
          },
        )
      ],
    ).show();
  }

  @override
  void initState() {
    context.read<MyCampaignProvider>().getData();
    _initProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Campaign'),
      floatingActionButton: AnimatedButton(
        color: merah,
        height: 60,
        width: 180,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Text('Create Campaign',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateCampaign()));
          _initProvider();
        },
      ),
      body: Consumer<MyCampaignProvider>(
        builder: (context, data, _) {
          return (data.list.isNotEmpty)
              ? ListView.builder(
                  itemCount: data.list.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    return _itemCampaign(data.list[index]);
                  },
                )
              : Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LottieBuilder.asset('assets/img/lottie/no_data.zip'),
                  const SizedBox(height: 20,),
                  Text('No campaign yet', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textHitam
                  ),)
                ],
              ));
        }
      ),
    );
  }

  Widget _itemCampaign(CampaignModel model){
    return InkWell(
      onTap: (){
        context.goNamed('data_campaign', extra: model);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.5,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                      imageUrl: model.gambar),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularPercentIndicator(
                          radius: 30.0,
                          animation: true,
                          animationDuration: 2000,
                          lineWidth: 5.0,
                          percent: ((model.currentSub/model.finishSub) > 1) ? 1 : model.currentSub/model.finishSub,
                          center: Text(
                            "${model.currentSub}/${model.finishSub}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.red,
                          progressColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(model.channelName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  height: 1
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5,),
                            Text(model.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  height: 1
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedButton(
                  color: merah,
                  height: 40,
                  width: 40,
                  child: const Icon(Icons.close, color: Colors.white,),
                  onPressed: () {
                    _alertDelete(model.id);
                  },
                ),)
            ],
          ),
        ),
      ),
    );
  }
}
