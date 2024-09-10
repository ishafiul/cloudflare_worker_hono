// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(alwaysCreate: true)

enum TodoStatus {
  @JsonValue('pending')
  pending('pending'),
  @JsonValue('completed')
  completed('completed'),
  @JsonValue('in-progress')
  inProgress('in-progress'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const TodoStatus(this.json);

  factory TodoStatus.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  String? toJson() => json;
}
