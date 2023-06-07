import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class DateTimeWG extends StatefulWidget {
  const DateTimeWG({super.key});

  @override
  State<DateTimeWG> createState() => _DateTimeWGState();
}

class _DateTimeWGState extends State<DateTimeWG> {
  DateTime _DateTimeOfToDo = new DateTime.now();
  late String dateTimedataOfToDo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                child: Text(dateTimedataOfToDo != null ? "${_DateTimeOfToDo}" : ""),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: DateTime.now().toString(),
                dateMask: 'd MMM, yyyy',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  if (date.weekday == 6 || date.weekday == 7) {
                    return false;
                  }

                  return true;
                },
                onChanged: (val) => setState(() {
                  _DateTimeOfToDo = DateTime.parse(val);
                  dateTimedataOfToDo = val;
                }),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              )
            ],
          ),
        ));
  }
}
