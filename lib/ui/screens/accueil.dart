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
                  child: Stack(
                    children: [
                      Positioned(
                        top: size.height * 0.55,
                        child: FadeInUp(
                          delay: Duration(milliseconds: 400),
                          child: Container(
                            height: size.height * 0.8,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.6,
                        child: FadeInUp(
                          delay: Duration(milliseconds: 300),
                          child: Container(
                            height: size.height * 0.8,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.4,
                              ),
                              FadeInUp(
                                delay: Duration(milliseconds: 600),
                                child: Container(
                                  child: MyText(
                                    label: 'Ilanga',
                                    color: Colors.green,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              FadeInUp(
                                delay: Duration(milliseconds: 900),
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
