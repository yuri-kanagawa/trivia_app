import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/navigation.dart';
import '../repositories/db_provider.dart';
import '../repositories/favorite_bloc.dart';
import '../repositories/trivia_bloc.dart';
import 'trivia_list/trivia_list_view.dart';

class Triviaapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );

    //FirebaseMessaging.instance.getToken().then((String token) {
    //  print("token: $token");
    //});

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.cyan[700],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.cyan[700],
      ),
      home: MultiProvider(
        providers: [
          Provider<TriviaBloc>(
            create: (_) => TriviaBloc(),
          ),
          Provider<FavoriteBloc>(
            create: (_) => FavoriteBloc(),
          ),
          Provider<BottomNavigationModel>(
              create: (_) => BottomNavigationModel()),
          Provider<DBProvider>(
            create: (_) => DBProvider(),
          ),
        ],
        child: TriviaListView(),
      ),
    );
  }
}
