import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/event_model.dart';
import 'package:portoun/models/models.dart';

class BlocHome extends Bloc {
  final _streamController = StreamController<HomeState>();
  CategorieModel? categorieModel;
  //image
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      sink.add(
        HomeState(image: File(pickedFile.path)),
      );
    } else {
      print('No picture');
    }
  }

  //Fin img;
  Sink<HomeState> get sink => _streamController.sink;
  Stream<HomeState> get stream => _streamController.stream;

  PageController? pageController;

  void init() {
    final resultat = HomeState(
      isActive: true,
    );
    sink.add(resultat);
  }

  void done() {
    final resultat = HomeState(
      isDone: true,
    );
    sink.add(resultat);
  }

  Stream<QuerySnapshot>? getEvent(CategorieModel? categorieModel) {
    var firestore = FirebaseFirestore.instance
        .collection('categories')
        .doc(categorieModel!.id)
        .collection('events');

    Stream<QuerySnapshot> qn = firestore.snapshots();
    return qn;
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
  File image;
  final picker = ImagePicker();

  //nur image oben
  final bool isActive;
  final bool isDone;
  QuerySnapshot? querySnapshot;
  CollectionReference? collectionReferencecat;
  final List<String> items = ['Done', 'Pending', 'In Process'];

  //******Categorie *******/

  CollectionReference? collectionReference =
      FirebaseFirestore.instance.collection('categories');

  CategorieModel? categorieModel = CategorieModel('', '', '', '', '');
  EventModel? eventModel = EventModel('', '', '');

  //******* Ende *******/

  HomeState({
    this.isDone = false,
    this.isActive = false,
    this.querySnapshot,
    image,
  }) : image = image ??
            File('/Users/mac/Desktop/djang/portoun/assets/images/default.png');

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

  Future<void> updateCategory(String categorie) async {
    //collectionReference = db.collection('categories');
    await collectionReference!
        .doc(categorie)
        .update({'count': FieldValue.increment(1)})
        .then((value) => print('Categorie Updated'))
        .catchError((error) => print('$error'));
  }

  Future<void> deleteCategory(String categorie) async {
    //collectionReference = db.collection('categories');
    await collectionReference!
        .doc(categorie)
        .update({'count': FieldValue.increment(-1)})
        .then((value) => print('Categorie Updated'))
        .catchError((error) => print('$error'));
  }
  //****** Ende  ********/

  //********Event Model *********/
  Future<void> addEvent(String? categorie) async {
    collectionReferencecat =
        collectionReference!.doc(categorie).collection('events');

    await collectionReferencecat!
        .add(eventModel!.toJson())
        .then((value) => print('success'))
        .catchError((error) => print("Failed to  mmd: $error"));
  }

  Future<void> deleteEvent(EventModel eventModel, String categorieModel) async {
    collectionReferencecat =
        collectionReference!.doc(categorieModel).collection('events');
    await collectionReferencecat!
        .doc(eventModel.id)
        .delete()
        .then((value) => print('Categories deleted'))
        .catchError((error) => print('$error'));
  }

  Future<void> updateEvent(EventModel eventModel, String categorieModel) async {
    collectionReferencecat =
        collectionReference!.doc(categorieModel).collection('events');
    await collectionReferencecat!
        .doc(eventModel.id)
        .update(eventModel.toJson())
        .then((value) => print('Categorie Updated'))
        .catchError((error) => print('$error'));
  }

  //****** Ende  ********/

}
