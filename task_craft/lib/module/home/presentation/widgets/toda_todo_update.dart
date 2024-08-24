import 'package:flutter/material.dart';
import 'package:task_craft/app/app_router.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/button/button.dart';
import 'package:task_craft/core/widgets/button/enums.dart';
import 'package:task_craft/core/widgets/devider/divider.dart';

class TodayTodoUpdate extends StatelessWidget {
  const TodayTodoUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You Have Done 10% Of Your Today's Todo",
                style: context.textTheme.titleSmall,
              ),
              CDivider.base(axis: Axis.horizontal),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Todo: ",
                  ),
                  Text(
                    "10",
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Completed Todo: ",
                  ),
                  Text(
                    "10",
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Todo: ",
                  ),
                  Text(
                    "10",
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Overdue Todo: ",
                  ),
                  Text(
                    "10",
                  ),
                ],
              ),
            ],
          ),
          CDivider.base(axis: Axis.horizontal),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Button.primary(
                  fill: ButtonFill.solid,
                  child: const Text("Your Todo"),
                  onPressed: () {
                    router.go('/todo');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
