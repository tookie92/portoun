import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String? title;
  String? author;

  EventModel(this.title, this.author);

  EventModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        title = doc.data()!['title'],
        author = doc.data()!['author'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'title': this.title,
      'author': 'joseph ikinda',
    };

    if (id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}
