import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/models.dart';

class BlocHome extends Bloc {
  final _streamController = StreamController<HomeState>();

  Sink<HomeState> get sink => _streamController.sink;
  Stream<HomeState> get stream => _streamController.stream;

  void init() {
    final resultat = HomeState(
      isActive: true,
      categorieModel: CategorieModel('', ''),
      categorielist: [],
      collectionReference: FirebaseFirestore.instance.collection('categories'),
    );
    sink.add(resultat);
  }

  BlocHome() {
    init();
  }

  @override
  dispose() {
    _streamController.close();
  }
}

class HomeState {
  final bool isActive;
  String? priority;
  CollectionReference? collectionReference;
  CategorieModel? categorieModel;
  List<CategorieModel>? categorielist;

  final db = FirebaseFirestore.instance;

  HomeState(
      {this.isActive = false,
      this.collectionReference,
      this.categorieModel,
      this.categorielist});

  Future<void> addCategorie() async {
    collectionReference = FirebaseFirestore.instance.collection('categories');

    await collectionReference!
        .doc()
        .set(categorieModel!.toJson())
        .then((value) => print('success'))
        .catchError((error) => print("Failed to  mmd: $error"));
  }

  Future<void> deleteCategorie(CategorieModel categorieModel) async {
    collectionReference = db.collection('categories');
    await collectionReference!
        .doc(categorieModel.id)
        .delete()
        .then((value) => print('Categories deleted'))
        .catchError((error) => print('$error'));
  }

  Future<void> updateCategorie(CategorieModel categorieModel) async {
    collectionReference = db.collection('categories');
    await collectionReference!
        .doc(categorieModel.id)
        .update(categorieModel.toJson())
        .then((value) => print('Categorie Updated'))
        .catchError((error) => print('$error'));
  }
}
