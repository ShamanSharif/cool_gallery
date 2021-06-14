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
        author: data["userId"].toString(),
      );
      albums.add(album);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Shaman Sharif",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: albums.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.black.withAlpha(10),
              ),
              child: SizedBox(
                height: 150,
                child: InkWell(
                  splashColor: Colors.black.withAlpha(80),
                  onTap: () {
                    Navigator.pushNamed(context, PhotoScreen.id, arguments: {
                      "albumId": albums[index].id,
                      "albumName": albums[index].title,
                      "authorName": albums[index].author,
                      "totalPhoto": albums.length,
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          albums[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "User: " + albums[index].author,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Album extends StatelessWidget {
  final String title;
  final String author;
  final IconData iconData;
  final int id;

  const Album(
      {Key key,
      @required this.title,
      @required this.author,
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
      subtitle: Text(author),
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
