import 'package:flutter/material.dart';
import 'text_section.dart';
import 'image_banner.dart';


class LocationDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Vets para Pets')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageBanner("assets/images/pets.jpg"),
          TextSection("Login", "Password"),
          
        ],
      )
    );
  }
}
