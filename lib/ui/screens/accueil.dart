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
        decoration: BoxDecoration(color: Colors.white),
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
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      Container(
                        height: size.height,
                        width: size.width,
                      ),
                      Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.4,
                              ),
                              Container(
                                child: Image(
                                  image: AssetImage('assets/images/ilanga.gif'),
                                  height: 200.0,
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              FadeInUp(
                                delay: Duration(milliseconds: 1700),
                                child: Container(
                                  child: MyTextButton(
                                    label: 'Start',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.amber,
                                    onPressed: () => Navigator.pushReplacement(
                                        context, BlocRouter().homePage()),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
