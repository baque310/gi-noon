// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ScheduleModel> _$scheduleModelSerializer =
    _$ScheduleModelSerializer();

class _$ScheduleModelSerializer implements StructuredSerializer<ScheduleModel> {
  @override
  final Iterable<Type> types = const [ScheduleModel, _$ScheduleModel];
  @override
  final String wireName = 'ScheduleModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ScheduleModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.day;
    if (value != null) {
      result
        ..add('day')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.timeFrom;
    if (value != null) {
      result
        ..add('timeFrom')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.timeTo;
    if (value != null) {
      result
        ..add('timeTo')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  ScheduleModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScheduleModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'day':
          result.day =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'timeFrom':
          result.timeFrom =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'timeTo':
          result.timeTo =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$ScheduleModel extends ScheduleModel {
  @override
  final String? id;
  @override
  final String? day;
  @override
  final String? timeFrom;
  @override
  final String? timeTo;

  factory _$ScheduleModel([void Function(ScheduleModelBuilder)? updates]) =>
      (ScheduleModelBuilder()..update(updates))._build();

  _$ScheduleModel._({this.id, this.day, this.timeFrom, this.timeTo})
    : super._();
  @override
  ScheduleModel rebuild(void Function(ScheduleModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleModelBuilder toBuilder() => ScheduleModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleModel &&
        id == other.id &&
        day == other.day &&
        timeFrom == other.timeFrom &&
        timeTo == other.timeTo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, day.hashCode);
    _$hash = $jc(_$hash, timeFrom.hashCode);
    _$hash = $jc(_$hash, timeTo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduleModel')
          ..add('id', id)
          ..add('day', day)
          ..add('timeFrom', timeFrom)
          ..add('timeTo', timeTo))
        .toString();
  }
}

class ScheduleModelBuilder
    implements Builder<ScheduleModel, ScheduleModelBuilder> {
  _$ScheduleModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _day;
  String? get day => _$this._day;
  set day(String? day) => _$this._day = day;

  String? _timeFrom;
  String? get timeFrom => _$this._timeFrom;
  set timeFrom(String? timeFrom) => _$this._timeFrom = timeFrom;

  String? _timeTo;
  String? get timeTo => _$this._timeTo;
  set timeTo(String? timeTo) => _$this._timeTo = timeTo;

  ScheduleModelBuilder();

  ScheduleModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _day = $v.day;
      _timeFrom = $v.timeFrom;
      _timeTo = $v.timeTo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleModel other) {
    _$v = other as _$ScheduleModel;
  }

  @override
  void update(void Function(ScheduleModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleModel build() => _build();

  _$ScheduleModel _build() {
    final _$result =
        _$v ??
        _$ScheduleModel._(id: id, day: day, timeFrom: timeFrom, timeTo: timeTo);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
