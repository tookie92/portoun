import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String? title;
  String? picture;
  String? author;

  EventModel(this.title, this.author);

  EventModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        title = doc.data()!['title'],
        picture = doc.data()!['picture'],
        author = doc.data()!['author'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'title': this.title,
      'picture': this.picture,
      'author': 'joseph ikinda',
    };

    if (id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}
