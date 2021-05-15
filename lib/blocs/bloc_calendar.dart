import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portoun/blocs/blocs.dart';

class BlocCalendar extends Bloc {
  final _streamController = StreamController<CalendarState>();

  Sink<CalendarState> get sink => _streamController.sink;
  Stream<CalendarState> get stream => _streamController.stream;

  void init() {
    final resultat = CalendarState(isActive: true);
    sink.add(resultat);
  }

  Future<QuerySnapshot>? getCategorie() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('categories').get();

    qn.docs;

    return qn;
  }

  Future gloire() async {
    getCategorie()!.then((results) {
      sink.add(CalendarState(querySnapshot: results));
    });
  }

  BlocCalendar() {
    init();
    gloire();
  }

  @override
  dispose() {
    _streamController.close();
  }
}

class CalendarState {
  QuerySnapshot? querySnapshot;
  dynamic data;
  List<Color>? colorCollection;
  final bool isActive;

  CalendarState({this.isActive = false, this.querySnapshot, this.data});
}
