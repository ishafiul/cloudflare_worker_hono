import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:task_craft/core/utils/extention.dart';

class TaskTitle extends HookWidget {
  const TaskTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final isChecked = useState(false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Task Title',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Checkbox(
          value: isChecked.value,
          onChanged: (value) {
            isChecked.value = !isChecked.value;
          },
        ),
      ],
    );
  }
}
