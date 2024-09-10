import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:task_craft/api/models/todos_count_entity.dart';
import 'package:task_craft/api/rest_client.dart';
import 'package:task_craft/core/config/env/env.dart';
import 'package:task_craft/core/utils/http_base_interceptor.dart';

part 'todo_count_state.dart';

class TodoCountCubit extends Cubit<TodoCountState> {
  TodoCountCubit() : super(TodoCountInitial());

  Future<void> getMonthlyTodoCounts({required DateTime date}) async {
    final month = date.month;
    final year = date.year;
    final dio = Dio();
    dio.interceptors.add(BaseInterceptor());
    final restClient = RestClient(dio, baseUrl: EnvProd.host);
    final res = await restClient.todoAnalysis.getTodoAnalysisMonthTodoCount(
      year: year.toString(),
      month: month.toString(),
    );

    emit(TodoCountSuccess(res));
  }

  int? getTodoCount({required DateTime date}) {
    if (state is! TodoCountSuccess) {
      return null;
    }
    final formatedDate = DateFormat('yyyy-MM-dd').format(date);

    final counts = (state as TodoCountSuccess).counts;

    final count = counts.data
        .where((element) => element.taskDate == formatedDate)
        .first
        .count;
    if (count < 0) {
      return null;
    } else {
      return count;
    }
  }
}
