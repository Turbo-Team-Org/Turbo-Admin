// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_management_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReservationManagementState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationManagementState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationManagementState()';
  }
}

/// @nodoc
class $ReservationManagementStateCopyWith<$Res> {
  $ReservationManagementStateCopyWith(ReservationManagementState _,
      $Res Function(ReservationManagementState) __);
}

/// @nodoc

class ReservationManagementInitial implements ReservationManagementState {
  const ReservationManagementInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationManagementInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationManagementState.initial()';
  }
}

/// @nodoc

class ReservationManagementLoading implements ReservationManagementState {
  const ReservationManagementLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationManagementLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationManagementState.loading()';
  }
}

/// @nodoc

class ReservationManagementLoaded implements ReservationManagementState {
  const ReservationManagementLoaded(
      {required final List<Reservation> reservations,
      this.isProcessing = false,
      this.successMessage,
      this.errorMessage})
      : _reservations = reservations;

  final List<Reservation> _reservations;
  List<Reservation> get reservations {
    if (_reservations is EqualUnmodifiableListView) return _reservations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reservations);
  }

  @JsonKey()
  final bool isProcessing;
  final String? successMessage;
  final String? errorMessage;

  /// Create a copy of ReservationManagementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationManagementLoadedCopyWith<ReservationManagementLoaded>
      get copyWith => _$ReservationManagementLoadedCopyWithImpl<
          ReservationManagementLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationManagementLoaded &&
            const DeepCollectionEquality()
                .equals(other._reservations, _reservations) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_reservations),
      isProcessing,
      successMessage,
      errorMessage);

  @override
  String toString() {
    return 'ReservationManagementState.loaded(reservations: $reservations, isProcessing: $isProcessing, successMessage: $successMessage, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $ReservationManagementLoadedCopyWith<$Res>
    implements $ReservationManagementStateCopyWith<$Res> {
  factory $ReservationManagementLoadedCopyWith(
          ReservationManagementLoaded value,
          $Res Function(ReservationManagementLoaded) _then) =
      _$ReservationManagementLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<Reservation> reservations,
      bool isProcessing,
      String? successMessage,
      String? errorMessage});
}

/// @nodoc
class _$ReservationManagementLoadedCopyWithImpl<$Res>
    implements $ReservationManagementLoadedCopyWith<$Res> {
  _$ReservationManagementLoadedCopyWithImpl(this._self, this._then);

  final ReservationManagementLoaded _self;
  final $Res Function(ReservationManagementLoaded) _then;

  /// Create a copy of ReservationManagementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reservations = null,
    Object? isProcessing = null,
    Object? successMessage = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(ReservationManagementLoaded(
      reservations: null == reservations
          ? _self._reservations
          : reservations // ignore: cast_nullable_to_non_nullable
              as List<Reservation>,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
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

class ReservationManagementError implements ReservationManagementState {
  const ReservationManagementError(this.message);

  final String message;

  /// Create a copy of ReservationManagementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationManagementErrorCopyWith<ReservationManagementError>
      get copyWith =>
          _$ReservationManagementErrorCopyWithImpl<ReservationManagementError>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationManagementError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ReservationManagementState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ReservationManagementErrorCopyWith<$Res>
    implements $ReservationManagementStateCopyWith<$Res> {
  factory $ReservationManagementErrorCopyWith(ReservationManagementError value,
          $Res Function(ReservationManagementError) _then) =
      _$ReservationManagementErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ReservationManagementErrorCopyWithImpl<$Res>
    implements $ReservationManagementErrorCopyWith<$Res> {
  _$ReservationManagementErrorCopyWithImpl(this._self, this._then);

  final ReservationManagementError _self;
  final $Res Function(ReservationManagementError) _then;

  /// Create a copy of ReservationManagementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ReservationManagementError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
