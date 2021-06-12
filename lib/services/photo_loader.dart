import 'package:cool_gallery/services/network.dart';

class PhotoLoader {
  Future<dynamic> getAlbumData() async {
    NetworkHelper networkHelper = NetworkHelper(
        url: Uri.parse("https://jsonplaceholder.typicode.com/albums"));
    var fetchedData = await networkHelper.getData();
    return fetchedData;
  }

  Future<dynamic> getPhotoData() async {
    NetworkHelper networkHelper = NetworkHelper(
        url: Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    var fetchedData = await networkHelper.getData();
    return fetchedData;
  }
}
