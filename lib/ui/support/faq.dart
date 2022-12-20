import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sub4sub_2023/config/load_data.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/model/faq_model.dart';
import 'package:sub4sub_2023/providers/faq_provider.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {


  _initProvider(){
    loadFaq();
    context.read<FaqProvider>().getData();
    Future.delayed(const Duration(milliseconds: 3000), () {
      context.read<FaqProvider>().getData();
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
      appBar: appBar('FAQ'),
      body: Consumer<FaqProvider>(
        builder: (context, data, _) {
          return ListView.builder(
            itemCount: data.list.length,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemBuilder: (BuildContext context, int index) {
              return _itemFaq(data.list[index]);
            },
          );
        }
      )
    );
  }

  Widget _itemFaq(FaqModel model){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              context.goNamed('detail_faq', extra: model);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: textHitam,),
                const SizedBox(width: 10,),
                Expanded(
                  child: Text(model.pertanyaan,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                    color: textHitam,
                    fontSize: 18
                  ),),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(),
          )
        ],
      ),
    );
  }
}
