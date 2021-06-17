# trivia_app
##libファイルしか存在しない理由
  libファイルしか存在しないのはfirestoreを利用しているためです
  また、アプリのリリースを行っていない理由は
  アプリ開発者である私がマスターデータを作成するのに時間がかかっているためです
  (YouTubeの動画を作成する必要有)

##使用技術
  Firestore,FCM,MobAd,etc....

##アプリの目的
1.雑学をまとめたアプリケーション
2.雑学に関わるアプリをリリースした際にそのアプリをインストールしてもらえる
   ようにする

※サイコロのダイスは5の目が最も出やすい
  この雑学とともにイカサマダイスアプリをリリースする予定

##他の雑学アプリとの差別化
1.YouTubeの動画をマスターデータとして使用することで雑学を文字だけではなく
   視覚的に理解してもらえるようにしました

2.他の雑学アプリはおそらくSQLiteを利用しているが、
   データベースはfirestoreを利用しているため、随時更新することが可能
   ※Firestoreのデータを手で作成し続けるのは手間がかかるため
     Node.jsを用いてテキストファイルの内容をFirestoreにデータとして作成するバッチを作成

##気をつけたところ
   お気に入りに登録した雑学はSQLiteに登録されますが、
   マスターデータに何か問題が起きた場合、エラーが起きてしまいます。
   そうなった際にFirestoreのデータを読み込むと同時にお気に入りに登録したデータも更新されるようにしました
   想定される原因
   YouTubeの動画が削除されたなど

##Flutter Web版
  お気に入り機能(SQLite)の機能がないWebアプリ版はFirebaseを用いてデプロイ済み
