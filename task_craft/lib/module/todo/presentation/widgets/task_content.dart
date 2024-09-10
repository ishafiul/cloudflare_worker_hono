import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:task_craft/app/view/app.dart';
import 'package:task_craft/bootstrap.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/bottom_sheet/scrollable_bottom_sheet.dart';
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
              if(state is GetTodosSuccess) {
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
                            '10:00 AM',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          CDivider.text(
                            text: 'to',
                          ),
                          Text(
                            '10:30 AM',
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
                            showBottomSheet(
                              context: context,
                              builder: (context) => ScrollableBottomSheet(
                                child: List.generate(100, (index) => Text("s")),
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
                                  const TaskTitle(),
                                  CDivider.base(axis: Axis.horizontal),
                                  const Text(
                                    'Task Description',
                                  ),
                                  const Text(
                                    'Task Description',
                                  ),
                                  const Text(
                                    'Task Description',
                                  ),
                                  const Text(
                                    'Task Description',
                                  ),
                                  const Text(
                                    'Task Description',
                                  ),
                                  const Text(
                                    'Task Description',
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
