import 'package:cloud_firestore/cloud_firestore.dart';

class CategorieModel {
  String? id;
  String? title;
  String? priority;
  String? author;
  int? count;

  CategorieModel(
    this.title,
    this.priority,
    this.author,
  );

  CategorieModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.id,
        title = doc.data()!['title'],
        priority = doc.data()!['priority'],
       
        author = doc.data()!['author'],
        count = doc.data()!['count'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'title': this.title,
      'priority': this.priority,
      
      'count': this.count,
      'author': 'joseph ikinda'
    };

    if (id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}
