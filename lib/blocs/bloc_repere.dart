import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portoun/blocs/bloc.dart';
import 'package:portoun/models/categorie_model.dart';

class BlocRepere extends Bloc {
  final _streamController = StreamController<RepereState>();

  Stream<RepereState> get stream => _streamController.stream;
  Sink<RepereState> get sink => _streamController.sink;

  void init() {
    final resultat = RepereState(isActive: true);
    sink.add(resultat);
  }

  BlocRepere() {
    init();
  }

  @override
  dispose() {
    _streamController.close();
  }
}

class RepereState {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('categories');
  CategorieModel? categorieModel = CategorieModel('', '', '');
  final bool isActive;

  RepereState({this.isActive = false});
}
