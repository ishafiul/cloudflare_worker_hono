import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_craft/core/widgets/button/button.dart';
import 'package:task_craft/core/widgets/button/enums.dart';

/// Represents a range of date and time, specified by [startTime] and [endTime].
class DateTimeRange {
  /// The start date of the range.
  final DateTime startTime;

  /// The end date of the range.
  final DateTime endTime;

  /// Represents a range of date and time, specified by [startTime] and [endTime].
  DateTimeRange({required this.startTime, required this.endTime});
}

/// Displays a dialog for selecting a [DateTimeRange].
///
/// The dialog provides options to pick start and end dates along with times.
/// Returns a [Future] containing the selected [DateTimeRange], or null if canceled.
Future<DateTimeRange?> showDateTimeRangePicker({
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) async {
  return await showDialog<DateTimeRange>(
    context: context,
    builder: (context) {
      return const DateTimeRangePicker();
    },
  );
}

/// StatefulWidget for the DateTimeRangePicker dialog.
class DateTimeRangePicker extends StatefulWidget {
  /// StatefulWidget for the DateTimeRangePicker dialog.
  const DateTimeRangePicker({super.key});

  @override
  State<DateTimeRangePicker> createState() => _DateTimeRangePickerState();
}

/// State class for DateTimeRangePicker.
class _DateTimeRangePickerState extends State<DateTimeRangePicker>
    with SingleTickerProviderStateMixin {
  DateTime startDate = DateTime.now();
  DateTime? endDate = DateTime.now().add(const Duration(hours: 4));
  Duration initialTime = Duration.zero;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12).r,
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(20).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0).r,
                child: Text(
                  'Select Pickup & Delivery Time',
                  style: TextStyle(
                    color: const Color(0xFF1F2024),
                    fontSize: 18.r,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0).h,
                child: Center(
                  child: TabBar(
                    onTap: (value) {
                      selectedIndex = value;
                      setState(() {});
                    },
                    // tabAlignment: TabAlignment.center,
                    tabs: [
                      Column(
                        children: [
                          Button.primary(
                            buttonSize: ButtonSize.small,
                            fill: ButtonFill.none,
                            child: Text(
                              'Start',
                              style: TextStyle(
                                color: const Color(0xFF1F2024),
                                fontSize: 16.r,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('d MMM,').add_jm().format(startDate),
                            style: TextStyle(
                              color: const Color(0xFF1F2024),
                              fontSize: 14.r,
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Button.primary(
                            buttonSize: ButtonSize.small,
                            fill: ButtonFill.none,
                            child: Text(
                              'End',
                              style: TextStyle(
                                color: const Color(0xFF1F2024),
                                fontSize: 16.r,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            endDate != null
                                ? DateFormat('d MMM,').add_jm().format(endDate!)
                                : '-',
                            style: TextStyle(
                              color: const Color(0xFF1F2024),
                              fontSize: 14.r,
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CalendarDatePicker(
                initialDate: startDate,
                firstDate: selectedIndex == 0 ? DateTime.now() : startDate,
                currentDate: selectedIndex == 0 ? endDate : startDate,
                lastDate: DateTime.now().add(const Duration(days: 3350)),
                onDateChanged: (value) {
                  if (selectedIndex == 0) {
                    startDate = value;
                  } else {
                    endDate = value;
                  }
                  setState(() {});
                },
              ),
              CupertinoTimerPicker(
                initialTimerDuration: initialTime,
                onTimerDurationChanged: (value) {
                  if (selectedIndex == 0) {
                    startDate = DateTime(
                      startDate.year,
                      startDate.month,
                      startDate.day,
                      value.inHours,
                      value.inMinutes.remainder(60).abs(),
                    );
                    setState(() {});
                  } else {
                    endDate ??= DateTime.now();
                    endDate = DateTime(
                      endDate!.year,
                      endDate!.month,
                      endDate!.day,
                      value.inHours,
                      value.inMinutes.remainder(60).abs(),
                    );
                    setState(() {});
                  }
                },
                minuteInterval: 15,
                mode: CupertinoTimerPickerMode.hm,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button.primary(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    buttonSize: ButtonSize.small,
                    fill: ButtonFill.outline,
                    child: const Text("Cancel"),
                  ),
                  Button.primary(
                    onPressed: () {
                      Navigator.of(context).pop(
                        DateTimeRange(
                          startTime: startDate,
                          endTime: endDate ?? startDate,
                        ),
                      );
                    },
                    buttonSize: ButtonSize.small,
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
