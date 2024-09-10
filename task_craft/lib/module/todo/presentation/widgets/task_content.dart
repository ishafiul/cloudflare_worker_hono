import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:task_craft/app/view/app.dart';
import 'package:task_craft/bootstrap.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/config/custom_icons_icons.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/bottom_sheet/scrollable_bottom_sheet.dart';
import 'package:task_craft/core/widgets/button/button.dart';
import 'package:task_craft/core/widgets/button/enums.dart';
import 'package:task_craft/core/widgets/devider/divider.dart';
import 'package:task_craft/module/todo/cubit/get_todos/get_todos_cubit.dart';
import 'package:task_craft/module/todo/presentation/widgets/title.dart';
import 'package:timelines/timelines.dart';

class TaskContent extends HookWidget {
  const TaskContent({
    super.key,
    required this.extraTopSize,
    required this.date,
  });

  final Size extraTopSize;
  final DateTime date;

  String _formatTaskDate(String taskDate, String startTime, String endTime) {
    try {
      // Parse the iOS date string (taskDate)
      final DateTime parsedDate = DateTime.parse(taskDate);

      // Format the date to 'dd/MM/yyyy'
      final String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

      // Parse the start and end times
      final DateTime parsedStartTime = DateTime.parse(startTime);
      final DateTime parsedEndTime = DateTime.parse(endTime);

      // Format the start and end times to 'hh:mm a'
      final String formattedStartTime =
          DateFormat('h:mm a').format(parsedStartTime);
      final String formattedEndTime =
          DateFormat('h:mm a').format(parsedEndTime);

      // Combine the formatted date and time
      return '$formattedDate, $formattedStartTime - $formattedEndTime';
    } catch (e) {
      return 'Invalid date or time';
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        context.read<GetTodosCubit>().getTodos(taskDate: date);
      },
      [date],
    );
    return SafeArea(
      child: Container(
        padding: 24.paddingHorizontal(),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height -
              (extraTopSize.height + 56 + 56),
          child: BlocBuilder<GetTodosCubit, GetTodosState>(
            builder: (context, state) {
              if (state is GetTodosSuccess) {
                logger.i(state.todos);
                return FixedTimeline.tileBuilder(
                  theme: TimelineThemeData(
                    connectorTheme: ConnectorThemeData(
                      thickness: 2,
                      color: CColor.primary,
                    ),
                    indicatorTheme: IndicatorThemeData(color: CColor.primary),
                  ),
                  clipBehavior: Clip.antiAlias,
                  builder: TimelineTileBuilder.connected(
                    lastConnectorBuilder: (context) {
                      return SolidLineConnector(
                        color: CColor.weak,
                      );
                    },
                    oppositeContentsBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            () {
                              try {
                                return DateFormat('h:mm a').format(
                                  DateTime.parse(
                                    state.todos.data[index].startTime,
                                  ),
                                );
                              } catch (_) {
                                return "--:-- --";
                              }
                            }.call(),
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          CDivider.text(
                            text: 'to',
                          ),
                          Text(
                            () {
                              try {
                                return DateFormat('h:mm a').format(
                                  DateTime.parse(
                                    state.todos.data[index].endTime,
                                  ),
                                );
                              } catch (_) {
                                return "--:-- --";
                              }
                            }.call(),
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    contentsBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => ScrollableBottomSheet(
                                initialChildSize: 0.4,
                                child: [
                                  Padding(
                                    padding: 24.paddingHorizontal(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatTaskDate(
                                            state.todos.data[index].taskDate,
                                            state.todos.data[index].startTime,
                                            state.todos.data[index].endTime,
                                          ),
                                        ),
                                        Text(
                                          state.todos.data[index].title.toSentenceCase,
                                          style:
                                              context.textTheme.headlineMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  8.verticalSpace,
                                  Padding(
                                    padding: 24.paddingHorizontal(),
                                    child: Text(
                                      state.todos.data[index].description,
                                      style: context.textTheme.titleLarge,
                                    ),
                                  ),
                                  8.verticalSpace,
                                  Padding(
                                    padding: 24.paddingHorizontal(),
                                    child: CDivider.base(
                                      axis: Axis.horizontal,
                                    ),
                                  ),
                                  16.verticalSpace,
                                  Padding(
                                    padding: 24.paddingHorizontal(),
                                    child: Row(
                                      children: [
                                        Button.danger(
                                          fill: ButtonFill.outline,
                                          child: Row(
                                            children: [
                                              Icon(CustomIcons.delete_outline),
                                              4.horizontalSpace,
                                              Text("Delete"),
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                        const Spacer(),
                                        Button.primary(
                                          fill: ButtonFill.outline,
                                          child: Row(
                                            children: [
                                              Icon(CustomIcons.copy_outline),
                                              4.horizontalSpace,
                                              Text("Dublicate"),
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                        const Spacer(),
                                        Button.success(
                                          fill: ButtonFill.outline,
                                          child: Row(
                                            children: [
                                              Icon(CustomIcons.check),
                                              4.horizontalSpace,
                                              Text("Complete"),
                                            ],
                                          ),
                                          onPressed: () {},
                                        )
                                      ].withSpaceBetween(width: 4),
                                    ),
                                  ),
                                  12.verticalSpace,
                                  Padding(
                                    padding: 24.paddingHorizontal(),
                                    child: Button.primary(
                                      fill: ButtonFill.solid,
                                      buttonSize: ButtonSize.large,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(CustomIcons.fillin),
                                          12.horizontalSpace,
                                          Text("Edit"),
                                        ],
                                      ),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TaskTitle(
                                    todo: state.todos.data[index],
                                  ),
                                  CDivider.base(axis: Axis.horizontal),
                                  Text(
                                    (() {
                                      try {
                                        final startTime =
                                            state.todos.data[index].startTime;
                                        final endTime =
                                            state.todos.data[index].endTime;

                                        if (startTime.isEmpty ||
                                            endTime.isEmpty) {
                                          return 'No time available';
                                        }

                                        // Parse both startTime and endTime
                                        final parsedEndTime =
                                            DateTime.parse(endTime);
                                        final currentTime = DateTime.now();

                                        // Calculate remaining time in minutes
                                        final difference = parsedEndTime
                                            .difference(currentTime)
                                            .inMinutes;

                                        // If the task is overdue
                                        if (difference <= 0) {
                                          return 'Task is overdue!';
                                        }

                                        // Display the remaining time
                                        return 'You have $difference minutes to complete the task';
                                      } catch (e) {
                                        // Fallback for invalid date strings or errors
                                        return 'Invalid start and end times. Please specify the times for your task.';
                                      }
                                    })(),
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    connectorBuilder: (context, index, type) {
                      return SolidLineConnector(
                        color: index == 0 || index == 3 ? CColor.weak : null,
                      );
                    },
                    indicatorBuilder: (context, index) {
                      return const DotIndicator();
                    },
                    itemCount: state.todos.data.length,
                    indicatorPositionBuilder: (context, index) => 0,
                    nodePositionBuilder: (context, index) => 0.2,
                  ),
                );
              }

              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
