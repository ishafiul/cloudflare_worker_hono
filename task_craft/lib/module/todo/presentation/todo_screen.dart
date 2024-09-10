import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/config/custom_icons_icons.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/bottom_sheet/scrollable_bottom_sheet.dart';
import 'package:task_craft/core/widgets/button/button.dart';
import 'package:task_craft/core/widgets/button/enums.dart';
import 'package:task_craft/core/widgets/input.dart';
import 'package:task_craft/core/widgets/mesure_widget.dart';
import 'package:task_craft/module/todo/cubit/todo_count/todo_count_cubit.dart';
import 'package:task_craft/module/todo/presentation/widgets/date_timeline.dart';
import 'package:task_craft/module/todo/presentation/widgets/task_content.dart';

final DateTimelineController dateController = DateTimelineController();
final _formKey = GlobalKey<FormState>();
GlobalKey<ScaffoldState> homePageScaffoldKey = GlobalKey<ScaffoldState>();

class TodoScreen extends HookWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
    final ValueNotifier<DateTime> selectedMonth =
        ValueNotifier<DateTime>(DateTime.now());
    final ValueNotifier<DateTime> selectedDate =
        ValueNotifier<DateTime>(DateTime.now());

    final useTaskCountCubit = useTextEditingController(
        text: DateFormat("yyyy-MM-dd").format(selectedDate.value));
    useEffect(() {
      return null;
    });
    final ValueNotifier<Size?> dateTimeLineConstraints = useState(null);
    return Scaffold(
      key: homePageScaffoldKey,
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        title: const Text("TODO"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CustomIcons.more),
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: 24.paddingHorizontal(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: selectedMonth,
                        builder: (
                          BuildContext context,
                          DateTime value,
                          Widget? child,
                        ) {
                          return Text(
                            DateFormat('MMM yyyy').format(value),
                            style: context.textTheme.titleLarge,
                          );
                        },
                      ),
                      Row(
                        children: [
                          Button.primary(
                            child: const Text('Today'),
                            onPressed: () async {
                              /*final int initialIndex =
                                  DateTime.now().difference(initialDate).inDays;

                              await controller.scrollToIndex(
                                initialIndex,
                                preferPosition: AutoScrollPosition.middle,
                                duration: const Duration(milliseconds: 100),
                              );
                              selectedDate.value = DateTime.now();
                              selectedIndex.value = initialIndex;*/
                              await dateController
                                  .animateToDate(DateTime.now());
                            },
                          ),
                          Button.primary(
                            child: const Text('Selected Date'),
                            onPressed: () async {
                              /*final int initialIndex =
                                  DateTime.now().difference(initialDate).inDays;

                              await controller.scrollToIndex(
                                initialIndex,
                                preferPosition: AutoScrollPosition.middle,
                                duration: const Duration(milliseconds: 100),
                              );
                              selectedDate.value = DateTime.now();
                              selectedIndex.value = initialIndex;*/
                              dateController.animateToSelection();
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    insetPadding: const EdgeInsets.all(24),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SfDateRangePicker(
                                            backgroundColor:
                                                CColor.backgroundColor,
                                            showNavigationArrow: true,
                                            headerHeight: 56,
                                            headerStyle:
                                                const DateRangePickerHeaderStyle(
                                              backgroundColor:
                                                  CColor.backgroundColor,
                                            ),
                                            onSelectionChanged: (
                                              DateRangePickerSelectionChangedArgs
                                                  dateRangePickerSelectionChangedArgs,
                                            ) async {
                                              context.pop();
                                              await dateController
                                                  .animateToDate(
                                                DateTime.parse(
                                                  dateRangePickerSelectionChangedArgs
                                                      .value
                                                      .toString(),
                                                ),
                                              );
                                            },
                                            selectionShape:
                                                DateRangePickerSelectionShape
                                                    .rectangle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(CustomIcons.calendar),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                8.verticalSpace,
                MeasureSize(
                  onChange: (Size size) {
                    dateTimeLineConstraints.value = size;
                  },
                  child: DateTimeLine(
                    controller: dateController,
                    visibleDate: (date) {
                      if (selectedMonth.value.month != date.month ||
                          selectedMonth.value.year != date.year) {
                        selectedMonth.value = date;
                        context
                            .read<TodoCountCubit>()
                            .getMonthlyTodoCounts(date: date);
                      }
                    },
                    onTapDate: (date) {
                      selectedDate.value = date;
                    },
                  ),
                ),
                if (dateTimeLineConstraints.value != null)
                  ValueListenableBuilder(
                    valueListenable: selectedDate,
                    builder:
                        (BuildContext context, DateTime value, Widget? child) {
                      return TaskContent(
                        extraTopSize: dateTimeLineConstraints.value!,
                        date: value,
                      );
                    },
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 24.h,
            right: 24.w,
            child: SafeArea(
              child: IconButton.filled(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    context: context,
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text("Create Task"),
                      ),
                      body: Padding(
                        padding: 24.paddingAll(),
                        child: ListView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          children: [
                            TextInputField(
                              placeholder: "ex: shafiulislam20@gmail.com",
                              disabled: false,
                              isRequired: true,
                              labelText: "Title",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                if (value.isMail != true) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                            8.verticalSpace,
                            TextInputField(
                              placeholder: "ex: shafiulislam20@gmail.com",
                              disabled: false,
                              maxLines: 10,
                              minLines: 3,
                              labelText: "Description",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                if (value.isMail != true) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                            8.verticalSpace,
                            TextInputField(
                              placeholder: "ex: yyyy-mm-dd",
                              disabled: false,
                              isRequired: true,
                              controller: useTaskCountCubit,
                              keyboardType: TextInputType.datetime,
                              labelText: "Date",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                if (value.isMail != true) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                            8.verticalSpace,
                            TextInputField(
                              placeholder: "ex: hh:mm:ss",
                              disabled: false,
                              isRequired: true,
                              keyboardType: TextInputType.datetime,
                              labelText: "Start Time",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                if (value.isMail != true) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                            8.verticalSpace,
                            TextInputField(
                              placeholder: "ex: hh:mm:ss",
                              disabled: false,
                              keyboardType: TextInputType.datetime,
                              isRequired: true,
                              labelText: "End Time",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email is required';
                                }
                                if (value.isMail != true) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                      bottomNavigationBar: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          color: CColor.backgroundColor,
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: SafeArea(
                                  child: Padding(
                                    padding: 24.paddingHorizontal(),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Button.primary(
                                            fill: ButtonFill.outline,
                                            shape: ButtonShape.rectangular,
                                            buttonSize: ButtonSize.large,
                                            isBlock: true,
                                            onPressed: () {
                                              context.pop();
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                        ),
                                        12.horizontalSpace,
                                        Flexible(
                                          child: Button.primary(
                                            fill: ButtonFill.solid,
                                            shape: ButtonShape.rectangular,
                                            buttonSize: ButtonSize.large,
                                            isBlock: true,
                                            onPressed: () {},
                                            child: const Text("Create"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  CustomIcons.add,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
