import 'package:cloud_firestore/cloud_firestore.dart';

class CategorieModel {
  String? id;
  String? title;
  String? priority;
  String? debut;
  String? fin;
  String? author;

  CategorieModel(this.title, this.priority, this.fin, this.debut, this.author);

  CategorieModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.id,
        title = doc.data()!['title'],
        priority = doc.data()!['priority'],
        debut = doc.data()!['debut'],
        fin = doc.data()!['fin'],
        author = doc.data()!['author'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'title': this.title,
      'priority': this.priority,
      'debut': this.debut,
      'fin': this.fin,
      'author': 'joseph ikinda'
    };

    if (id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}
