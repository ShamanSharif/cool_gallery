import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_gallery/screens/photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewScreen extends StatefulWidget {
  final List<PhotoIndexed> images;
  final int currentIndex;
  static final String id = "photo_view";

  const PhotoViewScreen({
    Key key,
    this.images,
    this.currentIndex,
  }) : super(key: key);
  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        unselectedFontSize: 0,
        backgroundColor: Colors.transparent,
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.share),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.arrow_back_ios),
          ),
        ],
        onTap: (currentIndex) {
          if (currentIndex == 1) {
            Navigator.pop(context);
          }
        },
      ),
      body: Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider:
                  CachedNetworkImageProvider(widget.images[index].photo.image),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.contained * 1.8,
            );
          },
          itemCount: widget.images.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
            ),
          ),
          enableRotation: true,
          pageController: _pageController,
        ),
      ),
    );
  }
}
