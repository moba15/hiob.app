// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomAction _$CustomActionFromJson(Map<String, dynamic> json) {
  return _CustomAction.fromJson(json);
}

/// @nodoc
mixin _$CustomAction {
  /// Serializes this CustomAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomActionCopyWith<$Res> {
  factory $CustomActionCopyWith(
          CustomAction value, $Res Function(CustomAction) then) =
      _$CustomActionCopyWithImpl<$Res, CustomAction>;
}

/// @nodoc
class _$CustomActionCopyWithImpl<$Res, $Val extends CustomAction>
    implements $CustomActionCopyWith<$Res> {
  _$CustomActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomAction
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CustomActionImplCopyWith<$Res> {
  factory _$$CustomActionImplCopyWith(
          _$CustomActionImpl value, $Res Function(_$CustomActionImpl) then) =
      __$$CustomActionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CustomActionImplCopyWithImpl<$Res>
    extends _$CustomActionCopyWithImpl<$Res, _$CustomActionImpl>
    implements _$$CustomActionImplCopyWith<$Res> {
  __$$CustomActionImplCopyWithImpl(
      _$CustomActionImpl _value, $Res Function(_$CustomActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomAction
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$CustomActionImpl implements _CustomAction {
  _$CustomActionImpl();

  factory _$CustomActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomActionImplFromJson(json);

  @override
  String toString() {
    return 'CustomAction()';
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomActionImplToJson(
      this,
    );
  }
}

abstract class _CustomAction implements CustomAction {
  factory _CustomAction() = _$CustomActionImpl;

  factory _CustomAction.fromJson(Map<String, dynamic> json) =
      _$CustomActionImpl.fromJson;
}
