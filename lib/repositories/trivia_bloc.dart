import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../models/trivia.dart';
import '../repositories/db_provider.dart';

class TriviaBloc {
  final _triviaController = BehaviorSubject<List<Trivia>>();

  Stream<List<Trivia>> get triviaStream => _triviaController.stream;

  TriviaBloc() {
    getTrivias();
  }

  getTrivias() async {
    Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
        .collection('trivia')
        .orderBy("id")
        .snapshots();
    snapshots.listen((QuerySnapshot snapshot) async {
      _triviaController.sink.add(await DBProvider.db.getAllTrivias());
    });
  }

  getSearch(text) async {
    _triviaController.sink.add(await DBProvider.db.search(text));
  }

  void create(Trivia trivia) {
    DBProvider.db.createFavorite(trivia);
  }

  update(Trivia trivia) {
    DBProvider.db.updateTrivia(trivia);
  }

  delete(int id) {
    DBProvider.db.deleteFavorite(id);
  }
}
