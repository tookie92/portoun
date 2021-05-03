import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/models/event_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class SeePage extends StatelessWidget {
  final CategorieModel categorieModel;

  SeePage(this.categorieModel);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<BlocHome>(context);
    print(categorieModel.id);
    // final _formkey = GlobalKey<FormState>();
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
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
                  child: MyText(label: 'es ladt nichts'),
                ),
              );
            } else {
              return Center(
                child: Container(
                  child: Column(
                    children: [
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
                              //  Map<String, dynamic>? data = snapshot.data!.data();
                              //  return Text(
                              //     "Full Name: ${data!['id']} ${data['title']}");
                              return apercuPage(snapshot.data!, context);
                            }

                            return Text("loading");
                          }),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

apercuPage(DocumentSnapshot res, BuildContext context) {
  CategorieModel categorieModel = CategorieModel.fromSnapShot(res);
  //AsyncSnapshot<HomeState> snapshot;

  final size = MediaQuery.of(context).size;

  final String jour = categorieModel.debut == null
      ? 'No Date'
      : categorieModel.debut.toString();

  var item = Column(
    children: [
      SizedBox(
        height: size.height * 0.07,
      ),
      MyTextButton(
        backgroundColor: Colors.amber,
        colorText: Colors.white,
        label: 'Back',
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      SizedBox(
        height: size.height * 0.01,
      ),
      MyText(
        label: 'Name: ${categorieModel.title}',
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 30.0,
      ),
      SizedBox(
        height: size.height * 0.01,
      ),
      MyText(
        label: 'author: ${categorieModel.author}  Date: $jour',
      ),
      SizedBox(
        height: size.height * 0.01,
      ),
      MyTextButton(
        label: 'add',
        onPressed: () async {
          await _showMyDialog(context);
        },
      ),
      SizedBox(
        height: size.height * 0.02,
      ),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .doc(categorieModel.id)
            .collection('events')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return SizedBox(
            height: size.height * 0.5,
            child: snapshot.data!.docs.isEmpty
                ? Column(
                    children: [
                      MyText(
                        label: 'nothing',
                      ),
                    ],
                  )
                : ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Container(
                        child: listEvent(document),
                      );
                    }).toList(),
                  ),
          );
        },
      )
    ],
  );

  return item;
}

listEvent(DocumentSnapshot res) {
  EventModel eventModel = EventModel.fromSnapshot(res);

  var item = Column(
    children: [
      MyText(
        label: '${eventModel.title}',
        color: Colors.black,
      )
    ],
  );

  return item;
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

formEvent(AsyncSnapshot<HomeState> sn, String? categorieModele,
    CategorieModel? categorieModel) {
  HomeState? homeState = sn.data;

  final _formKey = GlobalKey<FormState>();

  var item = Column(
    children: [
      Form(
        key: _formKey,
        child: MyTextField(
          validator: (value) => value!.isEmpty ? 'Please enter ' : null,
          labelText: 'Event',
          onSaved: (newValue) => homeState!.eventModel!.title = newValue,
        ),
      ),
      MyTextButton(
          label: 'label',
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              print(homeState!.eventModel!.title);
              // print(homeState.categorieModel!.id);

              await homeState.addEvent(categorieModele!);
            }
            _formKey.currentState!.reset();
          })
    ],
  );

  return item;
}
