import 'package:flutter/material.dart';

import 'res/const.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Простой плеер'),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  MyPlaer(
                    urlRadio: kUrl_mp3,
                  ),
                  MyPlaer(
                    urlRadio: kUrl_aac,
                  ),
                  MyPlaer(
                    urlRadio: kUrl_he_aac,
                  ),
                  MyPlaer(
                    urlRadio: kUrl_vorbis,
                  ),
                  MyPlaer(
                    urlRadio: kUrl_he_aac64,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
