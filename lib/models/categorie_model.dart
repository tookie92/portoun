import 'package:cloud_firestore/cloud_firestore.dart';

class CategorieModel {
  String? id;
  String? title;
  String? author;

  CategorieModel(this.title, this.author);

  CategorieModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.id,
        title = doc.data()!['title'],
        author = doc.data()!['author'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'title': this.title, 'author': 'joseph ikinda'};
    return map;
  }
}
