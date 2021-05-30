import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mobad/mobad.dart';
import '../../repositories/db_provider.dart';
import '../../configs/const_text.dart';
import '../../models/trivia.dart';
import '../../repositories/trivia_bloc.dart';
import '../trivia_detail/trivia_detail_view.dart';


class TriviaList extends StatelessWidget {
  int count = 0;
  String  searchtxt = '';

  textsave(text) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('search', text);
    print(text);
  }

  textread() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    searchtxt = prefs.getString('search') ?? '' ;
  }

  final myController = TextEditingController();


  @override
  Widget build(BuildContext context) {



    final _bloc = Provider.of<TriviaBloc>(context, listen: false);
    Firebase.initializeApp();

    return Scaffold(
        appBar: AppBar(
            //左アイコン
            leading: IconButton(
              icon:Icon(EvaIcons.twitter),
                onPressed: (){
                    _launchURL(ConstText.twitterURLScheme,ConstText.twitterURL);
                }
            ),

            //文字列
            centerTitle: true,
            title: Text(ConstText.triviaListView),

            //右アイコン
            actions: <Widget>[
              IconButton(
                  icon:Icon(Icons.share),
                  onPressed: (){
                      Share.share("雑学アプリ TRIVIA ■iOS:${ConstText.iOS_URL} ■Android:${ConstText.Android_URL} ■WEB:${ConstText.Web}");
                  }
              )
            ],
        ),


        body: SafeArea(
            // ignore: missing_required_param
            child:ChangeNotifierProvider<DBProvider>(
            create: (_) => DBProvider(),

                child: Consumer<DBProvider>(builder: (context, model, child) {

                    return SingleChildScrollView(

                        child:Column(

                            children: <Widget>[

                            Padding(
                                padding: EdgeInsets.all(10.0),

                                child:TextFormField(
                                    autofocus: false,
                                    style: new TextStyle(
                                        fontSize: 17.5,
                                        color: Colors.white,
                                    ),
                                    controller: TextEditingController(text: "${searchtxt}"),
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(Icons.search),
                                        //border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(5.0),
                                        hintText: 'search',
                                        border: new OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(
                                              const Radius.circular(10.0),
                                            )
                                        )
                                    ),

                                    onChanged: (text) async{
                                        _bloc.getSearch(text);
                                    },

                                ),
                            ),

                            StreamBuilder<List<Trivia>>(
                                stream: _bloc.triviaStream,
                                builder: (BuildContext context, AsyncSnapshot<List<Trivia>> snapshot) {
                                if(snapshot.hasData) {
                                  if (snapshot.data.length > 0) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      //itemCount: snapshot.data.length,
                                      itemCount: snapshot.data.length,
                                      // ignore: missing_return
                                      itemBuilder: (BuildContext context,
                                          int index,) {
                                        //if(snapshot.data.length > 0){
                                        return _listItem(
                                            index, _bloc, snapshot);
                                      },
                                    );
                                  }else{
                                    return Center(child: Text("No Results",
                                      style: TextStyle(fontSize: 20),));
                                  }
                                }
                                    return Center(child: CircularProgressIndicator());
                                },
                            ),
                          ]
                        )
                    );
                }),
            )
        ),

    );

  }

  _listItem(index, TriviaBloc _bloc, AsyncSnapshot<List<Trivia>> snapshot){

    Trivia trivia = snapshot.data[index];

    return  Card(
        child: ChangeNotifierProvider<DBProvider>(
            create: (_) => DBProvider(),
            child: Consumer<DBProvider>(builder: (context, model, child) {

              if( count < snapshot.data.length) {
                //お気に入りマーク再描画
                model.getFavoriteId(trivia.id);
                count ++;
              }else{
                _bloc.update(trivia);
                count = 0;
              }
              return ListTile(
              //child: ListTile(
                  onTap: (){
                    //広告表示
                    Adcount.counter();
                    _moveToDetailView(context, _bloc, trivia, model.flg,
                    trivia.id, trivia.title ,trivia.youtube ,trivia.content1, trivia.content2, trivia.content3,trivia.genre,
                      model
                    );
                  },

                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                  child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children:[//Text("${trivia.id}${trivia.title}"),
                        Text("${trivia.id}"),
                        Text("  ${trivia.title}")
                      ]),
                  ),

                  trailing: IconButton(
                    //icon変化
                      icon: (Icon(Icons.star)),
                      color: ((model.flg) != true ? Colors.grey : Colors.yellow),
                      onPressed: (){
//
                          if((model.flg ) != true) {  //SQLite にデータがない場合(星マークなし)の時データ追加
                              _bloc.create(trivia);
//
                          }else{
                            _bloc.delete(trivia.id);
                          }
                        //再描画
                          model.getFavoriteId(trivia.id);
                      })
              );
            })

        )

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

  _moveToDetailView(BuildContext context, TriviaBloc bloc , Trivia trivia, bool flg,
      int id, String title,String Youtube ,String c1, String c2, String c3, String genre,DBProvider model,  ) =>
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            TriviaDetailView
              (Bloc: bloc, trivia: trivia, flg:flg ,
              id: id, title:title ,youtube:Youtube ,content1:c1, content2:c2, content3:c3,genre:genre))
  ).then((value){//戻った時実行する処理
        model.getFavoriteId(trivia.id);
      });


}