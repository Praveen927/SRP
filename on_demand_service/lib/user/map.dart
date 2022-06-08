import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapmyindia_flutter/mapmyindia_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  String mapImageUrl =
      MapMyIndiaStillMap("740b8c89120335ba057d4f670ac19279").getMapImage(
    12,
    80,
  );
  @override
  Widget build(BuildContext context) {
    print(mapImageUrl);
    return new Scaffold(
        body: Center(
      child: Container(
        color: Colors.amber,
        child: Text(mapImageUrl),
      ),
    ));
  }
}
