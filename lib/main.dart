import 'package:flutter/material.dart';
import 'package:art/pages/home.dart';
import 'package:art/pages/canvases.dart';
import 'package:art/pages/canvas_card.dart';
import 'package:art/pages/canvas_large.dart';

void main() => runApp(MaterialApp(

    theme: ThemeData(
      primaryColor: Colors.black,
      accentColor: Colors.grey[100],
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/canvasCard': (context) => CanvasCard(),
    }));
