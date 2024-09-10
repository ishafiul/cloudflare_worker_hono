import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:task_craft/api/export.dart';
import 'package:task_craft/app/view/app.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/module/todo/cubit/get_todos/get_todos_cubit.dart';
import 'package:task_craft/module/todo/cubit/update_todo/update_todo_cubit.dart';

class TaskTitle extends HookWidget {
  const TaskTitle({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final isChecked = useState(false);

    useEffect(
      () {
        isChecked.value = todo.status == TodoStatus.completed;
        return null;
      },
      [todo],
    );
    return BlocListener<UpdateTodoCubit, UpdateTodoState>(
      listener: (context, state) {
        if (state is UpdateTodoSuccess) {
          context.read<GetTodosCubit>().updateTodoInList(todo: state.todo);

        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            todo.title.toSentenceCase,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: isChecked.value ? Colors.green : null,
            ),
          ),
          Checkbox(
            value: isChecked.value,
            onChanged: (value) {
              isChecked.value = value ?? false;
              final updatedTodo = todo.copyWith(
                status:
                    isChecked.value ? TodoStatus.completed : TodoStatus.pending,
              );
              context.read<UpdateTodoCubit>().updateTodo(
                    todo: updatedTodo,
                  );
            },
          ),
        ],
      ),
    );
  }
}
