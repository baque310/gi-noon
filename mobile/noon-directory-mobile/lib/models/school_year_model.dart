import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'school_year_model.g.dart';

abstract class SchoolYear implements Built<SchoolYear, SchoolYearBuilder> {
  String? get id;

  int? get from;

  int? get to;

  SchoolYear._();
  factory SchoolYear([void Function(SchoolYearBuilder) updates]) = _$SchoolYear;

  static Serializer<SchoolYear> get serializer => _$schoolYearSerializer;
}
