import 'package:flutter_test/flutter_test.dart';
import 'package:task_craft/module/todo/presentation/widgets/date_timeline.dart';

void main() {
  late DateTimelineController controller;
  late DateTime referenceDate;

  setUp(() {
    controller = DateTimelineController();
    referenceDate = DateTime(2024);
  });

  test('calculateDateFromOffset should return correct date', () {
    // Assuming each date item is 72 pixels wide (56 + 16 padding)
    const double dateItemWidth = 72.0;

    final DateTime date = referenceDate.add(const Duration(days: 10));
    const double offset = 10 * dateItemWidth;

    final DateTime result = controller.calculateDateFromOffset(offset);
    expect(result, date);
  });
}
