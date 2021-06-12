import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_gallery/utils/database_helper.dart';
import 'package:flutter/material.dart';

class PhotoScreen extends StatefulWidget {
  static final String id = "photo_screen";
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  var photoData;
  List<Icon> icons = [
    Icon(Icons.album),
    Icon(Icons.account_circle_outlined),
    Icon(Icons.favorite_border),
    Icon(Icons.description),
    Icon(Icons.clean_hands_outlined),
  ];

  List<Photo> photos = [];

  @override
  void initState() {
    _getPhotoData();
    super.initState();
  }

  void _getPhotoData() async {
    List<Map<String, dynamic>> fetchedData =
        await DBProvider.instance.queryAll(DBProvider.photoTableName);
    photoData = jsonDecode(fetchedData[0][DBProvider.colName]);
    await _updatePhotos(photoData);
    setState(() {});
  }

  Future<void> _updatePhotos(dynamic photoData) async {
    for (var data in photoData) {
      Photo photo = Photo(
        albumId: data["albumId"],
        id: data["id"],
        name: data["title"],
        thumbnail: CachedNetworkImage(
          imageUrl: data["thumbnailUrl"],
        ),
        image: CachedNetworkImage(
          imageUrl: data["url"],
        ),
      );
      photos.add(photo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Shaman Sharif"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Text(
                args['albumName'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.all(10.0),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: photos,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  final int albumId;
  final int id;
  final String name;
  final CachedNetworkImage thumbnail;
  final CachedNetworkImage image;

  const Photo({
    Key key,
    @required this.albumId,
    @required this.id,
    @required this.name,
    @required this.thumbnail,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return thumbnail;
  }
}
