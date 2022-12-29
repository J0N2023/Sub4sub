import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sub4sub_2023/cek_login.dart';
import 'package:sub4sub_2023/model/campaign_model.dart';
import 'package:sub4sub_2023/model/faq_model.dart';
import 'package:sub4sub_2023/providers/chat_provider.dart';
import 'package:sub4sub_2023/providers/current_campaign_provider.dart';
import 'package:sub4sub_2023/providers/faq_provider.dart';
import 'package:sub4sub_2023/providers/halaman_provider.dart';
import 'package:sub4sub_2023/providers/my_campaign_provider.dart';
import 'package:sub4sub_2023/providers/setting_provider.dart';
import 'package:sub4sub_2023/providers/statistic_provider.dart';
import 'package:sub4sub_2023/providers/subscribe_provider.dart';
import 'package:sub4sub_2023/providers/user_provider.dart';
import 'package:sub4sub_2023/ui/auth/signup.dart';
import 'package:sub4sub_2023/ui/campaign/create_campaign.dart';
import 'package:sub4sub_2023/ui/campaign/data_campaign.dart';
import 'package:sub4sub_2023/ui/campaign/detail_campaign.dart';
import 'package:sub4sub_2023/ui/campaign/index_campaign.dart';
import 'package:sub4sub_2023/ui/campaign/loading_campaign.dart';
import 'package:sub4sub_2023/ui/campaign/no_campaign.dart';
import 'package:sub4sub_2023/ui/halaman_utama.dart';
import 'package:sub4sub_2023/ui/auth/login.dart';
import 'package:sub4sub_2023/ui/support/detail_faq.dart';
import 'package:sub4sub_2023/ui/support/faq.dart';
import 'package:sub4sub_2023/ui/support/feedback.dart';
import 'package:sub4sub_2023/ui/support/halaman.dart';
import 'package:sub4sub_2023/ui/youtube/youtube_page.dart';
import 'config/firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          name: 'cek_login',
          builder: (context, state) {
            return const CekLoginPage();
          },
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) {
            return const SignupPage();
          },
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/main',
          name: 'main',
          builder: (context, state) {
            return const HalamanUtamaPage();
          },
          routes: <GoRoute>[
            GoRoute(
              path: 'campaign',
              name: 'campaign',
              builder: (context, state) {
                return const IndexCampaign();
              },
              routes: <GoRoute>[
                GoRoute(
                  path: 'create_campaign',
                  name: 'create_campaign',
                  builder: (context, state) {
                    return const CreateCampaign();
                  },
                ),
                GoRoute(
                    path: 'data_campaign',
                    name: 'data_campaign',
                    builder: (context, state) {
                      CampaignModel model = state.extra as CampaignModel;
                      return DataCampaign(model: model);
                    },
                ),
              ]
            ),
            GoRoute(
              path: 'detail_campaign',
              name: 'detail_campaign',
              builder: (context, state) {
                CampaignModel model = state.extra as CampaignModel;
                return DetailCampaign(model: model);
              },
              routes: <GoRoute>[
                GoRoute(
                  path: 'youtube_page/:url',
                  name: 'youtube_page',
                  builder: (context, state) {
                    String url = state.params['url']!;
                    return YoutubePage(urlYoutube: url);
                  },
                ),
              ]
            ),
            GoRoute(
              path: 'no_campaign',
              name: 'no_campaign',
              builder: (context, state) {
                return const NoCampaign();
              },
            ),
            GoRoute(
              path: 'loading_campaign/:email',
              name: 'loading_campaign',
              builder: (context, state) {
                String email = state.params['email']!;
                return LoadingCampaign(email: email);
              },
            ),
            GoRoute(
              path: 'faq',
              name: 'faq',
              builder: (context, state) {
                return const FaqPage();
              },
              routes: [
                GoRoute(
                  path: 'detail_faq',
                  name: 'detail_faq',
                  builder: (context, state) {
                    FaqModel model = state.extra as FaqModel;
                    return DetailFaq(model: model);
                  },
                ),
              ]
            ),
            GoRoute(
              path: 'halaman/:nama',
              name: 'halaman',
              builder: (context, state) {
                String email = state.params['nama']!;
                return HalamanPage(nama: email);
              },
            ),
            GoRoute(
              path: 'feedback',
              name: 'feedback',
              builder: (context, state) {
                return const FeedbackPage();
              },
            ),
          ]
        ),
      ],
      initialLocation: '/',
      debugLogDiagnostics: true,
      routerNeglect: false
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>  UserProvider()),
        ChangeNotifierProvider(create: (_) =>  MyCampaignProvider()),
        ChangeNotifierProvider(create: (_) =>  CurrentCampaignProvider()),
        ChangeNotifierProvider(create: (_) =>  StatisticProvider()),
        ChangeNotifierProvider(create: (_) =>  FaqProvider()),
        ChangeNotifierProvider(create: (_) =>  HalamanProvider()),
        ChangeNotifierProvider(create: (_) =>  ChatProvider()),
        ChangeNotifierProvider(create: (_) =>  SubscribeProvider()),
        ChangeNotifierProvider(create: (_) =>  SettingProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'Overpass'
        ),
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }

}
