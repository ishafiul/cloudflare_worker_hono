import 'package:go_router/go_router.dart';
import 'package:task_craft/module/todo/presentation/todo_screen.dart';

/// auth router
final todoRouter = [
  GoRoute(
    path: 'todo',
    name: 'todo',
    builder: (context, state) =>  TodoScreen(),
  ),
];
