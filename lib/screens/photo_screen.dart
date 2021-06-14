import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_gallery/screens/photo_view_screen.dart';
import 'package:cool_gallery/utils/database_helper.dart';
import 'package:flutter/material.dart';

class PhotoScreen extends StatefulWidget {
  static final String id = "photo_screen";
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  var photoData;

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
    await _updatePhotos(context, photoData);
    setState(() {});
  }

  Future<void> _updatePhotos(BuildContext context, dynamic photoData) async {
    for (var data in photoData) {
      Photo photo = Photo(
        context,
        albumId: data["albumId"],
        id: data["id"],
        name: data["title"],
        thumbnail: data["thumbnailUrl"],
        image: data["url"],
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
                children: _getClickableThumbnail(args["albumId"]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getClickableThumbnail(int albumId) {
    List<Widget> allPhotos = [];
    List<PhotoIndexed> albumPhotos = [];
    int index = 0;
    for (var photo in photos) {
      if (photo.albumId == albumId) {
        albumPhotos.add(
          PhotoIndexed(
            index,
            photo,
          ),
        );
        index++;
      }
    }
    for (var albumPhoto in albumPhotos) {
      allPhotos.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PhotoViewScreen(
                        images: albumPhotos, currentIndex: albumPhoto.index)));
          },
          child: albumPhoto.photo.getImage(),
        ),
      );
    }
    return allPhotos;
  }
}

class PhotoIndexed {
  final int index;
  final Photo photo;

  PhotoIndexed(this.index, this.photo);
}

class Photo {
  final int albumId;
  final int id;
  final String name;
  final String thumbnail;
  final String image;
  final BuildContext context;

  const Photo(
    this.context, {
    Key key,
    @required this.albumId,
    @required this.id,
    @required this.name,
    @required this.thumbnail,
    @required this.image,
  });

  Widget getImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(thumbnail),
        ),
      ),
    );
  }
}
