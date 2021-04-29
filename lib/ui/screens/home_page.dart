import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/models.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<BlocHome>(context);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(color: Colors.black),
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
                  child: MyText(label: 'es kommt nichts'),
                ),
              );
            } else {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 70.0,
                    floating: true,
                    //pinned: true,
                    backgroundColor: Colors.transparent,
                    forceElevated: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: MyText(
                        label: 'Ilanga',
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            //
                            await showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('AlertDialog Title'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Form(
                                            key: _formKey,
                                            child: MyTextField(
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? 'Please'
                                                      : null,
                                              onSaved: (newValue) => truc
                                                  .categorieModel!
                                                  .title = newValue,
                                              labelText: 'title',
                                            ))
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Approve'),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          print(
                                              '${truc.categorieModel!.title}');
                                          await truc.addCategorie().then(
                                              (value) =>
                                                  Navigator.of(context).pop());
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        height: size.height * 0.8,
                        width: size.width,
                        decoration: BoxDecoration(color: Colors.black),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            MyText(
                              label: 'Dashboard',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            MyText(
                              label: 'Make each day your masterpiece',
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                              letterSpacing: 1.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: truc.collectionReference!.snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("Loading");
                                }

                                return (snapshot.data!.docs.isEmpty)
                                    ? Container(
                                        height: size.height * 0.4,
                                        width: size.width,
                                        child: Center(
                                          child: MyText(
                                            label:
                                                'no Categories press the green button',
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 300.0,
                                        width: size.width,
                                        child: ListView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          children: snapshot.data!.docs
                                              .map((DocumentSnapshot document) {
                                            return Container(
                                              child: showCategorie(
                                                  document, context),
                                            );
                                          }).toList(),
                                        ),
                                      );
                              },
                            ),
                          ],
                        ),
                      );
                    }, childCount: 1),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  showCategorie(DocumentSnapshot res, BuildContext context) {
    CategorieModel categorieModel = CategorieModel.fromSnapShot(res);
    final size = MediaQuery.of(context).size;

    var item = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Stack(
          children: [
            Container(
              height: 300.0,
              width: 200.0,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(05.0)),
            ),
            Positioned(
                top: size.height * 0.15,
                left: size.height * 0.18,
                child: Container(
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.redAccent, shape: BoxShape.circle),
                )),
            Positioned(
                top: size.height * 0.20,
                left: size.height * 0.24,
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.amber, shape: BoxShape.circle),
                )),
            //design ende
            Positioned(
              top: size.height * 0.02,
              left: size.width * 0.03,
              child: MyText(
                label: '${categorieModel.title}',
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),

            Positioned(
              top: size.height * 0.05,
              child: Row(
                children: [
                  IconButton(
                      onPressed: ()  {
                        print('ok');
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context, BlocRouter().editCatPage(categorieModel));
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () async {
                        await HomeState().deleteCategorie(categorieModel);
                        // await _showMyUpdate(context, categorieModel);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      )),
                ],
              ),
            )
          ],
        ));

    return item;
  }
}
