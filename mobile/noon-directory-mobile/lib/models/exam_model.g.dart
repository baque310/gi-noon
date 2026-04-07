// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ExamModel> _$examModelSerializer = _$ExamModelSerializer();

class _$ExamModelSerializer implements StructuredSerializer<ExamModel> {
  @override
  final Iterable<Type> types = const [ExamModel, _$ExamModel];
  @override
  final String wireName = 'ExamModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ExamModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'sections',
      serializers.serialize(
        object.sections,
        specifiedType: const FullType(BuiltMap, const [
          const FullType(String),
          const FullType(BuiltList, const [const FullType(ExamDataModel)]),
        ]),
      ),
    ];

    return result;
  }

  @override
  ExamModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExamModelBuilder();

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
                const FullType(BuiltList, const [
                  const FullType(ExamDataModel),
                ]),
              ]),
            )!,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$ExamModel extends ExamModel {
  @override
  final BuiltMap<String, BuiltList<ExamDataModel>> sections;

  factory _$ExamModel([void Function(ExamModelBuilder)? updates]) =>
      (ExamModelBuilder()..update(updates))._build();

  _$ExamModel._({required this.sections}) : super._();
  @override
  ExamModel rebuild(void Function(ExamModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExamModelBuilder toBuilder() => ExamModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExamModel && sections == other.sections;
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
      r'ExamModel',
    )..add('sections', sections)).toString();
  }
}

class ExamModelBuilder implements Builder<ExamModel, ExamModelBuilder> {
  _$ExamModel? _$v;

  MapBuilder<String, BuiltList<ExamDataModel>>? _sections;
  MapBuilder<String, BuiltList<ExamDataModel>> get sections =>
      _$this._sections ??= MapBuilder<String, BuiltList<ExamDataModel>>();
  set sections(MapBuilder<String, BuiltList<ExamDataModel>>? sections) =>
      _$this._sections = sections;

  ExamModelBuilder();

  ExamModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sections = $v.sections.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExamModel other) {
    _$v = other as _$ExamModel;
  }

  @override
  void update(void Function(ExamModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExamModel build() => _build();

  _$ExamModel _build() {
    _$ExamModel _$result;
    try {
      _$result = _$v ?? _$ExamModel._(sections: sections.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sections';
        sections.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ExamModel',
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
