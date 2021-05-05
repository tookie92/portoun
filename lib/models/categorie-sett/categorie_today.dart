import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';

showCategorieToday(DocumentSnapshot res, BuildContext context) {
  CategorieModel categorieModel = CategorieModel.fromSnapShot(res);
  final size = MediaQuery.of(context).size;
  Color? clr;
  Image? img;

  switch (categorieModel.priority) {
    case 'Done':
      img = Image(
        image: AssetImage('assets/images/Succes.png'),
        height: 130.0,
        width: 130.0,
      );
      clr = Color(0xffFFBF73);
      break;

    case 'In Process':
      img = Image(
        image: AssetImage('assets/images/inprozesss.png'),
        height: 130.0,
        width: 130.0,
      );
      clr = Color(0xff7DDFFB);
      break;

    case 'Pending':
      img = Image(
        image: AssetImage('assets/images/pendings.png'),
        height: 130.0,
        width: 130.0,
      );
      clr = Color(0xffF96A95);
      break;
    // etc.
    default:
      img = Image(
        image: AssetImage('assets/images/defaults.png'),
        height: 130.0,
        width: 130.0,
      );
      clr = Colors.green;
  }

  var item = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
    child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          color: clr,
          boxShadow: [
            BoxShadow(
                color: Colors.grey, offset: Offset(1.0, 2.0), blurRadius: 4.0)
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            bottomLeft: Radius.circular(4.0),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 10.0,
              child: Container(
                height: 100.0,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 0.001,
              bottom: 0.12,
              child: Container(
                child: Bounce(
                  from: 5.0,
                  child: img,
                ),
              ),
            ),
            Positioned(
              top: 20.0,
              left: 120.0,
              child: Container(
                child: MyText(
                  label: 'Title: ${categorieModel.title}',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              left: 120.0,
              child: Container(
                child: MyText(
                  label: categorieModel.debut,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        )),
  );

  return item;
}
