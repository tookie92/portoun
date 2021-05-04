import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
              // print(truc.eventModel!.!.length.toString());
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 100.0,
                    floating: true,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: MyText(
                        label: 'Events',
                        color: Colors.black,
                      ),
                      centerTitle: true,
                    ),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            await _showMyDialog(context, s, categorieModel.id);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return FutureBuilder<DocumentSnapshot>(
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
                              CategorieModel trac =
                                  CategorieModel.fromSnapShot(snapshot.data!);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  MyText(
                                    label: 'Title: ${trac.title}',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  MyText(
                                    label: categorieModel.debut == null
                                        ? 'No Date'
                                        : 'Date: ${trac.debut}',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                ],
                              );
                              // Map<String, dynamic>? data = snapshot.data!.data();
                              // return Text(
                              //    "Full Name: ${data!['title']} ${data['author']}");

                            }

                            return Text("loading");
                          },
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('categories')
                              .doc(categorieModel.id)
                              .collection('events')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            return SizedBox(
                              height: size.height * 0.5,
                              child: snapshot.data!.docs.isEmpty
                                  ? Center(
                                      child: MyText(
                                        label: 'Nothing',
                                        color: Colors.black,
                                      ),
                                    )
                                  : ListView(
                                      children: snapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                        //  print(snapshot.data!.docs.length);
                                        EventModel trac =
                                            EventModel.fromSnapshot(document);
                                        return Slidable(
                                          actionPane:
                                              SlidableStrechActionPane(),
                                          actionExtentRatio: 0.25,
                                          child: Container(
                                            color: Colors.white,
                                            child: new ListTile(
                                              leading: Icon(
                                                  Icons.book_online_rounded),
                                              title: new MyText(
                                                label: '${trac.title}',
                                                color: Colors.black,
                                              ),
                                              subtitle: new MyText(
                                                  label: '${trac.author}'),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            IconSlideAction(
                                              caption: 'Edit',
                                              color: Colors.blue,
                                              icon: Icons.edit,
                                              onTap: () async {
                                                await _showMyUpdate(
                                                    context,
                                                    trac,
                                                    '${categorieModel.id}');
                                              },
                                            ),
                                          ],
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              caption: 'More',
                                              color: Colors.black45,
                                              icon: Icons.more_horiz,
                                              onTap: () => print('More'),
                                            ),
                                            IconSlideAction(
                                              caption: 'Delete',
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () => truc.deleteEvent(
                                                  trac, '${categorieModel.id}'),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                            );
                          },
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

//***** Add Event ******/
Future<void> _showMyDialog(
  BuildContext context,
  AsyncSnapshot<HomeState> sn,
  String? categorieModele,
) async {
  HomeState? homeState = sn.data;

  final _formKey = GlobalKey<FormState>();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add a Event'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Form(
                key: _formKey,
                child: MyTextField(
                  validator: (value) => value!.isEmpty ? 'Please enter ' : null,
                  labelText: 'Event',
                  onSaved: (newValue) =>
                      homeState!.eventModel!.title = newValue,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          MyTextButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          MyTextButton(
            label: 'Save',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                print(homeState!.eventModel!.title);
                // print(homeState.categorieModel!.id);

                await homeState
                    .addEvent(categorieModele!)
                    .then((value) => Navigator.pop(context));
              }
              _formKey.currentState!.reset();
            },
          ),
        ],
      );
    },
  );
}

//******Update Event */
Future<void> _showMyUpdate(
  BuildContext context,
  EventModel eventModel,
  String? categorieModel,
) async {
  print(eventModel.id);
  final _formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${eventModel.title}'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categorieModel)
                    .collection('events')
                    .doc(eventModel.id)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("Document does not exist");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    EventModel eventModel =
                        EventModel.fromSnapshot(snapshot.data!);
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextField(
                            initialValue: eventModel.title,
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter ' : null,
                            labelText: 'Event',
                            onSaved: (newValue) => eventModel.title = newValue,
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          MyTextButton(
                            backgroundColor: Colors.amber,
                            colorText: Colors.white,
                            label: 'Enter',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                print(eventModel.title);

                                // print(homeState.categorieModel!.id);

                                await HomeState()
                                    .updateEvent(eventModel, categorieModel!)
                                    .then(
                                      (value) => Navigator.pop(context),
                                    );
                              }
                              _formKey.currentState!.reset();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return Text("loading");
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      );
    },
  );
}
