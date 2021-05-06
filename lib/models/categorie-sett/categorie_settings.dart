import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';

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
      break;

    case 'In Process':
      img = Image(
        image: AssetImage('assets/images/inprozess.png'),
        height: 120.0,
        width: 120.0,
      );
      clr = Color(0xff7DDFFB);
      break;

    case 'Pending':
      img = Image(
        image: AssetImage('assets/images/pending.png'),
        height: 120.0,
        width: 120.0,
      );
      clr = Color(0xffF96A95);
      break;
    // etc.
    default:
      img = Image(
        image: AssetImage('assets/images/default.png'),
        height: 120.0,
        width: 120.0,
      );
      clr = Colors.green;
  }

  var item = Padding(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
            top: size.height * 0.16,
            left: size.width * 0.04,
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(
                        context, BlocRouter().seecatPage(categorieModel));
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                  iconSize: 20.0,
                ),
                IconButton(
                  onPressed: () async {
                    await showMyCategorie(context, categorieModel);
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
          ),
        ],
      ),
    ),
  );

  return item;
}

Future showMyCategorie(
    BuildContext context, CategorieModel categorieModel) async {
  print(categorieModel.id);
  String? _priority;
  var items = [
    'Pending',
    'Done',
    'In Process',
  ];
  //final size = MediaQuery.of(context).size;
  final _formKey = GlobalKey<FormState>();
  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height - 80,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Material(
                    color: Colors.white,
                    child: Container(
                      height: 500.0,
                      width: MediaQuery.of(context).size.width * 0.9,
                      // color: Colors.blue,
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: MyTextField(
                                    validator: (value) =>
                                        value!.isEmpty ? 'Please' : null,
                                    labelText: 'Categorie',
                                    onSaved: (newValue) =>
                                        categorieModel.title = newValue,
                                    initialValue: categorieModel.title ?? '',
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: DateTimePicker(
                                    type: DateTimePickerType.date,
                                    dateMask: 'd.MM.yyyy',
                                    initialValue: categorieModel.debut ??
                                        DateFormat.yMMMd('fr')
                                            .format(DateTime.now()),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    dateLabelText: 'Date',
                                    onChanged: (val) => print(val),
                                    validator: (val) => val!.isEmpty
                                        ? 'Please a choose a Date'
                                        : null,
                                    onSaved: (newValue) =>
                                        categorieModel.debut = newValue,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'debut',
                                        labelStyle: TextStyle(fontSize: 18.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: DateTimePicker(
                                    type: DateTimePickerType.date,
                                    dateMask: 'd.MM.yyyy',
                                    initialValue: categorieModel.fin ??
                                        DateFormat.yMMMd('fr')
                                            .format(DateTime.now()),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    dateLabelText: 'Date',
                                    onChanged: (val) => print(val),
                                    validator: (val) => val!.isEmpty
                                        ? 'Please a choose a Date'
                                        : null,
                                    onSaved: (newValue) =>
                                        categorieModel.fin = newValue,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'fin',
                                        labelStyle: TextStyle(fontSize: 18.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: DropdownButtonFormField(
                                    isDense: true,
                                    icon: Icon(Icons.arrow_drop_down_circle),
                                    iconSize: 22.0,
                                    iconEnabledColor:
                                        Theme.of(context).primaryColor,
                                    items: items.map((String priority) {
                                      return DropdownMenuItem(
                                        value: priority,
                                        child: Text(
                                          priority,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0),
                                        ),
                                      );
                                    }).toList(),
                                    style: TextStyle(fontSize: 18.0),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Priority',
                                        labelStyle: TextStyle(fontSize: 18.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        )),
                                    validator: (input) =>
                                        categorieModel.priority == null
                                            ? 'Please select a priority level'
                                            : null,
                                    onChanged: (newValue) => categorieModel
                                        .priority = newValue as String?,
                                    value: categorieModel.priority == null
                                        ? _priority
                                        : categorieModel.priority,
                                  ),
                                ),
                                MyTextButton(
                                  label: 'Edit',
                                  backgroundColor: Colors.amber,
                                  colorText: Colors.white,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      await HomeState()
                                          .updateCategorie(categorieModel)
                                          .then((value) =>
                                              Navigator.pop(context));
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      });
}
