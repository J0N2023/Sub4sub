import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/model/faq_model.dart';

class DetailFaq extends StatefulWidget {
  final FaqModel model;
  const DetailFaq({Key? key, required this.model}) : super(key: key);

  @override
  State<DetailFaq> createState() => _DetailFaqState();
}

class _DetailFaqState extends State<DetailFaq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Detail Faq'),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text(widget.model.pertanyaan, style: TextStyle(
            color: textHitam,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),),
          const SizedBox(height: 20,),
          HtmlWidget(widget.model.jawaban,
            onErrorBuilder: (context, element, error) => Text('$element error: $error'),
            onLoadingBuilder: (context, element, loadingProgress) => const CircularProgressIndicator(),
            renderMode: RenderMode.column,
            textStyle: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
