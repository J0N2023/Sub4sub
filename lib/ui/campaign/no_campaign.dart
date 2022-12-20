import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sub4sub_2023/config/warna.dart';

class NoCampaign extends StatefulWidget {
  const NoCampaign({Key? key}) : super(key: key);

  @override
  State<NoCampaign> createState() => _NoCampaignState();
}

class _NoCampaignState extends State<NoCampaign> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: LottieBuilder.asset('assets/img/lottie/done.zip'),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('At this point you have subscribed to all campaigns, please come back later',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 22,
                color: textHitam,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: AnimatedButton(
                color: merah,
                height: 50,
                width: MediaQuery.of(context).size.width - 30,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text('Back to home',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
