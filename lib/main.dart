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
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);
  final map = GoogleFonts.asMap();
  final images = <imgur.Image>[];

  @override
  void initState() {
    super.initState();
    printGalleryResponse();
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
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index], index);
        });
  }

  Widget _buildRow(WordPair pair, int index) {
    final alreadySaved = _saved.contains(pair);
    final entries = map.entries;
    final font = entries.elementAt(index);

    return Image.network('https://picsum.photos/250?image=9');
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

printGalleryResponse() async {
  final client = imgur.Imgur(imgur.Authentication.fromClientId('21b7bbcaa973981'));

  /// Get your uploaded images
  final resp = await client.gallery.list();

  print(resp);
}
