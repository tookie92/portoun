import 'package:flutter/material.dart';
import 'package:portoun/blocs/bloc_provider.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/screens/screens.dart';
import 'package:portoun/ui/screens/see_page.dart';

class BlocRouter {
  MaterialPageRoute homePage() => MaterialPageRoute(builder: (ctx) => home());

  MaterialPageRoute seecatPage(CategorieModel cat) =>
      MaterialPageRoute(builder: (context) => seecat(cat));
  MaterialPageRoute calendrierPage() =>
      MaterialPageRoute(builder: (context) => calendrier());

  BlocProvider calendrier() =>
      BlocProvider<BlocCalendar>(bloc: BlocCalendar(), child: MyCalendar());
  BlocProvider seecat(CategorieModel categorieModel) =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: SeePage(categorieModel));

  BlocProvider home() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: HomePage());
  BlocProvider accueil() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: Accueil());
}
