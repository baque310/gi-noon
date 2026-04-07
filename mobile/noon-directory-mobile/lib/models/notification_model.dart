import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/notification_data_model.dart';
import 'package:noon/models/serializers.dart';

part 'notification_model.g.dart';

abstract class NotificationModel
    implements Built<NotificationModel, NotificationModelBuilder> {
  static Serializer<NotificationModel> get serializer =>
      _$notificationModelSerializer;

  String get id;

  String? get title;

  String get isSeen;

  String? get isAlert;

  String? get body;

  String? get imageUrl;

  String get updatedAt;

  NotificationDataModel? get data;

  bool get seenStatues => isSeen.toLowerCase() == "true";

  bool get alertStatues => isAlert?.toLowerCase() == "true";

  NotificationModel._();

  factory NotificationModel([
    void Function(NotificationModelBuilder)? updates,
  ]) = _$NotificationModel;

  String toJson() {
    return jsonEncode(
      serializers.serializeWith(NotificationModel.serializer, this),
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return serializers.deserializeWith(NotificationModel.serializer, data)!;
  }

  static NotificationModel? fromJson(String json) {
    return serializers.deserializeWith(
      NotificationModel.serializer,
      jsonDecode(json),
    );
  }
}
