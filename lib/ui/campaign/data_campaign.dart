import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sub4sub_2023/config/load_data.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/model/subscribe_model.dart';
import 'package:sub4sub_2023/providers/subscribe_provider.dart';

import '../../model/campaign_model.dart';

class DataCampaign extends StatefulWidget {
  final CampaignModel model;
  const DataCampaign({Key? key, required this.model}) : super(key: key);

  @override
  State<DataCampaign> createState() => _DataCampaignState();
}

class _DataCampaignState extends State<DataCampaign> {

  _initProvider(){
    context.read<SubscribeProvider>().getData(widget.model.id);
    loadSubscribe();
    Future.delayed(const Duration(milliseconds: 3000), () {
      context.read<SubscribeProvider>().getData(widget.model.id);
    });
  }

  @override
  void initState() {
    _initProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: appBar('Data Campaign'),
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.width / 2,
            child: CachedNetworkImage(
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                errorWidget: (context, url, error) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                imageUrl: widget.model.gambar),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _itemDetail('Target Of Subscribe', '${widget.model.finishSub} Subscribe'),
                _itemDetail('Current Subscribe', '${widget.model.currentSub} Subscribe'),
                _itemDetail('Channel Name', widget.model.channelName),
                _itemDetail('Video Title', widget.model.title),
                _itemDetail('Description', widget.model.deskripsi),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Consumer<SubscribeProvider>(
              builder: (context, data, _) {
                return (data.list.isNotEmpty)
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('List Subscriber', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textHitam
                      ),),
                    ),
                    const SizedBox(height: 5,),
                    ListView.builder(
                      itemCount: data.list.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (BuildContext context, int index) {
                        return _itemSubscribe(data.list[index]);
                      },
                    ),
                  ],
                )
                    : const SizedBox();
              }
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _itemDetail(String title, String value){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(
            color: textHitam,
            fontWeight: FontWeight.bold,

          ),),
          Text(value,
            textAlign: TextAlign.justify,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textHitam,
            ),),
        ],
      ),
    );
  }

  Widget _itemSubscribe(SubscribeModel model){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                    imageUrl: model.avatar),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.channelName, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textHitam
                ),),
                Text(model.createdAt, style: TextStyle(
                  color: textHitam
                ),),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
