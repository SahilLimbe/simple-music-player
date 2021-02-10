import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flute_music_player/flute_music_player.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ionicons/ionicons.dart';

enum PlayerState { stopped, playing, paused }

class Playlist extends StatefulWidget {
  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  String bgImage = 'assets/images/purple_bg.jpg';

  MusicFinder audioPlayer = new MusicFinder();
  var songs;
  var playThis;
  PlayerState playerState;
  Future<String> loadSongs;
  var currentlyPlaying;

  @override
  void initState() {
    super.initState();
    loadSongs = musicPlayerInit();
    // musicPlayerInit();
  }

  Future<String> musicPlayerInit() async {
    songs = await MusicFinder.allSongs();
    playThis = songs == null ? '0' : songs[0].uri;
    playerState = PlayerState.stopped;
    debugPrint(songs.length.toString());
    return 'Songs search completed';
  }

  play() async {
    setState(() {
      currentlyPlaying = playThis;
    });
    final result = await audioPlayer.play(playThis.uri);
    if (result == 1) setState(() => playerState = PlayerState.playing);
  }

  pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  stop() async {
    final result = await audioPlayer.stop();
    if (result == 1) setState(() => playerState = PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;
    var fullHeight = MediaQuery.of(context).size.height;
    var artFile;
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: fullHeight * 0.90,
        collapsed: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: fullWidth * 0.06),
              child: Row(
                children: [
                  Container(
                    width: fullWidth * 0.70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              currentlyPlaying == null
                                  ? '____'
                                  : currentlyPlaying.title,
                              style: TextStyle(
                                color: Color(0xFFDEDEDE),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            currentlyPlaying == null
                                ? '____'
                                : currentlyPlaying.artist,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RawMaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      setState(
                        () {
                          if (playerState == PlayerState.playing) {
                            pause();
                          } else if (playerState == PlayerState.stopped) {
                            playThis = songs[0];
                            play();
                          } else {
                            play();
                          }
                        },
                      );
                    },
                    child: Icon(
                      playerState == PlayerState.playing
                          ? Ionicons.pause_circle_outline
                          : Ionicons.play_circle_outline,
                      color: Color(0xFFDEDEDE),
                      size: 70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // header: Icon(
        //   Ionicons.chevron_down_outline,
        //   color: Colors.white,
        // ),
        panel: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(
                  image: AssetImage(bgImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.50),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: fullWidth * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: fullWidth * 0.14,
                    child: currentlyPlaying != null
                        ? ClipOval(
                            child: Image.file(
                              File.fromUri(
                                Uri.parse(currentlyPlaying.albumArt),
                              ),
                              fit: BoxFit.fill,
                            ),
                          )
                        : CircleAvatar(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Text(
                    currentlyPlaying?.title ?? '___',
                    style: TextStyle(
                      color: Color(0xFFDEDEDE),
                      fontSize: 24,
                    ),
                  ),
                  Container(
                    height: 10,
                    width: double.infinity,
                  ),
                  Text(
                    'DEMO',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: FutureBuilder(
                future: loadSongs,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else
                      return ListView.builder(
                        itemCount: songs?.length ?? 0,
                        itemBuilder: (context, i) {
                          if (songs[i].albumArt != null) {
                            artFile =
                                new File.fromUri(Uri.parse(songs[i].albumArt));
                          } else
                            artFile = null;

                          var song = songs[i];
                          return RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                debugPrint(
                                  "playerState: " + playerState.toString(),
                                );
                                // if (playerState == PlayerState.playing) {
                                stop();
                                debugPrint('Song Stopped');
                                // }
                                playThis = song;
                                debugPrint(playThis.title);
                                play();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                dense: false,
                                leading: Container(
                                  width: fullWidth * 0.14,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: artFile != null
                                        ? AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: Image.file(
                                              artFile,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : CircleAvatar(
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                title: Text(
                                  song.title,
                                  style: TextStyle(
                                    color: Color(0xFFDEDEDE),
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  song.artist,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF8A8A8A),
                                  ),
                                ),
                                trailing: Icon(
                                  currentlyPlaying == song &&
                                          playerState == PlayerState.playing
                                      ? Ionicons.pause_circle_outline
                                      : Ionicons.play_circle_outline,
                                  color: Color(0xFFDEDEDE),
                                  size: 40,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            )
            // ListView.builder(
            //   itemCount: length,
            //   itemBuilder: (context, i) {
            //     artFile = new File.fromUri(Uri.parse(songs[i].albumArt));
            //     var song = songs[i];
            //     print(length);
            //     return RawMaterialButton(
            //       onPressed: () {
            //         setState(() {
            //           if (playerState == PlayerState.playing) {
            //             stop();
            //           }
            //           playThis = song.uri;
            //           play();
            //         });
            //       },
            //       child: Padding(
            //         padding: EdgeInsets.symmetric(vertical: 6),
            //         child: ListTile(
            //           dense: false,
            //           leading: ClipRRect(
            //             borderRadius: BorderRadius.circular(12),
            //             child: Image.file(
            //               artFile,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //           title: Text(
            //             song.title,
            //             style: TextStyle(
            //               color: Color(0xFFDEDEDE),
            //               fontSize: 16,
            //             ),
            //           ),
            //           subtitle: Text(
            //             song.artist,
            //             style: TextStyle(
            //               fontSize: 14,
            //               color: Color(0xFF8A8A8A),
            //             ),
            //           ),
            //           trailing: IconButton(
            //             onPressed: () {
            //               //TODO implement this for pausing current song
            //             },
            //             icon: Icon(
            //               Ionicons.play_circle_outline,
            //               color: Color(0xFFDEDEDE),
            //               size: 35,
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
