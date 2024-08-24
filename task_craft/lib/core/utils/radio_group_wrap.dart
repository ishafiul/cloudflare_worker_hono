import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/utils/extention.dart';

/// A widget that represents a group of radio buttons arranged in a wrap layout.
class RadioGroupWrap<T> extends HookWidget {
  /// A widget that represents a group of radio buttons arranged in a wrap layout.
  const RadioGroupWrap({
    super.key,
    required this.values,
    this.onChanged,
    this.selectedValue,
  });

  /// The list of values for the radio buttons.
  final List<T> values;

  /// Callback function triggered when the selected value changes.
  final void Function(T? value)? onChanged;

  /// The initially selected value.
  final T? selectedValue;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<T?> active = useState(selectedValue);

    /// Converts an enum value to a readable string format.
    String enumToReadableString(T value) {
      final String str = value.toString();
      return str
          .substring(str.indexOf('.') + 1)
          .replaceAll('_', ' ')
          .toCapitalize;
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: List.generate(
        values.length,
        (index) => InkWell(
          onTap: () {
            if (active.value != values[index]) {
              active.value = values[index];
              onChanged?.call(values[index]);
            }
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: 152.w),
            child: Row(
              children: [
                Theme(
                  data: ThemeData(
                    radioTheme: RadioThemeData(
                      fillColor: MaterialStateProperty.resolveWith(
                        (states) => active.value == values[index]
                            ? CColor.primary
                            : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                  child: Radio<T>(
                    value: values[index],
                    groupValue: active.value,
                    onChanged: (value) {
                      active.value = value;
                      onChanged?.call(value);
                    },
                  ),
                ),
                Text(
                  enumToReadableString(values[index]),
                  style: TextStyle(
                    color: active.value == values[index]
                        ? const Color(0xFF151515)
                        : const Color(0xFFCCCCCC),
                    fontSize: 12.r,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.24.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
