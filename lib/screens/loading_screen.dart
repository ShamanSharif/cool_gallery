import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_gallery/screens/album_screen.dart';
import 'package:cool_gallery/services/photo_loader.dart';
import 'package:cool_gallery/utils/database_helper.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  static final String id = "loading_screen";
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _getAlbums();
    _getPhotos();
  }

  void _getAlbums() async {
    PhotoLoader photoLoader = PhotoLoader();
    var fetchedData = await photoLoader.getAlbumData();
    int i = await DBProvider.instance.insert(DBProvider.albumTableName,
        {DBProvider.colName: jsonEncode(fetchedData)});
    print("Album $i");
  }

  void _getPhotos() async {
    PhotoLoader photoLoader = PhotoLoader();
    var fetchedData = await photoLoader.getPhotoData();
    int i = await DBProvider.instance.insert(DBProvider.photoTableName,
        {DBProvider.colName: jsonEncode(fetchedData)});
    print("Photo $i");
    for (var data in fetchedData) {
      print(data["url"]);
      CachedNetworkImage(
        imageUrl: data["url"],
      );
      CachedNetworkImage(
        imageUrl: data["thumbnailUrl"],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, AlbumScreen.id, (route) => false);
          },
          child: Container(
            width: 20,
            height: 20,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
