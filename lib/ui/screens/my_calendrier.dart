import 'package:flutter/material.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/ui/widgets/widgets.dart';

class MyCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocCalendar>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<CalendarState>(
        stream: bloc.stream,
        builder: (context, s) {
          final truc = s.data;

          if (truc == null) {
            return Container(
              height: size.height,
              width: size.width,
              child: Center(
                child: MyText(
                  label: 'nothing',
                ),
              ),
            );
          } else if (!s.hasData) {
            return Container(
              height: size.height,
              width: size.width,
              child: Center(
                child: MyText(
                  label: 'nothing br',
                ),
              ),
            );
          } else {
            return Container(
              height: size.height,
              width: size.width,
              child: Center(
                child: MyText(
                  label: 'hey',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
