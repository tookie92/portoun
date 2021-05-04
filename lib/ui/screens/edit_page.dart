import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portoun/blocs/bloc_provider.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class EditPage extends StatelessWidget {
  final CategorieModel? categorieModel;
  EditPage(this.categorieModel);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<BlocHome>(context);
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: size.height,
          child: ListView(
            children: [
              StreamBuilder<HomeState>(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  final truc = snapshot.data;
                  if (truc == null) {
                    return Center(
                      child: Text('data'),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text('data1'),
                    );
                  } else {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 80.0),
                      child: SizedBox(
                        height: size.height * 0.2,
                        child: FutureBuilder<DocumentSnapshot>(
                          future: truc.collectionReference!
                              .doc(categorieModel!.id)
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
                              Map<String, dynamic>? data =
                                  snapshot.data!.data();
                              return Column(
                                children: [
                                  Text(
                                    "Full Name: ${data!['title']} ${data['author']}",
                                  ),
                                  MyTextField(
                                    validator: (value) =>
                                        value!.isEmpty ? 'pleee' : null,
                                    initialValue: data['title'],
                                  )
                                ],
                              );

                              // return showThat(snapshot.data!, context);
                            }

                            return Text("loadings");
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
