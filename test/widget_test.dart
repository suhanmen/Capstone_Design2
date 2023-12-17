import 'package:flutter/material.dart';

class Event {
  late String title;

  Event(this.title);

  @override
  String toString() => title;
}

void main() {

  List<String> name = ['apple', 'banana', 'orenge', 'mango'];

  List<DateTime> date = [DateTime.parse('2023-11-01'), DateTime.parse('2023-11-02'), DateTime.parse('2023-11-03'), DateTime.parse('2023-11-01')];

  Map<DateTime, dynamic> events = {};

  for(int i=0; i<name.length; i++) {
      if (events[DateTime.parse(date[i].toString())] == null) {
        events.addAll({        
          DateTime.parse(date[i].toString()) : [Event(name[i])]
        });
     } else {
        events[DateTime.parse(date[i].toString())]?.add(Event(name[i]));
     }
    }

  debugPrint(events.toString());
}
