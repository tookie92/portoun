import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portoun/blocs/blocs.dart';

class BlocCalendar extends Bloc {
  final _streamController = StreamController<CalendarState>();

  Sink<CalendarState> get sink => _streamController.sink;
  Stream<CalendarState> get stream => _streamController.stream;

  void init() {
    final resultat = CalendarState(isActive: true);
    sink.add(resultat);
  }

  Future getCategorie() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('categories').get();

    return qn.docs;
  }

  BlocCalendar() {
    init();
  }

  @override
  dispose() {
    _streamController.close();
  }
}

class CalendarState {
  final bool isActive;

  CalendarState({this.isActive = false});
}
