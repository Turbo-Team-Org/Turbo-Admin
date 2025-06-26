// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_settings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvailabilitySettingsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvailabilitySettingsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AvailabilitySettingsState()';
  }
}

/// @nodoc
class $AvailabilitySettingsStateCopyWith<$Res> {
  $AvailabilitySettingsStateCopyWith(
      AvailabilitySettingsState _, $Res Function(AvailabilitySettingsState) __);
}

/// @nodoc

class AvailabilitySettingsInitial implements AvailabilitySettingsState {
  const AvailabilitySettingsInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvailabilitySettingsInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AvailabilitySettingsState.initial()';
  }
}

/// @nodoc

class AvailabilitySettingsLoading implements AvailabilitySettingsState {
  const AvailabilitySettingsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvailabilitySettingsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AvailabilitySettingsState.loading()';
  }
}

/// @nodoc

class AvailabilitySettingsLoaded implements AvailabilitySettingsState {
  const AvailabilitySettingsLoaded(
      {this.availability,
      this.isSaving = false,
      this.successMessage,
      this.errorMessage});

  final BusinessAvailability? availability;
  @JsonKey()
  final bool isSaving;
  final String? successMessage;
  final String? errorMessage;

  /// Create a copy of AvailabilitySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AvailabilitySettingsLoadedCopyWith<AvailabilitySettingsLoaded>
      get copyWith =>
          _$AvailabilitySettingsLoadedCopyWithImpl<AvailabilitySettingsLoaded>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvailabilitySettingsLoaded &&
            const DeepCollectionEquality()
                .equals(other.availability, availability) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(availability),
      isSaving,
      successMessage,
      errorMessage);

  @override
  String toString() {
    return 'AvailabilitySettingsState.loaded(availability: $availability, isSaving: $isSaving, successMessage: $successMessage, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $AvailabilitySettingsLoadedCopyWith<$Res>
    implements $AvailabilitySettingsStateCopyWith<$Res> {
  factory $AvailabilitySettingsLoadedCopyWith(AvailabilitySettingsLoaded value,
          $Res Function(AvailabilitySettingsLoaded) _then) =
      _$AvailabilitySettingsLoadedCopyWithImpl;
  @useResult
  $Res call(
      {BusinessAvailability? availability,
      bool isSaving,
      String? successMessage,
      String? errorMessage});
}

/// @nodoc
class _$AvailabilitySettingsLoadedCopyWithImpl<$Res>
    implements $AvailabilitySettingsLoadedCopyWith<$Res> {
  _$AvailabilitySettingsLoadedCopyWithImpl(this._self, this._then);

  final AvailabilitySettingsLoaded _self;
  final $Res Function(AvailabilitySettingsLoaded) _then;

  /// Create a copy of AvailabilitySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? availability = freezed,
    Object? isSaving = null,
    Object? successMessage = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(AvailabilitySettingsLoaded(
      availability: freezed == availability
          ? _self.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as BusinessAvailability?,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      successMessage: freezed == successMessage
          ? _self.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class AvailabilitySettingsError implements AvailabilitySettingsState {
  const AvailabilitySettingsError(this.message);

  final String message;

  /// Create a copy of AvailabilitySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AvailabilitySettingsErrorCopyWith<AvailabilitySettingsError> get copyWith =>
      _$AvailabilitySettingsErrorCopyWithImpl<AvailabilitySettingsError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvailabilitySettingsError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AvailabilitySettingsState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AvailabilitySettingsErrorCopyWith<$Res>
    implements $AvailabilitySettingsStateCopyWith<$Res> {
  factory $AvailabilitySettingsErrorCopyWith(AvailabilitySettingsError value,
          $Res Function(AvailabilitySettingsError) _then) =
      _$AvailabilitySettingsErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AvailabilitySettingsErrorCopyWithImpl<$Res>
    implements $AvailabilitySettingsErrorCopyWith<$Res> {
  _$AvailabilitySettingsErrorCopyWithImpl(this._self, this._then);

  final AvailabilitySettingsError _self;
  final $Res Function(AvailabilitySettingsError) _then;

  /// Create a copy of AvailabilitySettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(AvailabilitySettingsError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
