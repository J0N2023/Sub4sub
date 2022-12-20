import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/model/faq_model.dart';
import 'package:sub4sub_2023/providers/halaman_provider.dart';

class HalamanPage extends StatefulWidget {
  final String nama;
  const HalamanPage({Key? key, required this.nama}) : super(key: key);

  @override
  State<HalamanPage> createState() => _HalamanPageState();
}

class _HalamanPageState extends State<HalamanPage> {

  @override
  void initState() {
    context.read<HalamanProvider>().getData(widget.nama);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.nama),
      body: Consumer<HalamanProvider>(
        builder: (context, data, _) {
          return ListView(
            padding: const EdgeInsets.all(15),
            children: [
              Text(data.model.nama, style: TextStyle(
                color: textHitam,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),),
              const SizedBox(height: 20,),
              HtmlWidget(data.model.isi,
                onErrorBuilder: (context, element, error) => Text('$element error: $error'),
                onLoadingBuilder: (context, element, loadingProgress) => const CircularProgressIndicator(),
                renderMode: RenderMode.column,
                textStyle: const TextStyle(fontSize: 14),
              ),
            ],
          );
        }
      ),
    );
  }
}
