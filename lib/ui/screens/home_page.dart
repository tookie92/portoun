import 'package:flutter/material.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = BlocProvider.of<BlocHome>(context);
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
                    backgroundColor: Colors.amber,
                    forceElevated: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: MyText(
                        label: 'Ilanga',
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {},
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
                        height: size.height * 0.2,
                        width: size.width,
                        decoration: BoxDecoration(color: Colors.black),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.04,
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
}
