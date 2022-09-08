import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:meu_app/components/keyboard.dart';
import 'package:meu_app/models/memory.dart';
import "../components/display.dart";
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

final BannerAd myBanner = BannerAd(
  adUnitId: Platform.isAndroid ?  'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716',
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(),
);

class AnuncioWidget extends StatelessWidget{
  const AnuncioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
        children:[
          SizedBox(
            height: screenHeight * 0.1,
            width: screenWidth,
            child: AdWidget(ad: myBanner,),
          )
        ]
    );
  }

}

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final Memory memory = Memory();
  _onPressed(String text) {
    setState(() {
      memory.applyCommand(text);
    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    myBanner.load();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Column(
      children: <Widget>[
        AnuncioWidget(),
        Display(memory.value),
        Keyboard(_onPressed),
      ],
    ));
  }
}
