import 'package:flutter/material.dart';
import 'package:portoun/blocs/bloc_provider.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/screens/screens.dart';

class BlocRouter {
  MaterialPageRoute homePage() => MaterialPageRoute(builder: (ctx) => home());

  MaterialPageRoute editCatPage(CategorieModel cat) =>
      MaterialPageRoute(builder: (context) => editCat(cat));

  BlocProvider editCat(CategorieModel categorieModel) =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: EditPage(categorieModel));
      
  BlocProvider home() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: HomePage());
  BlocProvider accueil() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: Accueil());
}
