import 'package:flutter/material.dart';
import 'package:simple_music_player_flutter/screens/playlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      home: Playlist(),
    );
  }
}
