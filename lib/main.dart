// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imgur/imgur.dart' as imgur;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: Gallery(),
    );
  }
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);
  final map = GoogleFonts.asMap();
  Future<List<imgur.GalleryAlbumImage>> futureGallery;
  List<imgur.GalleryAlbumImage> gallery;

  @override
  void initState() {
    super.initState();
    futureGallery = getFutureGallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return FutureBuilder<List<imgur.GalleryAlbumImage>>(
        future: futureGallery,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            gallery = snapshot.data;
            return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemBuilder: /*1*/ (context, i) {
                  if (i.isOdd) return Divider();
                  /*2*/
                  final index = i ~/ 2; /*3*/
                  return _buildRow(index);
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildRow(int index) {
    final entries = map.entries;

    final album = gallery.elementAt(index);
    final firstImage = album.images?.elementAt(0)?.link;
    if (firstImage == null) {
      return Image.network('https://picsum.photos/250?image=9');

    } else {
      return Image.network(firstImage);
      //   ListTile(
      //   title: Text(
      //     pair.asPascalCase,
      //     style: font.value.call(),
      //   ),
      //   trailing: Icon(
      //     // NEW from here...
      //     alreadySaved ? Icons.favorite : Icons.favorite_border,
      //     color: alreadySaved ? Colors.red : null,
      //   ),
      //   onTap: () {
      //     setState(() {
      //       if (alreadySaved) {
      //         _saved.remove(pair);
      //       } else {
      //         _saved.add(pair);
      //       }
      //     });
      //   },
      // );
    }
  }

  Future<List<imgur.GalleryAlbumImage>> getFutureGallery() {
    final client =
        imgur.Imgur(imgur.Authentication.fromClientId('21b7bbcaa973981'));

    /// Get your uploaded images
    return client.gallery.list();
  }
}
