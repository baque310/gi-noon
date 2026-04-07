// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LessonModel> _$lessonModelSerializer = _$LessonModelSerializer();

class _$LessonModelSerializer implements StructuredSerializer<LessonModel> {
  @override
  final Iterable<Type> types = const [LessonModel, _$LessonModel];
  @override
  final String wireName = 'LessonModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    LessonModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      ),
      'content',
      serializers.serialize(
        object.content,
        specifiedType: const FullType(String),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      ),
      'teacherSubjectId',
      serializers.serialize(
        object.teacherSubjectId,
        specifiedType: const FullType(String),
      ),
      'schoolYearId',
      serializers.serialize(
        object.schoolYearId,
        specifiedType: const FullType(String),
      ),
      'schoolId',
      serializers.serialize(
        object.schoolId,
        specifiedType: const FullType(String),
      ),
      'teacherSubject',
      serializers.serialize(
        object.teacherSubject,
        specifiedType: const FullType(TeacherSubject),
      ),
      'Section',
      serializers.serialize(
        object.section,
        specifiedType: const FullType(Section),
      ),
      'SchoolYear',
      serializers.serialize(
        object.schoolYear,
        specifiedType: const FullType(SchoolYear),
      ),
      'LessonAttachment',
      serializers.serialize(
        object.lessonAttachment,
        specifiedType: const FullType(BuiltList, const [
          const FullType(LessonAttachmentModel),
        ]),
      ),
    ];
    Object? value;
    value = object.sectionId;
    if (value != null) {
      result
        ..add('sectionId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  LessonModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LessonModelBuilder();

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
                  )!
                  as String;
          break;
        case 'title':
          result.title =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'content':
          result.content =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'teacherSubjectId':
          result.teacherSubjectId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'sectionId':
          result.sectionId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'schoolYearId':
          result.schoolYearId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'schoolId':
          result.schoolId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'teacherSubject':
          result.teacherSubject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(TeacherSubject),
                )!
                as TeacherSubject,
          );
          break;
        case 'Section':
          result.section.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(Section),
                )!
                as Section,
          );
          break;
        case 'SchoolYear':
          result.schoolYear.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(SchoolYear),
                )!
                as SchoolYear,
          );
          break;
        case 'LessonAttachment':
          result.lessonAttachment.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(LessonAttachmentModel),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$LessonModel extends LessonModel {
  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String teacherSubjectId;
  @override
  final String? sectionId;
  @override
  final String schoolYearId;
  @override
  final String schoolId;
  @override
  final TeacherSubject teacherSubject;
  @override
  final Section section;
  @override
  final SchoolYear schoolYear;
  @override
  final BuiltList<LessonAttachmentModel> lessonAttachment;

  factory _$LessonModel([void Function(LessonModelBuilder)? updates]) =>
      (LessonModelBuilder()..update(updates))._build();

  _$LessonModel._({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.teacherSubjectId,
    this.sectionId,
    required this.schoolYearId,
    required this.schoolId,
    required this.teacherSubject,
    required this.section,
    required this.schoolYear,
    required this.lessonAttachment,
  }) : super._();
  @override
  LessonModel rebuild(void Function(LessonModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LessonModelBuilder toBuilder() => LessonModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LessonModel &&
        id == other.id &&
        title == other.title &&
        content == other.content &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        teacherSubjectId == other.teacherSubjectId &&
        sectionId == other.sectionId &&
        schoolYearId == other.schoolYearId &&
        schoolId == other.schoolId &&
        teacherSubject == other.teacherSubject &&
        section == other.section &&
        schoolYear == other.schoolYear &&
        lessonAttachment == other.lessonAttachment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, teacherSubjectId.hashCode);
    _$hash = $jc(_$hash, sectionId.hashCode);
    _$hash = $jc(_$hash, schoolYearId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, teacherSubject.hashCode);
    _$hash = $jc(_$hash, section.hashCode);
    _$hash = $jc(_$hash, schoolYear.hashCode);
    _$hash = $jc(_$hash, lessonAttachment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LessonModel')
          ..add('id', id)
          ..add('title', title)
          ..add('content', content)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('teacherSubjectId', teacherSubjectId)
          ..add('sectionId', sectionId)
          ..add('schoolYearId', schoolYearId)
          ..add('schoolId', schoolId)
          ..add('teacherSubject', teacherSubject)
          ..add('section', section)
          ..add('schoolYear', schoolYear)
          ..add('lessonAttachment', lessonAttachment))
        .toString();
  }
}

class LessonModelBuilder implements Builder<LessonModel, LessonModelBuilder> {
  _$LessonModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _teacherSubjectId;
  String? get teacherSubjectId => _$this._teacherSubjectId;
  set teacherSubjectId(String? teacherSubjectId) =>
      _$this._teacherSubjectId = teacherSubjectId;

  String? _sectionId;
  String? get sectionId => _$this._sectionId;
  set sectionId(String? sectionId) => _$this._sectionId = sectionId;

  String? _schoolYearId;
  String? get schoolYearId => _$this._schoolYearId;
  set schoolYearId(String? schoolYearId) => _$this._schoolYearId = schoolYearId;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  TeacherSubjectBuilder? _teacherSubject;
  TeacherSubjectBuilder get teacherSubject =>
      _$this._teacherSubject ??= TeacherSubjectBuilder();
  set teacherSubject(TeacherSubjectBuilder? teacherSubject) =>
      _$this._teacherSubject = teacherSubject;

  SectionBuilder? _section;
  SectionBuilder get section => _$this._section ??= SectionBuilder();
  set section(SectionBuilder? section) => _$this._section = section;

  SchoolYearBuilder? _schoolYear;
  SchoolYearBuilder get schoolYear =>
      _$this._schoolYear ??= SchoolYearBuilder();
  set schoolYear(SchoolYearBuilder? schoolYear) =>
      _$this._schoolYear = schoolYear;

  ListBuilder<LessonAttachmentModel>? _lessonAttachment;
  ListBuilder<LessonAttachmentModel> get lessonAttachment =>
      _$this._lessonAttachment ??= ListBuilder<LessonAttachmentModel>();
  set lessonAttachment(ListBuilder<LessonAttachmentModel>? lessonAttachment) =>
      _$this._lessonAttachment = lessonAttachment;

  LessonModelBuilder();

  LessonModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _content = $v.content;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _teacherSubjectId = $v.teacherSubjectId;
      _sectionId = $v.sectionId;
      _schoolYearId = $v.schoolYearId;
      _schoolId = $v.schoolId;
      _teacherSubject = $v.teacherSubject.toBuilder();
      _section = $v.section.toBuilder();
      _schoolYear = $v.schoolYear.toBuilder();
      _lessonAttachment = $v.lessonAttachment.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LessonModel other) {
    _$v = other as _$LessonModel;
  }

  @override
  void update(void Function(LessonModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LessonModel build() => _build();

  _$LessonModel _build() {
    _$LessonModel _$result;
    try {
      _$result =
          _$v ??
          _$LessonModel._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'LessonModel', 'id'),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'LessonModel',
              'title',
            ),
            content: BuiltValueNullFieldError.checkNotNull(
              content,
              r'LessonModel',
              'content',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'LessonModel',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'LessonModel',
              'updatedAt',
            ),
            teacherSubjectId: BuiltValueNullFieldError.checkNotNull(
              teacherSubjectId,
              r'LessonModel',
              'teacherSubjectId',
            ),
            sectionId: sectionId,
            schoolYearId: BuiltValueNullFieldError.checkNotNull(
              schoolYearId,
              r'LessonModel',
              'schoolYearId',
            ),
            schoolId: BuiltValueNullFieldError.checkNotNull(
              schoolId,
              r'LessonModel',
              'schoolId',
            ),
            teacherSubject: teacherSubject.build(),
            section: section.build(),
            schoolYear: schoolYear.build(),
            lessonAttachment: lessonAttachment.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'teacherSubject';
        teacherSubject.build();
        _$failedField = 'section';
        section.build();
        _$failedField = 'schoolYear';
        schoolYear.build();
        _$failedField = 'lessonAttachment';
        lessonAttachment.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'LessonModel',
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
