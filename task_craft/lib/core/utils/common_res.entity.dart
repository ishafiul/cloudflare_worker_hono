import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_res.entity.freezed.dart';

part 'common_res.entity.g.dart';

/// breeze buy common response that come from backend with every http request
@freezed
@JsonSerializable(genericArgumentFactories: true)
class ResponseEntity<T> with _$ResponseEntity<T> {
  /// breeze buy common response that come from backend with every http request
  const factory ResponseEntity({
    required String message,
    required List<String>? errors,
    required int status_code,
    required String status,
    required ResponseLinks links,
    required int count,
    required int total_pages,
    required T data,
  }) = _ResponseEntity<T>;

  /// `fromJson` and `toJson` method for [ResponseEntity]
  factory ResponseEntity.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return _$ResponseEntityFromJson<T>(json, fromJsonT);
  }
}

/// `links` data type for [ResponseEntity]
@freezed
class ResponseLinks with _$ResponseLinks {
  /// `links` data type for [ResponseEntity]
  const factory ResponseLinks({
    required String? next,
    required String? previous,
  }) = _ResponseLinks;

  /// `fromJson` and `toJson` method for [ResponseLinks]
  factory ResponseLinks.fromJson(Map<String, Object?> json) =>
      _$ResponseLinksFromJson(json);
}
