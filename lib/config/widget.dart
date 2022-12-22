import 'package:animated_button/animated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sub4sub_2023/config/void.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/model/campaign_model.dart';

import '../providers/user_provider.dart';

Widget itemCampaign(BuildContext context, CampaignModel model, bool showDelete){
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
            (showDelete)
                ? Positioned(
                    top: 10,
                    right: 10,
                    child: AnimatedButton(
                      color: merah,
                      height: 40,
                      width: 40,
                      child: const Icon(Icons.close, color: Colors.white,),
                      onPressed: () {

                      },
                    ),)
                : const SizedBox()
          ],
        ),
      ),
    ),
  );
}

Widget actionButton(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.monetization_on_outlined, color: Colors.white,),
        const SizedBox(width: 2,),
        Consumer<UserProvider>(
          builder: (context, data, _) {
            return Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(formatCoin(data.model.coin), style: const TextStyle(color: Colors.white, fontSize: 18),),
            );
          }
        ),
        const SizedBox(width: 20,),
      ],
    );
}

Widget itemAturanYoutube(String number, String text, Color color){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 15,
        child: Text(number, style: TextStyle(
            color: color
        ),),
      ),
      Expanded(
        child: Text(text, style: TextStyle(
            color: color
        ),),
      ),
    ],
  );
}

PreferredSizeWidget appBar(String title){
  return AppBar(
    backgroundColor: merah,
    centerTitle: false,
    title: Text(title),
    actions: [actionButton()],
  );
}

