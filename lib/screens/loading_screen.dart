import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_gallery/screens/album_screen.dart';
import 'package:cool_gallery/services/photo_loader.dart';
import 'package:cool_gallery/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  static final String id = "loading_screen";
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _haveDataLoaded = false;
  List<CachedNetworkImageProvider> thumbnails = [];
  List<CachedNetworkImageProvider> images = [];
  var photoData;

  Future<bool> _getBoolFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final haveLoaded = prefs.getBool('haveLoaded');
    if (haveLoaded == null) {
      return false;
    }
    return haveLoaded;
  }

  Future<void> _resetValue() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('haveLoaded', false);
  }

  Future<void> _dataHaveLoaded() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('haveLoaded', true);
  }

  @override
  void initState() {
    _getAll();
    super.initState();
  }

  Future<void> _getAlbums() async {
    if (_haveDataLoaded == false) {
      PhotoLoader photoLoader = PhotoLoader();
      var fetchedData = await photoLoader.getAlbumData();
      try {
        await DBProvider.instance.insert(DBProvider.albumTableName,
            {DBProvider.colName: jsonEncode(fetchedData)});
      } catch (e) {
        print("Database Error");
      }
    }
  }

  Future _getPhotos() async {
    if (_haveDataLoaded == false) {
      PhotoLoader photoLoader = PhotoLoader();
      var fetchedData = await photoLoader.getPhotoData();
      try {
        await DBProvider.instance.insert(DBProvider.photoTableName,
            {DBProvider.colName: jsonEncode(fetchedData)});
      } catch (e) {
        print("Database Error");
      }
      photoData = fetchedData;
      for (var data in fetchedData) {
        thumbnails.add(CachedNetworkImageProvider(data["thumbnailUrl"]));
        images.add(CachedNetworkImageProvider(data["url"]));
      }
      for (var thumbnail in thumbnails) {
        precacheImage(thumbnail, context);
      }
      for (var image in images) {
        precacheImage(image, context);
      }
    }
  }

  Future<void> _getAll() async {
    try {
      _haveDataLoaded = await _getBoolFromSharedPrefs();
    } catch (e) {
      print("Shared Prefs Error");
    } finally {
      await _getAlbums();
      try {
        await _getPhotos();
      } catch (e) {
        print(e);
      } finally {
        if (_haveDataLoaded == false) {
          await Future.delayed(Duration(minutes: 5), () async {
            await _dataHaveLoaded();
            Navigator.pushNamedAndRemoveUntil(
                context, AlbumScreen.id, (route) => false);
          });
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, AlbumScreen.id, (route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading"),
      ),
    );
  }
}
