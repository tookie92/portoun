import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie-sett/c_settings.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<BlocHome>(context);
    final _formKey = GlobalKey<FormState>();
    //print(DateFormat('yyyy-MM-dd ').format(datet));
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
                    centerTitle: true,
                    //floating: true,
                    elevation: 0,
                    pinned: true,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: MyText(
                        label: DateFormat.yMMMd('fr').format(DateTime.now()),
                        color: Colors.black,
                      ),
                    ),
                    leading: IconButton(
                        onPressed: () => Navigator.push(
                            context, BlocRouter().indexCalpage()),
                        icon: FaIcon(
                          FontAwesomeIcons.calendarAlt,
                          color: Colors.black,
                        )),
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
                                  title: Text('Add a categorie'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: MyTextField(
                                                    validator: (value) =>
                                                        value!.isEmpty
                                                            ? 'Please'
                                                            : null,
                                                    onSaved: (newValue) => truc
                                                        .categorieModel!
                                                        .title = newValue,
                                                    labelText: 'title',
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    validator: (value) =>
                                                        value!.isEmpty
                                                            ? 'Please fill'
                                                            : null,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      labelText: 'priority',
                                                      labelStyle: TextStyle(
                                                          fontSize: 18.0),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    items: truc.items
                                                        .map((String value) {
                                                      //categorieModel.priority = value;
                                                      return new DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: new Text(
                                                          value,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) => truc
                                                        .categorieModel!
                                                        .priority = value,
                                                    value: truc.items[2],
                                                    onSaved: (newValue) => truc
                                                        .categorieModel!
                                                        .priority = newValue,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    MyTextButton(
                                      label: 'Cancel',
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    MyTextButton(
                                      label: 'Approve',
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
                          icon: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          height: size.height * 0.53,
                          width: size.width,
                          //decoration: BoxDecoration(color: Colors.green),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.01,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 29.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyText(
                                      label: 'Projects  ',
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(
                                      width: 100.0,
                                    ),
                                    TextButton.icon(
                                      icon: FaIcon(
                                        FontAwesomeIcons.chartBar,
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                      onPressed: () => Navigator.push(
                                          context, BlocRouter().chartPage()),
                                      label: MyText(
                                        label: 'see chart',
                                        color: Colors.black.withOpacity(0.3),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
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
                                            height: size.height * 0.3,
                                            width: size.width,
                                            child: Center(
                                              child: MyText(
                                                textAlign: TextAlign.center,
                                                label:
                                                    'no Categories press the + \n in the menu',
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: size.height * 0.3,
                                            width: size.width,
                                            //color: Colors.blueAccent,
                                            child: PageView(
                                              controller: bloc.pageController,
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              children: snapshot.data!.docs.map(
                                                  (DocumentSnapshot document) {
                                                return Container(
                                                  child: showCategorie(
                                                    document,
                                                    context,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Column(
                          children: [
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
                            StreamBuilder<QuerySnapshot>(
                              stream: truc.collectionReference!
                                  .limit(3)
                                  .where(
                                    'priority',
                                    isEqualTo: 'Pending',
                                  )
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
                                        height: size.height * 0.3,
                                        width: size.width,
                                        child: Center(
                                          child: MyText(
                                            textAlign: TextAlign.center,
                                            label: 'no Categories',
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 280.0,
                                        width: size.width,
                                        //color: Colors.blueAccent,
                                        child: ListView(
                                          //  controller: bloc.pageController,
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          children: snapshot.data!.docs
                                              .map((DocumentSnapshot document) {
                                            return Container(
                                                child: showCategorieToday(
                                                    document, context));
                                          }).toList(),
                                        ),
                                      );
                              },
                            ),
                          ],
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

//****Categories****** */
//******************** */

}
