//import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/history.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  State<MyCalendar> createState() => _MyCalendar();
}

class _MyCalendar extends State<MyCalendar> {

  late History history;

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();
  DateTime? rangeStart;
  DateTime? rangeEnd;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;

  @override
  Widget build(BuildContext context) {

    history = Provider.of<History>(context);

    List<Event> getEventsForDay(DateTime day){
      return history.events[day] ?? [];
    }
    
    List<DateTime> daysInRange(DateTime first, DateTime last) {
      final dayCount = last.difference(first).inDays + 1;
      return List.generate(
        dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
      );
    }
    
    List<dynamic> getEventsForRange(DateTime? start, DateTime? end) {
    // Implementation example
      start ??= focusedDay;
      end ??= focusedDay;
      final days = daysInRange(start, end);

      late List<Event> events;
      List<String> selectedEvents = [];

      for (final d in days) {
        events = getEventsForDay(d);
        for (final e in events) {
          selectedEvents.add('${d.month}.${d.day} ${history.foodName[int.parse(e.toString())]}');
        }
      }

      return selectedEvents;
    }

    List<int> getIndexForRange(DateTime? start, DateTime? end) {
    // Implementation example
      start ??= focusedDay;
      end ??= focusedDay;
      final days = daysInRange(start, end);

      late List<Event> events;
      List<int> selectedEvents = [];

      for (final d in days) {
        events = getEventsForDay(d);
        for (final e in events) {
          selectedEvents.add(int.parse(e.toString()));
        }
      }

      return selectedEvents;
    }

    viewDetail(index) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("섭취량 : ${history.foodAmount[index]}인분, 총${history.foodTotal[index]}g"),                  
              ],
            )
          ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreen)),
                child: const Text('닫기'), 
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
              ),
            ]
          );
        }
      );    
    }

    List<Event> getEventsLoader(DateTime day) {
      return history.events[day] ?? [];
    }

    if(history.length == 0) {
      return TableCalendar(
          focusedDay: focusedDay, 
          firstDay: DateTime.now(), 
          lastDay: DateTime.now(),
          locale: 'ko-KR',
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronVisible: true,
            rightChevronVisible: true,
          ),
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            canMarkersOverflow: false,
            markerSize: 10.0,
            markerDecoration: BoxDecoration(
              color: Colors.red.shade200,
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle
            ),
          ),
      );
    }
    return Column(
      children: [
        TableCalendar(
          focusedDay: focusedDay, 
          firstDay: DateTime.parse(history.foodDate.last), 
          lastDay: DateTime.now(),
          locale: 'ko-KR',
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronVisible: true,
            rightChevronVisible: true,
          ),
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            canMarkersOverflow: false,
            markerSize: 10.0,
            markerDecoration: BoxDecoration(
              color: Colors.red.shade200,
              shape: BoxShape.circle,
            ),
            rangeHighlightColor: Colors.lightGreen.shade300,
            rangeStartDecoration: BoxDecoration(
              color: Colors.lightGreen.shade400,
              shape: BoxShape.circle),
            rangeEndDecoration: BoxDecoration(
              color: Colors.lightGreen.shade400,
              shape: BoxShape.circle),
            selectedDecoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle),
          ),
          rangeSelectionMode: rangeSelectionMode,
          rangeStartDay: rangeStart,
          rangeEndDay: rangeEnd,
          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            if(!isSameDay(this.selectedDay, selectedDay)) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
                rangeStart = focusedDay;
                rangeEnd = null;
                rangeSelectionMode = RangeSelectionMode.toggledOff;
              });
            }
          },
          onRangeSelected: (DateTime? start, DateTime? end, DateTime focusedDay) {
            setState(() {
              selectedDay = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              );
              this.focusedDay = focusedDay;
              rangeStart = start;
              rangeEnd = end;
              rangeSelectionMode = RangeSelectionMode.toggledOn;
            });
          },
          selectedDayPredicate: (DateTime day) { 
            return isSameDay(selectedDay, day);
          },
          eventLoader: (day) {
            return getEventsLoader(day);
          }
        ),
        Expanded(
          child: ListView.builder(
            itemCount: getEventsForRange(rangeStart, rangeEnd).length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: 
                    Text('${getEventsForRange(rangeStart, rangeEnd)[index]}'),
                  onTap: () {
                    viewDetail(getIndexForRange(rangeStart, rangeEnd)[index]);
                  },
                ),
              );
            }
          ),
        )
      ],
    );
  }
}