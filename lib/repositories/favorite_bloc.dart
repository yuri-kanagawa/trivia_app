import 'dart:async';
import 'dart:core';
import 'package:rxdart/rxdart.dart';

import '../models/favorite.dart';
import '../repositories/db_provider.dart';

class FavoriteBloc{

  final _favoriteController = BehaviorSubject<List<Favorite>>();

  Stream<List<Favorite>> get favoriteStream => _favoriteController.stream;

  Future getTrivias() async {
    _favoriteController.sink.add(await DBProvider.db.getAllFavoriteTrivias());
  }

  FavoriteBloc() {
    getTrivias();
  }

  void create(Favorite favorite) {
    DBProvider.db.createFavorite2(favorite);
  }

  delete(int id) {
    DBProvider.db.deleteFavorite(id);
    getTrivias();
  }
}