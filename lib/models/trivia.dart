import 'package:cloud_firestore/cloud_firestore.dart';

class Trivia {
  int id;
  String title;
  String content1;
  String content2;
  String content3;
  String youtube;
  String genre;
  int cr_date;
  DocumentReference documentReference;

  Trivia(doc) {
    //Trivia(QuerySnapshot doc){
    this.documentReference = doc.reference;
    this.id = doc.data()['id'];
    this.title = doc.data()['title'];
    this.content1 = doc.data()['content1'];
    this.content2 = doc.data()['content2'];
    this.content3 = doc.data()['content3'];
    this.youtube = doc.data()['youtube'];
    this.cr_date = doc.data()['cr_date'];
    this.genre = doc.data()['genre'];
  }
//追加
  Trivia.newTrivia({
    id,
    title,
    youtube,
    content1,
    content2,
    content3,
    cr_date,
    genre,
  }) {
    this.id = id;
    this.title = title;
    this.content1 = content1;
    this.content2 = content2;
    this.content3 = content3;
    this.youtube = youtube;
    this.cr_date = cr_date;
    this.genre = genre;
  }

  factory Trivia.fromMap(Map<String, dynamic> json) => Trivia.newTrivia(
        id: json["id"],
        title: json["title"],
        content1: json["content1"],
        content2: json["content2"],
        content3: json["content3"],
        youtube: json["youtube"],
        cr_date: json["cr_date"],
        genre: json["genre"],
      );

  Map<String, dynamic> toMap() => {
        "id": this.id,
        "title": this.title,
        "content1": this.content1,
        "content2": this.content2,
        "content3": this.content3,
        "youtube": this.youtube,
        "cr_date": this.cr_date,
        "genre": this.genre
      };
}
