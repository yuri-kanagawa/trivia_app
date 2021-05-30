import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/trivia_list/trivia_favorite.dart';
import '../../mobad/mobad.dart';
import '../../repositories/favorite_bloc.dart';
import '../../models/navigation.dart';
import '../../repositories/trivia_bloc.dart';
import 'trivia_list.dart';


class TriviaListView extends StatelessWidget {

  // 表示するページをリスト形式で宣言します
  List<Widget> _pageList = <Widget>[
    TriviaList(),
    TriviaFavorite(),
  ];


  Widget build(BuildContext context) {

    final favoriteBloc = Provider.of<FavoriteBloc>(context, listen: false);

    return Container(

      child: ChangeNotifierProvider<BottomNavigationModel>(
        create: (_) => BottomNavigationModel(),
        child:
        Consumer<BottomNavigationModel>(builder: (context, model, child) {
          return Scaffold(
            // 今選択している番号のページを呼び出します。
            body: _pageList[model.currentIndex],

            bottomNavigationBar: BottomNavigationBar(

              //選択画面
              currentIndex: model.currentIndex,

              onTap: (index) {
                //myInterstitial.load();
                // indexで今タップしたアイコンの番号にアクセスできます。
                model.currentIndex = index; // indexをモデルに渡したときに notifyListeners(); を呼んでいます。

                if(index == 0) {

                  Adcount.counter();

                }else if(index == 1){

                  favoriteBloc.getTrivias();

                }

              },
              backgroundColor: Colors.black38,
              items: [

                // フッターアイコンの要素を並べています 最低2個以上必要みたいです。
                BottomNavigationBarItem(
                  // アイコンとラベルは自由にカスタムしてください。
                  icon: Icon(Icons.list_alt),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: '',
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}