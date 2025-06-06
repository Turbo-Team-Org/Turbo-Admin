// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminAuthState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AdminAuthState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AdminAuthState()';
  }
}

/// @nodoc
class $AdminAuthStateCopyWith<$Res> {
  $AdminAuthStateCopyWith(AdminAuthState _, $Res Function(AdminAuthState) __);
}

/// @nodoc

class AdminAuthInitial implements AdminAuthState {
  const AdminAuthInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AdminAuthInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AdminAuthState.initial()';
  }
}

/// @nodoc

class AdminAuthLoading implements AdminAuthState {
  const AdminAuthLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AdminAuthLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AdminAuthState.loading()';
  }
}

/// @nodoc

class AdminAuthAuthenticated implements AdminAuthState {
  const AdminAuthAuthenticated(this.user);

  final AdminUser user;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminAuthAuthenticatedCopyWith<AdminAuthAuthenticated> get copyWith =>
      _$AdminAuthAuthenticatedCopyWithImpl<AdminAuthAuthenticated>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminAuthAuthenticated &&
            const DeepCollectionEquality().equals(other.user, user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(user));

  @override
  String toString() {
    return 'AdminAuthState.authenticated(user: $user)';
  }
}

/// @nodoc
abstract mixin class $AdminAuthAuthenticatedCopyWith<$Res>
    implements $AdminAuthStateCopyWith<$Res> {
  factory $AdminAuthAuthenticatedCopyWith(AdminAuthAuthenticated value,
          $Res Function(AdminAuthAuthenticated) _then) =
      _$AdminAuthAuthenticatedCopyWithImpl;
  @useResult
  $Res call({AdminUser user});
}

/// @nodoc
class _$AdminAuthAuthenticatedCopyWithImpl<$Res>
    implements $AdminAuthAuthenticatedCopyWith<$Res> {
  _$AdminAuthAuthenticatedCopyWithImpl(this._self, this._then);

  final AdminAuthAuthenticated _self;
  final $Res Function(AdminAuthAuthenticated) _then;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = freezed,
  }) {
    return _then(AdminAuthAuthenticated(
      freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AdminUser,
    ));
  }
}

/// @nodoc

class AdminAuthUnauthenticated implements AdminAuthState {
  const AdminAuthUnauthenticated();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AdminAuthUnauthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AdminAuthState.unauthenticated()';
  }
}

/// @nodoc

class AdminAuthError implements AdminAuthState {
  const AdminAuthError(this.message);

  final String message;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminAuthErrorCopyWith<AdminAuthError> get copyWith =>
      _$AdminAuthErrorCopyWithImpl<AdminAuthError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminAuthError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AdminAuthState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AdminAuthErrorCopyWith<$Res>
    implements $AdminAuthStateCopyWith<$Res> {
  factory $AdminAuthErrorCopyWith(
          AdminAuthError value, $Res Function(AdminAuthError) _then) =
      _$AdminAuthErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AdminAuthErrorCopyWithImpl<$Res>
    implements $AdminAuthErrorCopyWith<$Res> {
  _$AdminAuthErrorCopyWithImpl(this._self, this._then);

  final AdminAuthError _self;
  final $Res Function(AdminAuthError) _then;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(AdminAuthError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AdminAuthPasswordResetSent implements AdminAuthState {
  const AdminAuthPasswordResetSent();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminAuthPasswordResetSent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AdminAuthState.passwordResetSent()';
  }
}

// dart format on
