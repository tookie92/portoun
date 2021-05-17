import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portoun/blocs/blocs.dart';

class BlocCalendar extends Bloc {
  final _streamController = StreamController<CalendarState>();
  List<Color>? colorCollection;

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

  void initializeEventColor() {
    this.colorCollection = [];
    colorCollection!.add(const Color(0xFF0F8644));
    colorCollection!.add(const Color(0xFF8B1FA9));
    colorCollection!.add(const Color(0xFFD20100));
    colorCollection!.add(const Color(0xFFFC571D));
    colorCollection!.add(const Color(0xFF36B37B));
    colorCollection!.add(const Color(0xFF01A1EF));
    colorCollection!.add(const Color(0xFF3D4FB5));
    colorCollection!.add(const Color(0xFFE47C73));
    colorCollection!.add(const Color(0xFF636363));
    colorCollection!.add(const Color(0xFF0A8043));
  }

  BlocCalendar() {
    initializeEventColor();
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
  String getMonthName(int month) {
    if (month == 01) {
      return 'January';
    } else if (month == 02) {
      return 'February';
    } else if (month == 03) {
      return 'March';
    } else if (month == 04) {
      return 'April';
    } else if (month == 05) {
      return 'May';
    } else if (month == 06) {
      return 'June';
    } else if (month == 07) {
      return 'July';
    } else if (month == 08) {
      return 'August';
    } else if (month == 09) {
      return 'September';
    } else if (month == 10) {
      return 'October';
    } else if (month == 11) {
      return 'November';
    } else {
      return 'December';
    }
  }

  CalendarState({this.isActive = false, this.querySnapshot, this.data});
}
