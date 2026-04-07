// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_schedule_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ExamScheduleModel> _$examScheduleModelSerializer =
    _$ExamScheduleModelSerializer();

class _$ExamScheduleModelSerializer
    implements StructuredSerializer<ExamScheduleModel> {
  @override
  final Iterable<Type> types = const [ExamScheduleModel, _$ExamScheduleModel];
  @override
  final String wireName = 'ExamScheduleModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ExamScheduleModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'sections',
      serializers.serialize(
        object.sections,
        specifiedType: const FullType(BuiltMap, const [
          const FullType(String),
          const FullType(BuiltList, const [const FullType(ExModel)]),
        ]),
      ),
    ];

    return result;
  }

  @override
  ExamScheduleModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExamScheduleModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'sections':
          result.sections.replace(
            serializers.deserialize(
              value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(BuiltList, const [const FullType(ExModel)]),
              ]),
            )!,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$ExamScheduleModel extends ExamScheduleModel {
  @override
  final BuiltMap<String, BuiltList<ExModel>> sections;

  factory _$ExamScheduleModel([
    void Function(ExamScheduleModelBuilder)? updates,
  ]) => (ExamScheduleModelBuilder()..update(updates))._build();

  _$ExamScheduleModel._({required this.sections}) : super._();
  @override
  ExamScheduleModel rebuild(void Function(ExamScheduleModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExamScheduleModelBuilder toBuilder() =>
      ExamScheduleModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExamScheduleModel && sections == other.sections;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sections.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ExamScheduleModel',
    )..add('sections', sections)).toString();
  }
}

class ExamScheduleModelBuilder
    implements Builder<ExamScheduleModel, ExamScheduleModelBuilder> {
  _$ExamScheduleModel? _$v;

  MapBuilder<String, BuiltList<ExModel>>? _sections;
  MapBuilder<String, BuiltList<ExModel>> get sections =>
      _$this._sections ??= MapBuilder<String, BuiltList<ExModel>>();
  set sections(MapBuilder<String, BuiltList<ExModel>>? sections) =>
      _$this._sections = sections;

  ExamScheduleModelBuilder();

  ExamScheduleModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sections = $v.sections.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExamScheduleModel other) {
    _$v = other as _$ExamScheduleModel;
  }

  @override
  void update(void Function(ExamScheduleModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExamScheduleModel build() => _build();

  _$ExamScheduleModel _build() {
    _$ExamScheduleModel _$result;
    try {
      _$result = _$v ?? _$ExamScheduleModel._(sections: sections.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sections';
        sections.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ExamScheduleModel',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
