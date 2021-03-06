import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//****************** */
//****************** */
//****************** */
//**For the list of Categorie in HomePage
//****************** */
//****************** */
//****************** */
showCategorie(DocumentSnapshot res, BuildContext context) {
  CategorieModel categorieModel = CategorieModel.fromSnapShot(res);
  final size = MediaQuery.of(context).size;
  final String? prio;
  // var mark = categorieModel.priority;
  Color? clr;
  Image? img;

  switch (categorieModel.priority) {
    case 'Done':
      img = Image(
        image: AssetImage('assets/images/done.png'),
        height: 120.0,
        width: 120.0,
      );
      clr = Color(0xffFFBF73);
      prio = 'Done';
      break;

    case 'In Process':
      img = Image(
        image: AssetImage('assets/images/defaults.png'),
        height: 120.0,
        width: 120.0,
      );
      clr = Color(0xff7DDFFB);
      prio = 'In Progress';
      break;

    case 'Pending':
      img = Image(
        image: AssetImage('assets/images/pendings.png'),
        height: 120.0,
        width: 120.0,
      );
      clr = Color(0xffF96A95);
      prio = 'Pending';
      break;
    // etc.
    default:
      img = Image(
        image: AssetImage('assets/images/default.png'),
        height: 120.0,
        width: 120.0,
      );
      prio = 'nichts';
      clr = Colors.green;
  }

  var item = GestureDetector(
      onTap: () =>
          Navigator.push(context, BlocRouter().seecatPage(categorieModel)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Container(
          height: size.height * 0.3,
          width: size.width * 0.3,
          decoration: BoxDecoration(
            color: clr,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: clr,
                offset: Offset(5.0, 5.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: size.width * 0.0,
                child: Container(
                  child: Bounce(
                    from: 10.0,
                    child: img,
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.12,
                left: size.width * 0.07,
                child: Container(
                  child: MyText(
                    label: '${categorieModel.title}',
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                  ),
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
                      label: prio,
                      color: clr,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.16,
                left: size.width * 0.04,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await showMyCategorie(context, categorieModel);
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.edit,
                        color: Colors.white,
                      ),
                      iconSize: 20.0,
                    ),
                    IconButton(
                      onPressed: () async {
                        await HomeState().deleteCategorie(categorieModel);
                        // await _showMyUpdate(context, categorieModel);
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.trashAlt,
                        color: Colors.white,
                      ),
                      iconSize: 20.0,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: size.height * 0.04,
                left: size.height * 0.04,
                child: StreamBuilder<QuerySnapshot>(
                  stream: BlocHome().getEvent(categorieModel),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading ...');
                    } else {
                      return MyText(
                        label: (snapshot.data!.docs.length == 0)
                            ? 'No Events'
                            : '${snapshot.data!.docs.length} Events',
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ));

  return item;
}

Future showMyCategorie(
    BuildContext context, CategorieModel categorieModel) async {
  print(categorieModel.id);
  //String? _priority;
  final List<String> _items = [
    'Done',
    'Pending',
    'In Process',
  ];

  final size = MediaQuery.of(context).size;
  final _formKey = GlobalKey<FormState>();

  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Card(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 60,
              padding: EdgeInsets.all(40.0),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.7,
                    width: size.width,
                    //color: Colors.blue,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: FaIcon(FontAwesomeIcons.chevronLeft),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: MyTextField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Please' : null,
                              labelText: 'title',
                              initialValue: categorieModel.title ?? '',
                              onSaved: (newValue) =>
                                  categorieModel.title = newValue,
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'priority',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            items: _items.map((String value) {
                              //categorieModel.priority = value;
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                categorieModel.priority = value,
                            value: categorieModel.priority,
                            //onSaved: (newValue) =>
                            //  categorieModel.priority = newValue,
                          ),
                          MyTextButton(
                            label: 'ok',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await HomeState()
                                    .updateCategorie(categorieModel)
                                    .then((value) => Navigator.pop(context));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
