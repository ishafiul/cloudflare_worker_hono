import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_craft/core/config/get_it.dart';
import 'package:task_craft/core/utils/cache_state.dart';

/// custom extension that will work with [BuildContext]
extension XBuildContext on BuildContext {
  /// get theme colorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// get textTheme of the project
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// get elevatedButtonTheme of the project
  ElevatedButtonThemeData get elevatedButtonTheme =>
      Theme.of(this).elevatedButtonTheme;

  /// get textButtonTheme of the project
  TextButtonThemeData get textButtonTheme => Theme.of(this).textButtonTheme;

  /// get outlineButtonTheme of the project
  OutlinedButtonThemeData get outlineButtonTheme =>
      Theme.of(this).outlinedButtonTheme;

  /// get filledButtonTheme of the project
  FilledButtonThemeData get filledButtonTheme =>
      Theme.of(this).filledButtonTheme;

  /// get inputDecorationTheme of the project
  InputDecorationTheme get inputDecorationTheme =>
      Theme.of(this).inputDecorationTheme;

  /// get cardTheme of the project
  ShapeBorder? get cardTheme => Theme.of(this).cardTheme.shape;
}

/// extensions for `List<Widget>`
extension ListSpaceBetweenExtension on List<Widget> {
  ///  this extension will add [SizedBox] for spacing between all widgets of a list.
  List<Widget> withSpaceBetween({double? width, double? height}) => [
        for (int i = 0; i < length; i++) ...[
          if (i > 0) SizedBox(width: width, height: height),
          this[i],
        ],
      ];
}

/// this extension hold some usefully string manipulation technique xD
extension StringExtension on String {
  /// this method will Capitalize first letter of a [String]
  String get toCapitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  /// this method will remove all `_` from the [String] and return a readable text.
  String get toSentenceCase {
    return replaceAll('_', ' ').replaceAllMapped(RegExp(r"\w\S*"),
        (Match match) {
      return match[0]![0].toUpperCase() + match[0]!.substring(1).toLowerCase();
    });
  }

  /// Checks whether the `String` is a valid `DateTime`:
  ///
  /// ### Valid formats
  ///
  /// * dd/mm/yyyy
  /// * dd-mm-yyyyy
  /// * dd.mm.yyyy
  /// * yyyy-mm-dd
  /// * yyyy-mm-dd hrs
  /// * 20120227 13:27:00
  /// * 20120227T132700
  /// * 20120227
  /// * +20120227
  /// * 2012-02-27T14Z
  /// * 2012-02-27T14+00:00
  /// * -123450101 00:00:00 Z": in the year -12345
  /// * 2002-02-27T14:00:00-0500": Same as "2002-02-27T19:00:00Z
  bool get isDate {
    final regex = RegExp(
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$',
    );
    if (regex.hasMatch(this)) {
      return true;
    }
    try {
      DateTime.parse(this);
      return true;
    } on FormatException {
      return false;
    }
  }

  /// Checks whether the `String` is a valid mail.
  /// ### Example
  /// ```dart
  /// String foo = 'esentis@esentis.com';
  /// bool isMail = foo.isMail; // returns true
  /// ```
  bool get isMail {
    final regex = RegExp(r"(^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$)");
    return regex.hasMatch(this);
  }

  /// Checks whether the `String` is a valid URL.
  /// ### Example 1
  /// ```dart
  /// String foo = 'foo.1com';
  /// bool isUrl = foo.isUrl; // returns false
  /// ```
  /// ### Example 2
  /// ```dart
  /// String foo = 'google.com';
  /// bool isUrl = foo.isUrl; // returns true
  /// ```
  bool get isUrl {
    final regex = RegExp(
      r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
    );
    return regex.hasMatch(this);
  }

  /// Checks whether the `String` is a valid Bangladeshi phone number.
  bool get isBdPhoneNumber {
    final regex = RegExp(
      r'(^([+]{1}[8]{2}|0088)?(01){1}[3-9]{1}\d{8})$',
    );
    return regex.hasMatch(this);
  }

  /// Returns the `String` to slug case.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'sLuG Case';
  /// String fooSlug = foo.toSlug; // returns 'sLuG_Case'
  /// ```
  String? get toSlug {
    final words = trim().split(RegExp(r'(\s+)'));
    var slugWord = '';

    if (length == 1) {
      return this;
    }
    for (var i = 0; i <= words.length - 1; i++) {
      if (i == words.length - 1) {
        slugWord += words[i];
      } else {
        slugWord += '${words[i]}_';
      }
    }
    return slugWord;
  }

  /// Returns the `String` to snake_case.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'SNAKE CASE';
  /// String fooSNake = foo.toSnakeCase; // returns 'snake_case'
  /// ```
  String? get toSnakeCase {
    final words = toLowerCase().trim().split(RegExp(r'(\s+)'));
    var snakeWord = '';

    if (length == 1) {
      return this;
    }
    for (var i = 0; i <= words.length - 1; i++) {
      if (i == words.length - 1) {
        snakeWord += words[i];
      } else {
        snakeWord += '${words[i]}_';
      }
    }
    return snakeWord;
  }

  /// Returns the `String` in camelcase.
  /// ### Example
  /// ```dart
  /// String foo = 'Find max of array';
  /// String camelCase = foo.toCamelCase; // returns 'findMaxOfArray'
  /// ```
  String? get toCamelCase {
    final words = trim().split(RegExp(r'(\s+)'));
    final result = StringBuffer(words[0].toLowerCase());

    for (var i = 1; i < words.length; i++) {
      result.write(words[i].substring(0, 1).toUpperCase());
      result.write(words[i].substring(1).toLowerCase());
    }
    return result.toString();
  }

  /// Returns the `String` title cased.
  ///
  /// ```dart
  /// String foo = 'Hello dear friend how you doing ?';
  /// Sting titleCased = foo.toTitleCase; // returns 'Hello Dear Friend How You Doing'.
  /// ```
  String? get toTitleCase {
    final words = trim().toLowerCase().split(' ');
    for (var i = 0; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
    }

    return words.join(' ');
  }

  /// Strips all HTML code from `String`.
  ///
  /// ### Example
  /// ```dart
  /// String html = '<script>Hacky hacky.</script> <p>Here is some text. <span class="bold">This is bold. </span></p>';
  /// String stripped = foo.stripHtml; // returns 'Hacky hacky. Here is some text. This is bold.';
  /// ```
  String? get stripHtml {
    // ignore: unnecessary_raw_strings
    final regex = RegExp(r'<[^>]*>');
    return replaceAll(regex, '');
  }
}

/// Converts a [num] into an [EdgeInsets]
extension PaddingNum on num {
  /// Creates insets where all the offsets are `value`.
  EdgeInsets paddingAll() => EdgeInsets.all(toDouble().r);

  /// Creates insets with symmetric horizontal offsets.
  EdgeInsets paddingHorizontal() =>
      EdgeInsets.symmetric(horizontal: toDouble().w);

  /// Creates insets with symmetric vertical offsets.
  EdgeInsets paddingVertical() => EdgeInsets.symmetric(vertical: toDouble().h);

  /// Creates insets with only the top value.
  EdgeInsets paddingTop() => EdgeInsets.only(top: toDouble().h);

  /// Creates insets with only the left value.
  EdgeInsets paddingLeft() => EdgeInsets.only(left: toDouble().w);

  /// Creates insets with only the right value.
  EdgeInsets paddingRight() => EdgeInsets.only(right: toDouble().w);

  /// Creates insets with only the bottom value.
  EdgeInsets paddingBottom() => EdgeInsets.only(bottom: toDouble().h);
}

/// this extension work with color
extension HexColor on Color {
  /// this method will return [Color] from a hex color value
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// this method will return a hex color string from [Color]
  String toHex({bool leadingHashSign = true}) {
    final string = '${leadingHashSign ? '#' : ''}'
        '${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
    return '#${string.substring(3)}';
  }
}

/// Extensions for working with iterable collections.
extension ExtendedIterable<E> on List<E> {
  /// Like [Iterable<T>.map], but the callback function includes the index as the second argument.
  Iterable<T> mapIndexed<T>(T Function(E element, int index) callback) {
    var index = 0;
    return map((element) => callback(element, index++));
  }

  /// Executes a provided function for each element in the list, passing both the element and its index.
  void forEachIndexed(void Function(E element, int index) callback) {
    var index = 0;
    forEach((element) => callback(element, index++));
  }
}

/// Extensions for state caching with an [Emitter].
extension EmitterStateCaching<S> on Emitter<S> {
  /// Attempts to retrieve and apply a cached state of type [State] using [BlocStateCache].
  Future<void> tryFromCache<State extends S>() async {
    final stateCache = getIt<BlocStateCache>();
    final cachedState = stateCache.retrieve<State>();
    if (cachedState != null) {
      this(cachedState);
    }
  }

  /// Applies the provided [state] and stores it in the cache using [BlocStateCache].
  void andCache<State extends S>(State state) {
    this(state);
    final stateCache = getIt<BlocStateCache>();
    stateCache.store(state);
  }
}

/// Extension for converting an image path to base64.
extension ImagePathToBase64 on String {
  /// Converts the image at the given path to a base64-encoded string.
  String get toBase64 => base64Encode(File(this).readAsBytesSync());
}

extension FigmaDimention on double {
  double toFigmaHeight(double fontSize) {
    return this / fontSize;
  }

  double fromPersentagetoFigmaWidth(double fontSize) {
    final percentAsDecimal = this / 100;
    return percentAsDecimal * fontSize;
  }
}
