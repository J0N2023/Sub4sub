import 'dart:io';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub4sub_2023/config/load_data.dart';
import 'package:sub4sub_2023/config/void.dart';
import 'package:sub4sub_2023/config/widget.dart';
import 'package:sub4sub_2023/config/warna.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:sub4sub_2023/model/setting_model.dart';
import 'package:sub4sub_2023/model/user_model.dart';
import 'package:sub4sub_2023/providers/current_campaign_provider.dart';
import 'package:sub4sub_2023/providers/statistic_provider.dart';
import 'package:sub4sub_2023/providers/user_provider.dart';

class HalamanUtamaPage extends StatefulWidget {
  const HalamanUtamaPage({Key? key}) : super(key: key);

  @override
  State<HalamanUtamaPage> createState() => _HalamanUtamaPageState();
}

class _HalamanUtamaPageState extends State<HalamanUtamaPage> with WidgetsBindingObserver {
  final ZoomDrawerController z = ZoomDrawerController();

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  UserModel _userModel = UserModel(
    id: 0,
    nama: "",
    email: "",
    coin: 0,
    idDevice: "",
    os: "",
    avatar: "",
    createdAt: "",
    updatedAt: "",
  );

  _getDataUser() async {
    _userModel = await getUser();
    setState(() {});
  }

  _initProvider(){
    Future.delayed(const Duration(milliseconds: 3000), () {
      context.read<CurrentCampaignProvider>().getData();
      context.read<StatisticProvider>().getData();
    });
  }

  _cekVersi(){
    Future.delayed(const Duration(milliseconds: 1000), () async {
      SettingModel model = await getSetting();
      int currentVersi = appVersi();
      int globalVersi = (Platform.isAndroid) ? model.androidVersi : model.iosVersi;
      if(globalVersi > currentVersi){
        String url = (Platform.isAndroid) ? model.playstore : model.appstore;
        bukaWeb(url);
      }
    });
  }

  _alertLogout() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Warning !",
      desc: "Are you sure to logout ?",
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
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            bool isGoogle = prefs.getBool('with_google')!;
            prefs.clear();
            if(isGoogle) {
              await googleSignIn.disconnect();
              context.goNamed('cek_login');
            }else {
              context.goNamed('cek_login');
            }
          },
        )
      ],
    ).show();
  }

  _alertDelete() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Warning !",
      desc: "Are you sure to delete your account ?",
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
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            bool isGoogle = prefs.getBool('with_google')!;
            prefs.clear();
            if(isGoogle) {
              googleSignIn.disconnect();
            }
            context.goNamed('cek_login');
          },
        )
      ],
    ).show();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      _cekVersi();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _getDataUser();
    loadSetting();
    _cekVersi();
    context.read<CurrentCampaignProvider>().getData();
    context.read<StatisticProvider>().getData();
    context.read<UserProvider>().getData();
    loadMyCampaign();
    loadFaq();
    loadHalaman();
    loadSubscribe();
    super.initState();
    _initProvider();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: z,
      borderRadius: 24,
      style: DrawerStyle.defaultStyle,
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 500),
      mainScreenTapClose: true,
      menuBackgroundColor: Colors.teal,
      mainScreen: _mainScreen(),
      menuScreen: _menuScreen()
    );
  }

  Widget _mainScreen(){
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: merah,
        title: const Text('Sub4sub Pro 2023'),
        leading: InkWell(
            onTap: () {
              z.toggle!();
            },
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
      ),
      body: ListView(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.asset(
                      'assets/img/banner/bg.jpeg',
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                          width: 10,
                          color: Colors.red.shade800.withOpacity(0.8))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: _userModel.avatar,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset('assets/img/icon/shortcut.png', fit: BoxFit.cover),
                        ),
                        errorWidget: (context, url, error) => Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset('assets/img/icon/shortcut.png', fit: BoxFit.cover),
                        ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Center(
            child: Column(
              children: [
                Text(
                  _userModel.nama,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: textHitam),
                ),
                Text(
                  _userModel.email,
                  style: TextStyle(color: textHitam, height: 0.7),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<UserProvider>(
                  builder: (context, data, _) {
                    return Consumer<StatisticProvider>(
                      builder: (context, stat, _) {
                        return Row(
                          children: [
                            _itemStatistik('Coins', kFormat(data.model.coin)),
                            const VerticalDivider(
                              thickness: 2,
                            ),
                            _itemStatistik('Current Campaign', stat.model.current.toString()),
                            const VerticalDivider(
                              thickness: 2,
                            ),
                            _itemStatistik('Finish Campaign', stat.model.finish.toString()),
                          ],
                        );
                      }
                    );
                  }
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedButton(
                  color: Colors.teal,
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Text('Promote your channel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    context.goNamed('campaign');
                  },
                ),
                AnimatedButton(
                  color: merah,
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Text('Like and Subcribe to get Coins',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    context.goNamed('loading_campaign', params: {
                      'email': _userModel.email
                    });
                    // context.goNamed('no_campaign');
                  },
                ),

              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<CurrentCampaignProvider>(
            builder: (context, data, _) {
              return (data.list.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('Current Campaign', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textHitam
                          ),),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          itemCount: data.list.length,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return itemCampaign(context, data.list[index], false);
                          },
                        ),
                      ],
                    )
                  : const SizedBox();
            }
          )
        ],
      ),
    );
  }

  Widget _menuScreen(){
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
          backgroundColor: Colors.teal,
          body: Stack(
            children: [
              Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _itemMenu(Icons.add_chart, 'Campaign'),
                        // _itemMenu(Icons.monetization_on_outlined, 'Buy Coins'),
                        _itemMenu(Icons.question_answer_outlined, 'FAQ'),
                        _itemMenu(Icons.error_outline, 'Terms and Conditions'),
                        _itemMenu(Icons.warning_amber, 'Privacy Policy'),
                        _itemMenu(Icons.email_outlined, 'Feedback'),
                        _itemMenu(Icons.star_rate_outlined, 'Rate App'),
                        const SizedBox(height: 20,),
                        _itemMenu(Icons.logout, 'Logout'),
                      ],
                    ),
                  )
              ),
              Positioned(
                  bottom: 50,
                  left: 20,
                  child: _itemMenu(Icons.delete_outline, 'Delete Account'))
            ],
          )
      ),
    );
  }

  Widget _itemMenu(IconData icon, String title){
    return InkWell(
      onTap: () async {
        if(title == 'Logout') _alertLogout();
        if(title == 'Delete Account') _alertDelete();
        if(title == 'Campaign'){
          context.goNamed('campaign');
          z.toggle!();
        }
        if(title == 'FAQ'){
          context.goNamed('faq');
          z.toggle!();
        }
        if(title == 'Terms and Conditions'){
          context.goNamed('halaman', params: {
            'nama': title
          });
          z.toggle!();
        }
        if(title == 'Privacy Policy'){
          context.goNamed('halaman', params: {
            'nama': title
          });
          z.toggle!();
        }
        if(title == 'Feedback'){
          context.goNamed('feedback');
          z.toggle!();
        }
        if(title == 'Rate App'){

          SettingModel settingModel = await getSetting();
          z.toggle!();

          if(Platform.isAndroid) return bukaWeb(settingModel.playstore);
          if(Platform.isIOS) return bukaWeb(settingModel.appstore);

        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white,),
            const SizedBox(width: 15,),
            Text(title, style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),)
          ],
        ),
      ),
    );
  }

  Widget _itemStatistik(String title, String value) {
    return Flexible(
        flex: 1,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: textHitam),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: textHitam, fontSize: 10, height: 0.9),
              ),
              (title == 'Coins')
                  ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: AnimatedButton(
                  color: Colors.green.shade700,
                  height: 30,
                  width: 80,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Text('Buy Coin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                      context.goNamed('beli_koin');
                  },
                ),
              )
                  : const SizedBox()

            ],
          ),
        ));
  }

}

class MyDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    update();
  }
}
