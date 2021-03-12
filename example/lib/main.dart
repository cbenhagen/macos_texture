import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:macos_texture/macos_texture.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FutureBuilder<Widget>(
            future: MacosTexture.texture,
            initialData: Text('Initializing'),
            builder: (context, snapshot) => snapshot.data,
          ),
        ),
      ),
    );
  }
}
