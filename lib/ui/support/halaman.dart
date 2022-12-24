import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:sub4sub_2023/config/widget.dart';
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
      body: SafeArea(
        child: Consumer<HalamanProvider>(
          builder: (context, data, _) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: HtmlWidget(data.model.isi,
                    onErrorBuilder: (context, element, error) => Text('$element error: $error'),
                    onLoadingBuilder: (context, element, loadingProgress) => const CircularProgressIndicator(),
                    renderMode: RenderMode.column,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
