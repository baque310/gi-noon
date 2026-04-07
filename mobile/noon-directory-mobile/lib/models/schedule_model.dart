import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'schedule_model.g.dart';

// Schedule Model
abstract class ScheduleModel
    implements Built<ScheduleModel, ScheduleModelBuilder> {
  String? get id;

  @BuiltValueField(wireName: 'day')
  String? get day;

  @BuiltValueField(wireName: 'timeFrom')
  String? get timeFrom;

  @BuiltValueField(wireName: 'timeTo')
  String? get timeTo;

  // Constructor
  ScheduleModel._();
  factory ScheduleModel([void Function(ScheduleModelBuilder) updates]) =
      _$ScheduleModel;

  // Serializer
  static Serializer<ScheduleModel> get serializer => _$scheduleModelSerializer;
}
