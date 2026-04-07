import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'notification_data_model.g.dart';

abstract class NotificationDataModel
    implements Built<NotificationDataModel, NotificationDataModelBuilder> {
  static Serializer<NotificationDataModel> get serializer =>
      _$notificationDataModelSerializer;

  String? get id;
  String? get type;

  NotificationDataModel._();

  factory NotificationDataModel([
    void Function(NotificationDataModelBuilder)? updates,
  ]) = _$NotificationDataModel;

  String toJson() {
    return jsonEncode(
      serializers.serializeWith(NotificationDataModel.serializer, this),
    );
  }

  factory NotificationDataModel.fromMap(Map<String, dynamic> data) {
    return serializers.deserializeWith(NotificationDataModel.serializer, data)!;
  }

  static NotificationDataModel? fromJson(String json) {
    return serializers.deserializeWith(
      NotificationDataModel.serializer,
      jsonDecode(json),
    );
  }
}
