import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portoun/blocs/bloc_provider.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class EditPage extends StatelessWidget {
  final CategorieModel categorieModel;
  EditPage(this.categorieModel);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocHome>(context);
    final mySize = MediaQuery.of(context).size;
    print(categorieModel.id);
    return Scaffold(
      body: Container(
        height: mySize.height,
        width: mySize.width,
        decoration: BoxDecoration(
          color: Colors.amber,
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
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                    ),
                    FutureBuilder<DocumentSnapshot>(
                        future: truc.collectionReference!
                            .doc(categorieModel.id)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // Map<String, dynamic>? data = snapshot.data!.data();
                            // return Text(
                            //    "Full Name: ${data!['title']} ${data['author']}");
                            return showThat(snapshot.data!, context);
                          }

                          return Text("loading");
                        }),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  showThat(DocumentSnapshot res, BuildContext context) {
    CategorieModel categorieModel = CategorieModel.fromSnapShot(res);
    final _formKey = GlobalKey<FormState>();
    // final size = MediaQuery.of(context).size;

    var item = Column(children: [
      MyText(
        label: 'Edit ${categorieModel.title}',
        color: Colors.white,
        fontSize: 30.0,
      ),
      SizedBox(
        height: 40.0,
      ),
      Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MyTextField(
                labelText: 'title',
                validator: (value) => value!.isEmpty ? 'Pleaseee' : null,
                initialValue: '${categorieModel.title}',
                onSaved: (newValue) => categorieModel.title = newValue,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container())
          ],
        ),
      ),
      SizedBox(
        height: 40.0,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
          ),
          MyTextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await HomeState()
                      .updateCategorie(categorieModel)
                      .then((value) => Navigator.of(context).pop());
                  print('id: ${categorieModel.id}');
                }
              },
              backgroundColor: Colors.white,
              label: 'ok'),
        ],
      )
    ]);

    return item;
  }
}
