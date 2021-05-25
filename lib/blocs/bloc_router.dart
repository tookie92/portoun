import 'package:flutter/material.dart';
import 'package:portoun/blocs/bloc_provider.dart';
import 'package:portoun/blocs/bloc_repere.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/screens/chart_page.dart';
import 'package:portoun/ui/screens/indexCalen.dart';
import 'package:portoun/ui/screens/screens.dart';

class BlocRouter {
  MaterialPageRoute homePage() => MaterialPageRoute(builder: (ctx) => home());
  MaterialPageRoute seecatPage(CategorieModel cat) =>
      MaterialPageRoute(builder: (context) => seecat(cat));
  MaterialPageRoute calendrierPage(CategorieModel cat) =>
      MaterialPageRoute(builder: (context) => calendrier(cat));
  MaterialPageRoute chartPage() =>
      MaterialPageRoute(builder: (ctx) => charti());
  MaterialPageRoute indexCalpage() =>
      MaterialPageRoute(builder: (ctx) => indexCal());

  BlocProvider indexCal() =>
      BlocProvider<BlocRepere>(bloc: BlocRepere(), child: IndexCalendar());
  BlocProvider charti() =>
      BlocProvider<BlocChart>(bloc: BlocChart(), child: ChartPage());
  BlocProvider calendrier(CategorieModel categorieModel) =>
      BlocProvider<BlocCalendar>(
          bloc: BlocCalendar(categorieModel),
          child: MyCalendar(categorieModel));
  BlocProvider seecat(CategorieModel categorieModel) =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: SeePage(categorieModel));
  BlocProvider home() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: HomePage());
  BlocProvider accueil() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: Accueil());
}
