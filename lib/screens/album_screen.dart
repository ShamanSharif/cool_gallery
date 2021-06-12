import 'dart:convert';

import 'package:cool_gallery/screens/photo_screen.dart';
import 'package:cool_gallery/utils/database_helper.dart';
import 'package:flutter/material.dart';

class AlbumScreen extends StatefulWidget {
  static final String id = "album_screen";
  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  var albumData;
  List<Album> albums = [];

  @override
  void initState() {
    _getAlbumData();
    super.initState();
  }

  void _getAlbumData() async {
    List<Map<String, dynamic>> fetchedData =
        await DBProvider.instance.queryAll(DBProvider.albumTableName);
    albumData = jsonDecode(fetchedData[0][DBProvider.colName]);
    await _updateAlbums(albumData);
    setState(() {});
  }

  Future<void> _updateAlbums(dynamic albumData) async {
    for (var data in albumData) {
      Album album = Album(
        id: data["id"],
        title: data["title"],
        subtitle: "User: " + data["userId"].toString(),
      );
      albums.add(album);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shaman Sharif"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: albums.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: albums[index],
            );
          },
        ),
      ),
    );
  }
}

class Album extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final int id;

  const Album(
      {Key key,
      @required this.title,
      @required this.subtitle,
      this.iconData,
      @required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData != null ? iconData : Icons.photo_album_outlined,
        size: 40,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.pushNamed(
          context,
          PhotoScreen.id,
          arguments: {
            "albumName": title,
            "albumId": id,
          },
        );
      },
    );
  }
}
