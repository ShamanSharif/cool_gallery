import 'package:cool_gallery/screens/album_screen.dart';
import 'package:cool_gallery/screens/loading_screen.dart';
import 'package:cool_gallery/screens/photo_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id: (context) => LoadingScreen(),
        AlbumScreen.id: (context) => AlbumScreen(),
        PhotoScreen.id: (context) => PhotoScreen(),
      },
    );
  }
}
