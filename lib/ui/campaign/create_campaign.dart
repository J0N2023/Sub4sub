import 'package:animated_button/animated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sub4sub_2023/config/url.dart';
import 'package:sub4sub_2023/config/void.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/main.dart';
import 'package:sub4sub_2023/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import '../../config/warna.dart';

class CreateCampaign extends StatefulWidget {
  const CreateCampaign({Key? key}) : super(key: key);

  @override
  State<CreateCampaign> createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {

  final TextEditingController _urlVideo = TextEditingController();
  final TextEditingController _getSubscribe = TextEditingController();
  final TextEditingController _cost = TextEditingController();

  bool _errorCoin = false;
  bool _errorCreate = true;
  bool _foundVideo = false;

  String _idChannel = '';
  String _nameChannel = '';
  String _idVideo = '';
  String _title = '';
  String _deskripsi = '';
  String _thumbnails = '';

  void _makeRequest() async{
    if(!_urlVideo.text.contains('https')) _urlVideo.text = 'https://${_urlVideo.text}';
    var response = await http.get(Uri.parse(_urlVideo.text));
    if(response.statusCode == 200){
      _nameChannel = namaChannel(response.body);
      _idChannel = idChannel(response.body);
      _title = judulVideo(response.body);
      _deskripsi = deskripsi(response.body);
      _idVideo = idVideo(response.body);
      _thumbnails = thumbnails(response.body);
      setState(() {
        _foundVideo = (_idChannel != '');
        if(_idChannel == '') _error();
      });
    }
  }

  _error() {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Ops !",
      desc: "Video not found",
      buttons: [
        DialogButton(
          color: merah,
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            context.pop();
          },
        )
      ]
    ).show();
  }

  void _createCampaign() async {
    String email = googleSignIn.currentUser!.email;
    Dio dio = Dio();

    Map formData = {
      'email': email,
      'id_channel': _idChannel,
      'channel_name': _nameChannel.trim(),
      'id_video': _idVideo,
      'title': _title.trim(),
      'deskripsi': _deskripsi.trim(),
      'finish_sub': _getSubscribe.text,
      'gambar': _thumbnails,
      'signature': generateMd5('create_campaign$_idChannel$_idVideo')
    };
    Response response = await dio.post("$apiUrl/create_campaign",
      data: formData,
    );
    if(response.data) {
      _pop();
    }
  }

  void _pop(){
    context.pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: appBar('Create Campaign'),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlVideo,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: 'Enter URL / Link Youtube Video',
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                AnimatedButton(
                  color: merah,
                  height: 60,
                  width: 60,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Icon(Icons.search_rounded, color: Colors.white,),
                    ),
                  ),
                  onPressed: () {
                    _makeRequest();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _itemDetail('How to get URL/link Youtube video', 'Open your video in YouTube -> Share button -> Copy link')
            ),
          ),
          (_foundVideo)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width / 2,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                              errorWidget: (context, url, error) => Image.asset('assets/img/banner/placeholder.webp', fit: BoxFit.cover),
                              imageUrl: _thumbnails),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    _itemDetail('Channel Name', _nameChannel),
                    _itemDetail('Video Title', _title),
                    _itemDetail('Description', _deskripsi),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Consumer<UserProvider>(
                              builder: (context, data, _) {
                                return TextField(
                                  controller: _getSubscribe,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value){
                                    int c = (value.isNotEmpty) ? int.parse(_getSubscribe.text) : 0;
                                    int cost = c * 100;
                                    _cost.text = '${formatCoin(cost)} Coins';
                                    setState(() {
                                      _errorCoin = (cost > data.model.coin);
                                      _errorCreate = (c < 5 || (cost > data.model.coin));
                                    });
                                  },
                                  decoration: InputDecoration(
                                    label: const Text('Number of Subscribe'),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    hintText: 'min: 5',
                                  ),
                                );
                              }
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              controller: _cost,
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                label: const Text('Total Cost'),
                                // errorText: (_errorCoin) ? 'Coins are not enough' : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    AnimatedButton(
                      color: (_errorCreate) ? Colors.grey.shade400 : merah,
                      height: 60,
                      width: MediaQuery.of(context).size.width - 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Text(
                            (_errorCreate)
                                ? (_errorCoin) ? 'Coins are not enough' :'Min. 5 Subscribe'
                                : 'Create',
                            style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),),
                        ),
                      ),
                      onPressed: () {
                        if(!_errorCreate){
                          _createCampaign();
                        }
                      },
                    ),
                  ],
                )
              : const SizedBox()
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
}
