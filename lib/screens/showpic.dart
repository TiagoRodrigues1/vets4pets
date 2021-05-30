import 'dart:typed_data';
import 'package:photo_view/photo_view.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class PhotoPage extends StatefulWidget {
  final String image;

  PhotoPage({Key key, this.image}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  Widget build(BuildContext context) {
    print(widget.image);
    String profileUrl = widget.image;
    profileUrl = profileUrl.substring(23, profileUrl.length);
    Uint8List bytes = base64.decode(profileUrl);

    return Container(
        child: PhotoView(
      imageProvider: MemoryImage(bytes),
    ));
  }
}
