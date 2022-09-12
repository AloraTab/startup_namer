// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
  
}

//A stateless widget -> Immutable
class MyApp extends StatelessWidget {
  //Makes the app itself a widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Kind of like main method
    return MaterialApp(
      //Creates a material app
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

//Requires StaefulWdiget class and instance of State class
class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() =>
      _RandomWordsState(); //The underscore for privacy
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{}; //A set to store names the user favorited
  final _biggerFont = const TextStyle(fontSize: 18);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty //Var of final rows 
              ? ListTile.divideTiles( //Adds the horizontal spacing
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        //ListView provides itemBuilder - factory builder and callback function
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd){
            return const Divider();} //Adds a visual divider for odd rows

          final index =
              i ~/ 2; //Calculates the number of names seen, excluding dividers

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); //Generates more pairings
          }

          final alreadySaved = _saved.contains(
              _suggestions[index]); //Boolean to check if it already saved

          return ListTile(
              //Fixed height row that contains text and widgets
              title: Text(
                _suggestions[index].asPascalCase,
                style: _biggerFont,
              ),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Removed from saved' : 'Save',
              ),
              onTap: () {
                setState(() {
                  //Calls the build method
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                });
              });
        },
      ),
    );
  }
}

