import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationModel extends ChangeNotifier {
  int _currentIndex = 0;

  // setのときにnotifyListeners()を呼ぶことアイコンタップと同時に画面を更新しています。
  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // View側に変更を通知
  }
}
