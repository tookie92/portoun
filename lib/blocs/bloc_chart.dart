import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portoun/blocs/bloc.dart';
import 'package:portoun/models/categorie_model.dart';

class BlocChart extends Bloc {
  final _streamController = StreamController<ChartState>();
  CategorieModel? categorieModel;

  Sink<ChartState> get sink => _streamController.sink;
  Stream<ChartState> get stream => _streamController.stream;

  void init() {
    final resultat = ChartState(isActive: true);
    sink.add(resultat);
  }

  Future getCharts() async {
    var firestore = FirebaseFirestore.instance.collection('categories');

    QuerySnapshot qn = await firestore.get();
    qn.docs;
    return qn;
  }

  Future gloire() async {
    getCharts().then((value) {
      sink.add(ChartState(querySnapshot: value));
    });
  }

  BlocChart() {
    //gloirew();
    gloire();
    init();
  }

  @override
  dispose() {
    _streamController.close();
  }
}

class ChartState {
  final bool isActive;
  QuerySnapshot? querySnapshot;
  QuerySnapshot? query;

  ChartState({this.isActive = false, this.querySnapshot, this.query});
}
