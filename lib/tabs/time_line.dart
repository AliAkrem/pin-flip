import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin_flip/shared/adaptive.dart';
import 'package:pin_flip/tabs/sidebar.dart';
import 'package:pin_flip/utils/colors.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  final _eventController = EventController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // List of calendar events for computer science courses
      final List<CalendarEventData> events = [
        // Sunday (Day 2)
        eventCard(
            title: "TD",
            description: "Algorithms and Data Structures",
            eventId: "event1",
            type: SessionTypes.td,
            startTime: getDateTimeForWeekday(1, 8, 30),
            endTime: getDateTimeForWeekday(1, 9, 30)),

        eventCard(
            type: SessionTypes.course,
            title: "COURS",
            description: "Operating Systems",
            eventId: "event2",
            startTime: getDateTimeForWeekday(1, 11, 0),
            endTime: getDateTimeForWeekday(1, 13, 0)),

        eventCard(
            type: SessionTypes.tp,
            title: "TP",
            description: "Database Management",
            eventId: "event3",
            startTime: getDateTimeForWeekday(1, 14, 0),
            endTime: getDateTimeForWeekday(1, 16, 0)),

        // Monday (Day 3)
        eventCard(
            type: SessionTypes.course,
            title: "COURS",
            description: "Computer Networks",
            eventId: "event4",
            startTime: getDateTimeForWeekday(2, 8, 0),
            endTime: getDateTimeForWeekday(2, 10, 0)),

        eventCard(
            type: SessionTypes.td,
            title: "TD",
            description: "Software Engineering",
            eventId: "event5",
            startTime: getDateTimeForWeekday(2, 13, 0),
            endTime: getDateTimeForWeekday(2, 15, 0)),

        // Tuesday (Day 4)
        eventCard(
            type: SessionTypes.tp,
            title: "TP",
            description: "Web Development",
            eventId: "event6",
            startTime: getDateTimeForWeekday(3, 8, 30),
            endTime: getDateTimeForWeekday(3, 10, 30)),

        eventCard(
            type: SessionTypes.course,
            title: "COURS",
            description: "Artificial Intelligence",
            eventId: "event7",
            startTime: getDateTimeForWeekday(3, 14, 0),
            endTime: getDateTimeForWeekday(3, 16, 0)),

        // Wednesday (Day 5)
        eventCard(
            type: SessionTypes.td,
            title: "TD",
            description: "Data Mining",
            eventId: "event8",
            startTime: getDateTimeForWeekday(4, 10, 0),
            endTime: getDateTimeForWeekday(4, 12, 0)),

        eventCard(
            type: SessionTypes.tp,
            title: "TP",
            description: "Mobile Application Development",
            eventId: "event9",
            startTime: getDateTimeForWeekday(4, 13, 30),
            endTime: getDateTimeForWeekday(4, 15, 30)),

        // Thursday (Day 6)
        eventCard(
            type: SessionTypes.course,
            title: "COURS",
            description: "Computer Security",
            eventId: "event10",
            startTime: getDateTimeForWeekday(5, 9, 0),
            endTime: getDateTimeForWeekday(5, 11, 0)),

        eventCard(
            type: SessionTypes.td,
            title: "TD",
            description: "Machine Learning",
            eventId: "event11",
            startTime: getDateTimeForWeekday(5, 13, 0),
            endTime: getDateTimeForWeekday(5, 15, 0)),

        eventCard(
            type: SessionTypes.tp,
            title: "TP",
            description: "Cloud Computing",
            eventId: "event12",
            startTime: getDateTimeForWeekday(5, 15, 30),
            endTime: getDateTimeForWeekday(5, 17, 30)),
      ];

      _eventController.addAll(events);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return FocusTraversalGroup(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          width: isDesktop
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width + 600,
          child: WeekView(
            minuteSlotSize: MinuteSlotSize.minutes60,
            controller: _eventController,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            startDay: WeekDays.sunday,
            startHour: 7,
            endHour: 24,
            showVerticalLines: true,
            liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
                showTimeBackgroundView: true,
                showTime: true,
                color: PinFlipColors.danger),
            onHeaderTitleTap: null,
            showHalfHours: true,
            hourIndicatorSettings: const HourIndicatorSettings(
              offset: -60,
            ),
            heightPerMinute: 2,
            timeLineBuilder: (date) {
              String formattedTime = DateFormat('HH:mm').format(date);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(formattedTime),
              );
            },
            showLiveTimeLineInAllDays: true,
            timeLineStringBuilder: (date, {secondaryDate}) {
              String formattedTime = DateFormat('HH:mm').format(date);
              return formattedTime;
            },
            onDateTap: null,
            halfHourIndicatorSettings:
                const HourIndicatorSettings(color: Colors.transparent),
            headerStyle: HeaderStyle(
                rightIconConfig: null,
                leftIconConfig: null,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor)),
            pageViewPhysics: const NeverScrollableScrollPhysics(),
            weekDays: const [
              WeekDays.sunday,
              WeekDays.monday,
              WeekDays.tuesday,
              WeekDays.wednesday,
              WeekDays.thursday,
            ],
          ),
        ),
      ),
    );
  }

  CalendarEventData<String> eventCard(
      {required type,
      required title,
      required eventId,
      description,
      color,
      required DateTime startTime,
      required DateTime endTime}) {
    return CalendarEventData(
      title: title,
      description: description,
      titleStyle: Theme.of(context).textTheme.bodySmall,
      descriptionStyle: Theme.of(context).textTheme.bodySmall,
      event: eventId,
      color: type == SessionTypes.td
          ? PinFlipColors.tdColor
          : type == SessionTypes.tp
              ? PinFlipColors.tpColor
              : PinFlipColors.courseColor,
      date: startTime,
      startTime: startTime,
      endTime: endTime,
    );
  }

  DateTime getDateTimeForWeekday(int weekday, int hour, int minute) {
    if (weekday < 1 || weekday > 7) {
      throw ArgumentError(
          "Weekday must be between 1 (Sunday) and 7 (Saturday)");
    }

    // Find the Sunday of the current week
    DateTime sunday =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7));

    // Get the required day by adding (weekday - 1) days to Sunday
    DateTime targetDay = sunday.add(Duration(days: weekday - 1));

    // Set the required time
    return targetDay.copyWith(
        hour: hour, minute: minute, second: 0, millisecond: 0, microsecond: 0);
  }
}

enum SessionTypes { course, tp, td }
