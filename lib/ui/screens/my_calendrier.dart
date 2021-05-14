import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
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
            var iterable = truc.querySnapshot!.docs.toList();
            Map<DateTime, List<NeatCleanCalendarEvent>> jo = {};
            List<NeatCleanCalendarEvent> ok = [];

            for (var element in iterable) {
              CategorieModel categorieModel =
                  CategorieModel.fromSnapShot(element);

              ok.add(NeatCleanCalendarEvent('${categorieModel.title}',
                  startTime: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day, 10, 0),
                  endTime: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day, 12, 0),
                  description: 'A special event',
                  color: Colors.blue[700]));

              var sucre = (element.data()['debut'] == element.get('debut'))
                  ? [
                      NeatCleanCalendarEvent('${categorieModel.title}',
                          startTime: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day, 10, 0),
                          endTime: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day, 12, 0),
                          description: 'A special event',
                          color: Colors.blue[700])
                    ]
                  : ok.toList();

              jo.addAll({
                DateTime.parse('${categorieModel.debut}'): sucre,
              });
            }
            print(ok);
            // Map<DateTime, List<NeatCleanCalendarEvent>> joe = {dateTime!: ok};

            return Calendar(
              startOnMonday: true,
              weekDays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
              events: jo,
              isExpandable: true,
              eventDoneColor: Colors.green,
              selectedColor: Colors.pink,
              todayColor: Colors.blue,
              // dayBuilder: (BuildContext context, DateTime day) {
              //   return new Text("!");
              // },
              eventListBuilder: (BuildContext context,
                  List<NeatCleanCalendarEvent> _selectesdEvents) {
                return SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: new ListView.builder(
                      itemCount: _selectesdEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: MyText(
                            label: '${_selectesdEvents[index].summary}',
                            color: Colors.black,
                          ),
                        );
                      }),
                );
              },
              eventColor: Colors.grey,
              locale: 'de_DE',
              todayButtonText: 'Heute',
              expandableDateFormat: 'EEEE, dd. MMMM yyyy',
              dayOfWeekStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 11),
            );
          }
        },
      ),
    );
  }
}
