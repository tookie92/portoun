import 'package:flutter/material.dart';
import 'package:portoun/blocs/bloc_provider.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/screens/screens.dart';
import 'package:portoun/ui/screens/see_page.dart';

class BlocRouter {
  MaterialPageRoute homePage() => MaterialPageRoute(builder: (ctx) => home());

  MaterialPageRoute editCatPage(CategorieModel cat) =>
      MaterialPageRoute(builder: (context) => editCat(cat));
  MaterialPageRoute seecatPage(CategorieModel cat) =>
      MaterialPageRoute(builder: (context) => seecat(cat));

  BlocProvider seecat(CategorieModel categorieModel) =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: SeePage(categorieModel));

  BlocProvider editCat(CategorieModel categorieModel) =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: EditPage(categorieModel));

  BlocProvider home() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: HomePage());
  BlocProvider accueil() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: Accueil());
}
