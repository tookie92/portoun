import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:portoun/blocs/bloc_provider.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie-sett/c_settings.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class EditPage extends StatelessWidget {
  final CategorieModel categorieModel;
  EditPage(this.categorieModel);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocHome>(context);
    final mySize = MediaQuery.of(context).size;
    //print(categorieModel.id);
    return Scaffold(
      body: Container(
        height: mySize.height,
        width: mySize.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: StreamBuilder<HomeState>(
          stream: bloc.stream,
          builder: (context, s) {
            final truc = s.data;
            if (truc == null) {
              return Center(
                child: Container(
                  child: MyText(label: 'es ladt'),
                ),
              );
            } else if (!s.hasData) {
              return Center(
                child: Container(
                  child: MyText(label: 'es wird nicht'),
                ),
              );
            } else {
              return FutureBuilder<DocumentSnapshot>(
                  future:
                      truc.collectionReference!.doc(categorieModel.id).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      // Map<String, dynamic>? data = snapshot.data!.data();
                      // return Text(
                      //    "Full Name: ${data!['title']} ${data['author']}");
                      return showThat(snapshot.data!, context);
                    }

                    return Text("loading");
                  });
            }
          },
        ),
      ),
    );
  }
}
