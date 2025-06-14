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

class AdminAuthenticatedAdmin implements AdminAuthState {
  const AdminAuthenticatedAdmin(this.user);

  final AdminUser user;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminAuthenticatedAdminCopyWith<AdminAuthenticatedAdmin> get copyWith =>
      _$AdminAuthenticatedAdminCopyWithImpl<AdminAuthenticatedAdmin>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminAuthenticatedAdmin &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  String toString() {
    return 'AdminAuthState.authenticatedAdmin(user: $user)';
  }
}

/// @nodoc
abstract mixin class $AdminAuthenticatedAdminCopyWith<$Res>
    implements $AdminAuthStateCopyWith<$Res> {
  factory $AdminAuthenticatedAdminCopyWith(AdminAuthenticatedAdmin value,
          $Res Function(AdminAuthenticatedAdmin) _then) =
      _$AdminAuthenticatedAdminCopyWithImpl;
  @useResult
  $Res call({AdminUser user});

  $AdminUserCopyWith<$Res> get user;
}

/// @nodoc
class _$AdminAuthenticatedAdminCopyWithImpl<$Res>
    implements $AdminAuthenticatedAdminCopyWith<$Res> {
  _$AdminAuthenticatedAdminCopyWithImpl(this._self, this._then);

  final AdminAuthenticatedAdmin _self;
  final $Res Function(AdminAuthenticatedAdmin) _then;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = null,
  }) {
    return _then(AdminAuthenticatedAdmin(
      null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AdminUser,
    ));
  }

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdminUserCopyWith<$Res> get user {
    return $AdminUserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc

class AdminAuthenticatedBusinessOwner implements AdminAuthState {
  const AdminAuthenticatedBusinessOwner(this.request);

  final BusinessOwnerRequest request;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminAuthenticatedBusinessOwnerCopyWith<AdminAuthenticatedBusinessOwner>
      get copyWith => _$AdminAuthenticatedBusinessOwnerCopyWithImpl<
          AdminAuthenticatedBusinessOwner>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminAuthenticatedBusinessOwner &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);

  @override
  String toString() {
    return 'AdminAuthState.authenticatedBusinessOwner(request: $request)';
  }
}

/// @nodoc
abstract mixin class $AdminAuthenticatedBusinessOwnerCopyWith<$Res>
    implements $AdminAuthStateCopyWith<$Res> {
  factory $AdminAuthenticatedBusinessOwnerCopyWith(
          AdminAuthenticatedBusinessOwner value,
          $Res Function(AdminAuthenticatedBusinessOwner) _then) =
      _$AdminAuthenticatedBusinessOwnerCopyWithImpl;
  @useResult
  $Res call({BusinessOwnerRequest request});

  $BusinessOwnerRequestCopyWith<$Res> get request;
}

/// @nodoc
class _$AdminAuthenticatedBusinessOwnerCopyWithImpl<$Res>
    implements $AdminAuthenticatedBusinessOwnerCopyWith<$Res> {
  _$AdminAuthenticatedBusinessOwnerCopyWithImpl(this._self, this._then);

  final AdminAuthenticatedBusinessOwner _self;
  final $Res Function(AdminAuthenticatedBusinessOwner) _then;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? request = null,
  }) {
    return _then(AdminAuthenticatedBusinessOwner(
      null == request
          ? _self.request
          : request // ignore: cast_nullable_to_non_nullable
              as BusinessOwnerRequest,
    ));
  }

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusinessOwnerRequestCopyWith<$Res> get request {
    return $BusinessOwnerRequestCopyWith<$Res>(_self.request, (value) {
      return _then(_self.copyWith(request: value));
    });
  }
}

/// @nodoc

class AdminAuthBusinessOwnerRegistered implements AdminAuthState {
  const AdminAuthBusinessOwnerRegistered(this.request);

  final BusinessOwnerRequest request;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminAuthBusinessOwnerRegisteredCopyWith<AdminAuthBusinessOwnerRegistered>
      get copyWith => _$AdminAuthBusinessOwnerRegisteredCopyWithImpl<
          AdminAuthBusinessOwnerRegistered>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminAuthBusinessOwnerRegistered &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);

  @override
  String toString() {
    return 'AdminAuthState.businessOwnerRegistered(request: $request)';
  }
}

/// @nodoc
abstract mixin class $AdminAuthBusinessOwnerRegisteredCopyWith<$Res>
    implements $AdminAuthStateCopyWith<$Res> {
  factory $AdminAuthBusinessOwnerRegisteredCopyWith(
          AdminAuthBusinessOwnerRegistered value,
          $Res Function(AdminAuthBusinessOwnerRegistered) _then) =
      _$AdminAuthBusinessOwnerRegisteredCopyWithImpl;
  @useResult
  $Res call({BusinessOwnerRequest request});

  $BusinessOwnerRequestCopyWith<$Res> get request;
}

/// @nodoc
class _$AdminAuthBusinessOwnerRegisteredCopyWithImpl<$Res>
    implements $AdminAuthBusinessOwnerRegisteredCopyWith<$Res> {
  _$AdminAuthBusinessOwnerRegisteredCopyWithImpl(this._self, this._then);

  final AdminAuthBusinessOwnerRegistered _self;
  final $Res Function(AdminAuthBusinessOwnerRegistered) _then;

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? request = null,
  }) {
    return _then(AdminAuthBusinessOwnerRegistered(
      null == request
          ? _self.request
          : request // ignore: cast_nullable_to_non_nullable
              as BusinessOwnerRequest,
    ));
  }

  /// Create a copy of AdminAuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusinessOwnerRequestCopyWith<$Res> get request {
    return $BusinessOwnerRequestCopyWith<$Res>(_self.request, (value) {
      return _then(_self.copyWith(request: value));
    });
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
