// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<HomeworkModel> _$homeworkModelSerializer =
    _$HomeworkModelSerializer();

class _$HomeworkModelSerializer implements StructuredSerializer<HomeworkModel> {
  @override
  final Iterable<Type> types = const [HomeworkModel, _$HomeworkModel];
  @override
  final String wireName = 'HomeworkModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    HomeworkModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'title',
      serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      ),
      'dueDate',
      serializers.serialize(
        object.dueDate,
        specifiedType: const FullType(DateTime),
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
      'HomeworkAttachment',
      serializers.serialize(
        object.attachments,
        specifiedType: const FullType(BuiltList, const [
          const FullType(AttachmentModel),
        ]),
      ),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.sectionId;
    if (value != null) {
      result
        ..add('sectionId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.studentHomeworks;
    if (value != null) {
      result
        ..add('StudentHomework')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(StudentHomeworkModel),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  HomeworkModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HomeworkModelBuilder();

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
        case 'title':
          result.title =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'dueDate':
          result.dueDate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
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
        case 'HomeworkAttachment':
          result.attachments.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(AttachmentModel),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'StudentHomework':
          result.studentHomeworks.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(StudentHomeworkModel),
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

class _$HomeworkModel extends HomeworkModel {
  @override
  final String? id;
  @override
  final String title;
  @override
  final DateTime dueDate;
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
  final BuiltList<AttachmentModel> attachments;
  @override
  final BuiltList<StudentHomeworkModel>? studentHomeworks;

  factory _$HomeworkModel([void Function(HomeworkModelBuilder)? updates]) =>
      (HomeworkModelBuilder()..update(updates))._build();

  _$HomeworkModel._({
    this.id,
    required this.title,
    required this.dueDate,
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
    required this.attachments,
    this.studentHomeworks,
  }) : super._();
  @override
  HomeworkModel rebuild(void Function(HomeworkModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeworkModelBuilder toBuilder() => HomeworkModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomeworkModel &&
        id == other.id &&
        title == other.title &&
        dueDate == other.dueDate &&
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
        attachments == other.attachments &&
        studentHomeworks == other.studentHomeworks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
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
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jc(_$hash, studentHomeworks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HomeworkModel')
          ..add('id', id)
          ..add('title', title)
          ..add('dueDate', dueDate)
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
          ..add('attachments', attachments)
          ..add('studentHomeworks', studentHomeworks))
        .toString();
  }
}

class HomeworkModelBuilder
    implements Builder<HomeworkModel, HomeworkModelBuilder> {
  _$HomeworkModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

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

  ListBuilder<AttachmentModel>? _attachments;
  ListBuilder<AttachmentModel> get attachments =>
      _$this._attachments ??= ListBuilder<AttachmentModel>();
  set attachments(ListBuilder<AttachmentModel>? attachments) =>
      _$this._attachments = attachments;

  ListBuilder<StudentHomeworkModel>? _studentHomeworks;
  ListBuilder<StudentHomeworkModel> get studentHomeworks =>
      _$this._studentHomeworks ??= ListBuilder<StudentHomeworkModel>();
  set studentHomeworks(ListBuilder<StudentHomeworkModel>? studentHomeworks) =>
      _$this._studentHomeworks = studentHomeworks;

  HomeworkModelBuilder();

  HomeworkModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _dueDate = $v.dueDate;
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
      _attachments = $v.attachments.toBuilder();
      _studentHomeworks = $v.studentHomeworks?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomeworkModel other) {
    _$v = other as _$HomeworkModel;
  }

  @override
  void update(void Function(HomeworkModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HomeworkModel build() => _build();

  _$HomeworkModel _build() {
    _$HomeworkModel _$result;
    try {
      _$result =
          _$v ??
          _$HomeworkModel._(
            id: id,
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'HomeworkModel',
              'title',
            ),
            dueDate: BuiltValueNullFieldError.checkNotNull(
              dueDate,
              r'HomeworkModel',
              'dueDate',
            ),
            content: BuiltValueNullFieldError.checkNotNull(
              content,
              r'HomeworkModel',
              'content',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'HomeworkModel',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'HomeworkModel',
              'updatedAt',
            ),
            teacherSubjectId: BuiltValueNullFieldError.checkNotNull(
              teacherSubjectId,
              r'HomeworkModel',
              'teacherSubjectId',
            ),
            sectionId: sectionId,
            schoolYearId: BuiltValueNullFieldError.checkNotNull(
              schoolYearId,
              r'HomeworkModel',
              'schoolYearId',
            ),
            schoolId: BuiltValueNullFieldError.checkNotNull(
              schoolId,
              r'HomeworkModel',
              'schoolId',
            ),
            teacherSubject: teacherSubject.build(),
            section: section.build(),
            schoolYear: schoolYear.build(),
            attachments: attachments.build(),
            studentHomeworks: _studentHomeworks?.build(),
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
        _$failedField = 'attachments';
        attachments.build();
        _$failedField = 'studentHomeworks';
        _studentHomeworks?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'HomeworkModel',
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
