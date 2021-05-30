import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../mobad/mobad.dart';
import '../../components/trivia_detail/favorite_detail_view.dart';
import '../../models/favorite.dart';
import '../../repositories/db_provider.dart';
import '../../repositories/favorite_bloc.dart';

import '../../configs/const_text.dart';

class TriviaFavorite extends StatelessWidget {
  int count = 0;


  @override
  Widget build(BuildContext context) {

    final _bloc = Provider.of<FavoriteBloc>(context, listen: false);

    return Scaffold(

      appBar: AppBar(
          leading: IconButton(
              icon:Icon(EvaIcons.twitter),
              onPressed: (){
                _launchURL(ConstText.twitterURLScheme,ConstText.twitterURL);
              }
          ),
          centerTitle: true,
          title: Text(ConstText.triviaFavoriteView),
          actions: <Widget>[
            IconButton(
                icon:Icon(Icons.share),
                onPressed: (){
                  Share.share("雑学アプリ TRIVIA ■iOS:${ConstText.iOS_URL} ■Android:${ConstText.Android_URL} ■WEB:${ConstText.Web}");
                }
            )
          ]
      ),

      body: SafeArea(
        child:StreamBuilder<List<Favorite>>(

        stream: _bloc.favoriteStream,

        builder: (BuildContext context, AsyncSnapshot<List<Favorite>> snapshot) {

          if (snapshot.hasData) {

            return ListView.builder(

                itemCount: snapshot.data.length,

                itemBuilder: (BuildContext context, int index) {

                  Favorite favorite = snapshot.data[index];

                  return  Card(

                      child: ChangeNotifierProvider<DBProvider>(
                          create: (_) => DBProvider(),

                          child: Consumer<DBProvider>(builder: (context, model, child) {


                            if( count < snapshot.data.length) {
                              model.getFavoriteId2(favorite.id);
                              count ++;
                              //model.dispose();
                            }else{
                              count = 0;
                            }

                            return ListTile(
                                onTap: (){
                                  //広告表示
                                  Adcount.counter();
                                  _moveToDetailView(context, _bloc, favorite , model.flg,
                                    favorite.id, favorite.title,favorite.youtube ,favorite.content1, favorite.content2, favorite.content3,favorite.genre);
                                },

                                title: Text("${favorite.id}   ${favorite.title}"),

                                trailing: IconButton(
                                    icon: Icon(Icons.star),
                                    color: ((model.flg) != true ? Colors.white60 : Colors.yellow),
                                    onPressed: (){
                                      if((model.flg ) != true) {
                                        //_bloc.create(favorite);
                                      }else{
                                        _bloc.delete(favorite.id);
                                      }
                                    }
                                )
                              //isThreeLine: true,
                            );
                          })
                      )
                  );
                }
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ),

    );
  }

  Future _launchURL(String url,String secondUrl) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else if (secondUrl != null && await canLaunch(secondUrl)) {
      await launch(
        secondUrl,
        forceSafariVC: false,
        forceWebView: false,);
    } else {
      // 任意のエラー処理
    }
  }

  _moveToDetailView(BuildContext context, FavoriteBloc bloc , Favorite favorite, bool flg,
      int id, String title,String Youtube ,String c1, String c2, String c3, String genre) async{
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            FavoriteDetailView(
                Bloc: bloc, favorite: favorite, flg:flg ,
                id: id, title:title,youtube:Youtube ,content1:c1, content2:c2, content3:c3, genre:genre))
    );

  }


}