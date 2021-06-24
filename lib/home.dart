import 'package:flutter/material.dart';
import 'package:lizi_site/app_bar.dart';
import 'package:lizi_site/bottom_bar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiziAppBar(),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1176),
          child: ListView(
            children: [
              SizedBox(height: 88),
              _HomeIntroWidget(context: context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: LiziBottomBar(),
    );
  }
}

class _HomeIntroWidget extends StatelessWidget {
  const _HomeIntroWidget({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 12),
        Container(
          width: 400,
          child: _renderTexts(context),
        ),
        Expanded(
          child: Container(
            height: 460,
            child: Stack(
              children: [
                _renderWebFrame(),
                _renderPhoneFrame(),
                _renderPadFrame(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Positioned _renderPadFrame() {
    return Positioned(
      left: 420,
      top: 260,
      width: 317 * 0.85,
      height: 204 * 0.85,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/screen_pad.png'),
          ),
        ),
      ),
    );
  }

  Positioned _renderPhoneFrame() {
    return Positioned(
      left: 420,
      top: 22,
      width: 135 * 0.85,
      height: 261 * 0.85,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/screen_phone.png'),
          ),
        ),
      ),
    );
  }

  Positioned _renderWebFrame() {
    return Positioned(
      left: 54,
      top: 64,
      width: 404 * 0.85,
      height: 308 * 0.85,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/screen_web.png'),
          ),
        ),
      ),
    );
  }

  Column _renderTexts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '极简粒子方案',
          style: TextStyle(
            fontSize: 48,
            color: Color.fromARGB(255, 34, 34, 34),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '可快速落地的粒子动画库',
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 34, 34, 34),
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'LIZI 是一种同时兼容 iOS / Android / Flutter / Web 多个平台的粒子方案，高效，快捷。',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 68, 68, 68),
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 44),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Container(
                width: 120,
                height: 48,
                color: Theme.of(context).primaryColor,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/editor');
                  },
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Text(
                      '开始使用',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 28),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 120,
                height: 48,
                color: Color(0xfff0f0f0),
                child: Center(
                  child: Text(
                    'GitHub',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff7f8c8d),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
