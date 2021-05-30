
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../repositories/db_provider.dart';
import '../../configs/const_text.dart';
import '../../models/favorite.dart';
import '../../repositories/favorite_bloc.dart';

class FavoriteDetailView extends StatelessWidget {

  final FavoriteBloc Bloc;
  final Favorite favorite;
  final int id;
  final String title;
  final String youtube;
  final String content1;
  final String content2;
  final String content3;
  final String genre;
  final bool flg;

  const FavoriteDetailView({Key key, this.Bloc, this.favorite , this.flg ,
    // ignore: non_constant_identifier_names
    this.id , this.title ,this.youtube, this.content1, this.content2, this.content3,this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int count =0;//読み込み回数
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(youtube);
    String youtube_url_scheme = "${ConstText.YouTube_Movie_URLScheme}${videoId}";

    // ignore: close_sinks
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text("${title}"),
            actions: <Widget>[
              IconButton(
                  icon:Icon(Icons.share),
                  onPressed: (){
                    Share.share("雑学アプリ TRIVIA ■iOS:${ConstText.iOS_URL} ■Android:${ConstText.Android_URL} ■WEB:${ConstText.Web}");
                  }
              )
            ],

            leading:IconButton(
                icon:Icon(Icons.west,color:Colors.white),
                onPressed:() async{
                  await Navigator.pop(context);
                }
            )
        ),
        body: SafeArea(
          child:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                YoutubePlayer(
                  controller: _controller,

                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),

                  child: Column(

                    children:[
                      //コンテンツ
                      Text("${content1.replaceAll('\\n', '\n')}"
                          "${content2.replaceAll('\\n', '\n')}"
                          "${content3.replaceAll('\\n', '\n')}",
                        style: TextStyle(
                          fontSize: 17.5,
                        ),
                      ),
                    ],
                  ),
                ),
                //youtube_link
                Container(
                    padding: const EdgeInsets.all(15.0,),
                    alignment: Alignment.center,
                    child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          ButtonTheme(
                            minWidth: 250.0,
                            child: RaisedButton(
                              child:Text(
                                "Channel".replaceAll('\\n', '\n'),
                                style: TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white,
                                ),
                              ),
                              onPressed: (){
                                //launch("${ConstText.YouTubech_URL}");
                                _launchURL("${ConstText.YouTubech_URLScheme}","${ConstText.YouTubech_URL}");
                              },
                              color: Colors.cyan[700],

                            ),
                          ),
                          ButtonTheme(
                              minWidth: 250.0,
                              child:RaisedButton(
                                child:Text(
                                  "Movie",
                                  style: TextStyle(
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.bold,
                                    color:Colors.white,
                                  ),
                                ),
                                onPressed: (){
                                  _launchURL(youtube_url_scheme,youtube);
                                },
                                color: Colors.cyan[700],
                              )
                          ),
                        ]
                    )
                ),
              ],),

          ),
        ),

        floatingActionButton:
        Container(
            child:ChangeNotifierProvider<DBProvider>(
              create: (_) => DBProvider(),
              child: Consumer<DBProvider>(builder: (context, model, child) {
                if(count == 0) {
                  model.getFavoriteId(id);
                  //model.getFavoriteId2(id);

                  count ++;
                }else{
                  count = 0;
                }
                return FloatingActionButton(

                  child : (
                      (model.flg ) != true  ?
                      Icon(Icons.star,size: 40,color:Colors.white60) :
                      Icon(Icons.star,size: 40,color:Colors.yellow)),
                  onPressed: (){
                    //SQLite にデータがない場合(星マークなし)の時データ追加
                    if((model.flg ) != true) {
                      Bloc.create(favorite);
                      //SQLite にデータがある場合(星マークあり)の時データ削除
                    }else{
                      Bloc.delete(favorite.id);
                    }
                    //再描画
                    model.getFavoriteId(favorite.id);
                  },

                );
              }),
            )
        )

    );

  }

  Future _launchURL(String url,String secondUrl) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else if (secondUrl != null && await canLaunch(secondUrl)) {
      await launch(secondUrl,
        forceSafariVC: false,
        forceWebView: false,);
    } else {
      // 任意のエラー処理
    }
  }
}