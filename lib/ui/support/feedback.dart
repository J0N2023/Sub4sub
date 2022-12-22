import 'package:animated_button/animated_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:provider/provider.dart';
import 'package:sub4sub_2023/config/load_data.dart';
import 'package:sub4sub_2023/config/url.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/model/chat_model.dart';
import 'package:sub4sub_2023/providers/chat_provider.dart';

import '../../config/void.dart';
import '../../config/warna.dart';
import '../../model/user_model.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  final TextEditingController _pesan = TextEditingController();

  final ScrollController _controller = ScrollController();

  _initProvider(){
    context.read<ChatProvider>().getData();
    Future.delayed(const Duration(milliseconds: 3000), () {
      context.read<ChatProvider>().getData();
    });
  }

  void _kirim() async {

    if(_pesan.text.isEmpty) return;
    UserModel userModel = await getUser();
    String email = userModel.email;
    Dio dio = Dio();
    Map formData = {
      'email': email,
      'pesan': _pesan.text
    };
    _pesan.text = '';
    Response response = await dio.post("$apiUrl/kirim_chat",
      data: formData,
    );
    if(response.data) {
      loadChat();
      _reload();
    }
  }

  _reload(){
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<ChatProvider>().getData();
    });
  }


  @override
  void initState() {
    loadChat();
    _initProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: appBar('Feedback'),
      body: Column(
        children: [
          Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, data, _) {
                  return ListView.builder(
                    controller: _controller,
                    itemCount: data.list.length,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (BuildContext context, int index) {
                      return _itemChat(data.list[index]);
                    },
                  );
                }
              )
          ),
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pesan,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: 'Write message',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    AnimatedButton(
                      color: merah,
                      height: 60,
                      width: 60,
                      onPressed: _kirim,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Icon(Icons.send, color: Colors.white,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemChat(ChatModel model){
    return  ChatBubble(
      clipper: ChatBubbleClipper1(type: (model.idUser == 1) ? BubbleType.receiverBubble : BubbleType.sendBubble),
      alignment: (model.idUser == 1) ? Alignment.topLeft : Alignment.topRight,
      margin: const EdgeInsets.only(top: 20),
      backGroundColor: (model.idUser == 1) ? Colors.white : Colors.red.shade50,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.nama,
                style: TextStyle(
                  color: textHitam,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(model.pesan,
                style: TextStyle(color: textHitam),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
