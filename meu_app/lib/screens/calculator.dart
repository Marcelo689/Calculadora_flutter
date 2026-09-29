import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import 'package:flutter/services.dart';
import 'package:meu_app/components/keyboard.dart';
import 'package:meu_app/models/memory.dart';
import "../components/display.dart";
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AnuncioWidget extends StatefulWidget {
  const AnuncioWidget({Key? key}) : super(key: key);

  @override
  State<AnuncioWidget> createState() => _AnuncioWidgetState();
}

class _AnuncioWidgetState extends State<AnuncioWidget> {
  bool _isLoaded = false;
  late final BannerAd _banner;

  @override
  void initState() {
    super.initState();
    _banner = BannerAd(
      adUnitId: defaultTargetPlatform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) => setState(() => _isLoaded = true),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context){
    if (!_isLoaded) {
      return const SizedBox.shrink();
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
        children:[
          SizedBox(
            height: screenHeight * 0.1,
            width: screenWidth,
            child: AdWidget(ad: _banner,),
          )
        ]
    );
  }

}

class Calculator extends StatefulWidget {
  final bool showAd;

  const Calculator({Key? key, this.showAd = true}) : super(key: key);

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Column(
      children: <Widget>[
        if (widget.showAd) const AnuncioWidget(),
        Display(memory.value),
        Keyboard(_onPressed),
      ],
    ));
  }
}
