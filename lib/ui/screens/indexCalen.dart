import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portoun/blocs/bloc_repere.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class IndexCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<BlocRepere>(context);
    return Scaffold(
      //appBar: AppBar(),
      body: Container(
        height: size.height,
        width: size.width,
        child: StreamBuilder<RepereState>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            final truc = snapshot.data;
            if (truc == null) {
              return Center(
                child: MyText(
                  label: 'dara',
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: MyText(
                  label: 'dara 2',
                ),
              );
            } else {
              return Container(
                  height: size.height,
                  width: size.width,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 100.0,
                        floating: true,
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            color: Colors.black,
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: MyText(
                            label: 'Calendar',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return StreamBuilder<QuerySnapshot>(
                                stream: truc.collectionReference
                                    .where('count', isGreaterThan: 0)
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

                                  return (snapshot.data!.docs.isEmpty)
                                      ? Container(
                                          height: size.height * 0.6,
                                          width: size.width,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: size.height * 0.3,
                                              ),
                                              Bounce(
                                                from: 10.0,
                                                child: Container(
                                                  height: 50.0,
                                                  width: 50.0,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      shape: BoxShape.circle),
                                                  child: Center(
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .exclamation,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              MyText(
                                                textAlign: TextAlign.center,
                                                label: 'No Categories',
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: size.height * 0.9,
                                          width: size.width,
                                          //color: Colors.blueAccent,
                                          child: ListView(
                                            //controller: bloc.pageController,
                                            physics: BouncingScrollPhysics(),
                                            children: snapshot.data!.docs.map(
                                                (DocumentSnapshot document) {
                                              return Container(
                                                child: Container(
                                                  child: buildList(
                                                      document, context),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                });
                          },
                          childCount: 1,
                        ),
                      ),
                    ],
                  ));
            }
          },
        ),
      ),
    );
  }

  buildList(DocumentSnapshot res, BuildContext context) {
    CategorieModel categorieModel = CategorieModel.fromSnapShot(res);
    final size = MediaQuery.of(context).size;
    Color? clr;

    switch (categorieModel.priority) {
      case 'Done':
        clr = Color(0xffFFBF73);
        break;
      case 'In Process':
        clr = Color(0xff7DDFFB);
        break;
      case 'Pending':
        clr = Color(0xffF96A95);
        break;
      default:
        clr = Colors.green;
    }

    var item = GestureDetector(
        onTap: () {
          Navigator.push(context, BlocRouter().calendrierPage(categorieModel));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Container(
            height: size.height * 0.1,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage('assets/images/doodle.png'),
                  fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  height: size.height * 0.1,
                  width: size.width * 0.92,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.2),
                      clr,
                    ], stops: [
                      0.0,
                      0.4
                    ]),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        child: FaIcon(
                          FontAwesomeIcons.calendarMinus,
                          color: Colors.brown,
                          size: 40.0,
                        ),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      MyText(
                        label: '${categorieModel.title}'.toUpperCase(),
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));

    return item;
  }
}
