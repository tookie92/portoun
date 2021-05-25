import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String? title;
  String? debut;
  String? fin;
  String? author;

  EventModel(this.title, this.author, this.fin,
    this.debut,);

  EventModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        title = doc.data()!['title'],
        debut = doc.data()!['debut'],
        fin = doc.data()!['fin'],
        author = doc.data()!['author'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'title': this.title,
      'debut': this.debut,
      'fin': this.fin,
      'author': 'joseph ikinda',
    };

    if (id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}
