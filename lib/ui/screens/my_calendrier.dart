import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:portoun/blocs/blocs.dart';
import 'package:portoun/models/categorie_model.dart';
import 'package:portoun/ui/widgets/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocCalendar>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: size.height,
        width: size.width,
        child: StreamBuilder<CalendarState>(
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
              List<Meeting>? collection = [];

              for (var element in iterable) {
                CategorieModel? categorieModel =
                    CategorieModel.fromSnapShot(element);
                collection.add(
                  Meeting(
                    eventName: '${categorieModel.title}',
                    isAllDay: false,
                    from: DateTime.parse('${categorieModel.debut}'),
                    to: DateTime.parse('${categorieModel.fin}'),
                    background: Colors.amber,
                    resourceId: '0001',
                  ),
                );
              }

              return SfCalendar(
                view: CalendarView.month,
                allowedViews: [
                  CalendarView.timelineDay,
                  CalendarView.timelineWeek,
                  CalendarView.timelineWorkWeek,
                  CalendarView.timelineMonth,
                  CalendarView.month
                ],
                initialDisplayDate: DateTime.now(),
                dataSource: _getCalendarDataSource(collection),
                monthViewSettings:
                    MonthViewSettings(showAgenda: true, agendaItemHeight: 70),
                allowViewNavigation: true,
                appointmentTimeTextFormat: 'hh:mm',
                appointmentTextStyle: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700),
              );
            }
          },
        ),
      ),
    );
  }
}

MeetingDataSource _getCalendarDataSource([List<Meeting>? collection]) {
  List<Meeting>? meetings = collection ?? <Meeting>[];
  List<CalendarResource> resourceColl = <CalendarResource>[];
  resourceColl.add(CalendarResource(
    displayName: 'John',
    id: '0001',
    color: Colors.red,
  ));
  return MeetingDataSource(meetings, resourceColl);
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(
      List<Meeting>? source, List<CalendarResource>? resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  List<Object> getResourceIds(int index) {
    return [appointments![index].resourceId];
  }
}

class Meeting {
  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.resourceId});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String? resourceId;
}
