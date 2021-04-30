import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        decoration: BoxDecoration(color: Colors.white),
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
                    expandedHeight: 90.0,
                    //floating: true,
                    elevation: 0,
                    pinned: true,
                    backgroundColor: Colors.white,
                    forceElevated: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: MyText(
                        label: DateFormat.yMMMd('fr').format(DateTime.now()),
                        color: Colors.black,
                      ),
                    ),
                    leading: Icon(
                      Icons.bento_outlined,
                      color: Colors.black,
                    ),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            //
                            await showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
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
                                    MyTextButton(
                                      label: 'Approve',
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          print(
                                              '${truc.categorieModel!.title}');
                                          await truc.addCategorie();
                                        }
                                      },
                                    ),
                                    MyTextButton(
                                      label: 'Cancel',
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
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
                      return Container(
                        height: size.height,
                        width: size.width,
                        decoration: BoxDecoration(color: Colors.white),
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
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            MyText(
                              label: 'Make each day your masterpiece',
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                              letterSpacing: 1.0,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 29.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    label: 'Projects',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  MyText(
                                    label: 'More',
                                    color: Colors.black.withOpacity(0.3),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: StreamBuilder<QuerySnapshot>(
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
                                      : Container(
                                          height: 280.0,
                                          width: size.width,
                                          //color: Colors.blueAccent,
                                          child: ListView(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            children: snapshot.data!.docs.map(
                                                (DocumentSnapshot document) {
                                              return Container(
                                                child: showCategorie(
                                                    document, context),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 29.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    label: 'Pending',
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  MyText(
                                    label: 'More',
                                    color: Colors.black.withOpacity(0.3),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
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
    // var mark = categorieModel.priority;
    Color? clr;
    Image? img;

    switch (categorieModel.priority) {
      case 'Done':
        img = Image(
          image: AssetImage('assets/images/done.png'),
          height: 150.0,
          width: 150.0,
        );
        clr = Color(0xffFFBF73);
        break;

      case 'In Process':
        img = Image(
          image: AssetImage('assets/images/inprozess.png'),
          height: 130.0,
          width: 130.0,
        );
        clr = Color(0xff7DDFFB);
        break;

      case 'Pending':
        img = Image(
          image: AssetImage('assets/images/pending.png'),
          height: 130.0,
          width: 130.0,
        );
        clr = Color(0xffF96A95);
        break;
      // etc.
      default:
        img = Image(
          image: AssetImage('assets/images/default.png'),
          height: 130.0,
          width: 130.0,
        );
        clr = Colors.green;
    }

    var item = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Stack(
          children: [
            Container(
              height: 280.0,
              width: 280.0,
              decoration: BoxDecoration(
                color: clr,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),

            //design ende
            Positioned(
              bottom: size.height * 0.14,
              right: size.width * 0.35,
              child: Container(child: FadeInLeft(child: img)),
            ),

            Positioned(
              top: size.height * 0.13,
              left: size.width * 0.06,
              child: MyText(
                label: '${categorieModel.title}',
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),

            Positioned(
              top: size.height * 0.02,
              right: size.width * 0.06,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  child: MyText(
                    label: categorieModel.priority == null
                        ? 'nichts'
                        : categorieModel.priority,
                    color: clr,
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            Positioned(
              top: size.height * 0.17,
              left: size.width * 0.04,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      print('ok');
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                    iconSize: 20.0,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context, BlocRouter().editCatPage(categorieModel));
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    iconSize: 20.0,
                  ),
                  IconButton(
                    onPressed: () async {
                      await HomeState().deleteCategorie(categorieModel);
                      // await _showMyUpdate(context, categorieModel);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    iconSize: 20.0,
                  ),
                ],
              ),
            )
          ],
        ));

    return item;
  }
}
