import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class Accueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<BlocHome>(context);
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(color: Colors.amber),
        child: StreamBuilder<HomeState>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            final truc = snapshot.data;
            if (truc == null) {
              return Center(
                child: Container(
                  child: MyText(label: 'es ladt'),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Container(
                  child: MyText(label: 'es kommt nichts'),
                ),
              );
            } else {
              return Center(
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.45,
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 1000),
                        child: MyText(
                          label: 'Ilanga',
                          fontSize: 45.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 1500),
                        child: MyTextButton(
                          label: 'enter',
                          onPressed: () {
                            Navigator.pushReplacement(
                                context, BlocRouter().homePage());
                          },
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                        ),
                      ),
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
