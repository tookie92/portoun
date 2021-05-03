import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/event_model.dart';
import 'package:portoun/models/models.dart';

class BlocHome extends Bloc {
  final _streamController = StreamController<HomeState>();

  Sink<HomeState> get sink => _streamController.sink;
  Stream<HomeState> get stream => _streamController.stream;

  PageController? pageController;

  void init() {
    final resultat = HomeState(
      isActive: true,
    );
    sink.add(resultat);
  }

  BlocHome() {
    init();

    pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.8,
    );
  }

  @override
  dispose() {
    _streamController.close();
  }
}

class HomeState {
  final bool isActive;
  CollectionReference? collectionReferencecat;

  //******Categorie *******/

  CollectionReference? collectionReference =
      FirebaseFirestore.instance.collection('categories');

  CategorieModel? categorieModel = CategorieModel('', '');
  EventModel? eventModel = EventModel('', '');

  //******* Ende *******/

  HomeState({
    this.isActive = false,
  });

  //********Categorie Model *********/
  final db = FirebaseFirestore.instance;

  Future<void> addCategorie() async {
    //collectionReference = FirebaseFirestore.instance.collection('categories');

    await collectionReference!
        .doc()
        .set(categorieModel!.toJson())
        .then((value) => print('success'))
        .catchError((error) => print("Failed to  mmd: $error"));
  }

  Future<void> deleteCategorie(CategorieModel categorieModel) async {
    //collectionReference = db.collection('categories');
    await collectionReference!
        .doc(categorieModel.id)
        .delete()
        .then((value) => print('Categories deleted'))
        .catchError((error) => print('$error'));
  }

  Future<void> updateCategorie(CategorieModel categorieModel) async {
    //collectionReference = db.collection('categories');
    await collectionReference!
        .doc(categorieModel.id)
        .update(categorieModel.toJson())
        .then((value) => print('Categorie Updated'))
        .catchError((error) => print('$error'));
  }
  //****** Ende  ********/

  //********Event Model *********/
  Future<void> addEvent(String categorie) async {
    collectionReferencecat =
        collectionReference!.doc(categorie).collection('events');

    await collectionReferencecat!
        .add(eventModel!.toJson())
        .then((value) => print('success'))
        .catchError((error) => print("Failed to  mmd: $error"));
  }

  Future<void> deleteEvent(
      EventModel eventModel, CategorieModel categorieModel) async {
    collectionReferencecat =
        collectionReference!.doc(categorieModel.id).collection('events');
    await collectionReferencecat!
        .doc(eventModel.id)
        .delete()
        .then((value) => print('Categories deleted'))
        .catchError((error) => print('$error'));
  }

  Future<void> updateEvent(
      EventModel eventModel, CategorieModel categorieModel) async {
    collectionReferencecat =
        collectionReference!.doc(categorieModel.id).collection('events');
    await collectionReferencecat!
        .doc(eventModel.id)
        .update(eventModel.toJson())
        .then((value) => print('Categorie Updated'))
        .catchError((error) => print('$error'));
  }
  //****** Ende  ********/

}
