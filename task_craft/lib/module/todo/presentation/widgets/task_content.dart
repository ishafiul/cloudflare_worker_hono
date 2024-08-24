import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/bottom_sheet/scrollable_bottom_sheet.dart';
import 'package:task_craft/core/widgets/devider/divider.dart';
import 'package:task_craft/module/todo/presentation/widgets/title.dart';
import 'package:timelines/timelines.dart';

class TaskContent extends HookWidget {
  const TaskContent({
    super.key,
    required this.extraTopSize,
    required this.scaafoldContext,
  });

  final Size extraTopSize;

  final BuildContext scaafoldContext;

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3);
    final ValueNotifier<Size?> tabBarSize = useState(null);
    return SafeArea(
      child: Container(
        padding: 24.paddingHorizontal(),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height -
                  (extraTopSize.height + 56 + 56),
              child: ListView(
                children: [
                  FixedTimeline.tileBuilder(
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
                                  child:
                                      List.generate(100, (index) => Text("s")),
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
                      itemCount: 3,
                      indicatorPositionBuilder: (context, index) => 0,
                      nodePositionBuilder: (context, index) => 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
