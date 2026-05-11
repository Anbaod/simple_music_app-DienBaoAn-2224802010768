
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/audio_provider.dart';

import 'services/audio_player_service.dart';
import 'services/storage_service.dart';

import 'screens/home_screen.dart';

void main() {

  runApp(

    ChangeNotifierProvider(

      create: (_) => AudioProvider(
        AudioPlayerService(),
        StorageService(),
      ),

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: ThemeData.dark(),

      home: HomeScreen(),
    );
  }
}