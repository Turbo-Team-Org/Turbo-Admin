// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_requests_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessRequestsStats {
  int get total;
  int get pending;
  int get approved;
  int get rejected;
  int get reviewing;
  int get needsMoreInfo;

  /// Create a copy of BusinessRequestsStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BusinessRequestsStatsCopyWith<BusinessRequestsStats> get copyWith =>
      _$BusinessRequestsStatsCopyWithImpl<BusinessRequestsStats>(
          this as BusinessRequestsStats, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BusinessRequestsStats &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.pending, pending) || other.pending == pending) &&
            (identical(other.approved, approved) ||
                other.approved == approved) &&
            (identical(other.rejected, rejected) ||
                other.rejected == rejected) &&
            (identical(other.reviewing, reviewing) ||
                other.reviewing == reviewing) &&
            (identical(other.needsMoreInfo, needsMoreInfo) ||
                other.needsMoreInfo == needsMoreInfo));
  }

  @override
  int get hashCode => Object.hash(runtimeType, total, pending, approved,
      rejected, reviewing, needsMoreInfo);

  @override
  String toString() {
    return 'BusinessRequestsStats(total: $total, pending: $pending, approved: $approved, rejected: $rejected, reviewing: $reviewing, needsMoreInfo: $needsMoreInfo)';
  }
}

/// @nodoc
abstract mixin class $BusinessRequestsStatsCopyWith<$Res> {
  factory $BusinessRequestsStatsCopyWith(BusinessRequestsStats value,
          $Res Function(BusinessRequestsStats) _then) =
      _$BusinessRequestsStatsCopyWithImpl;
  @useResult
  $Res call(
      {int total,
      int pending,
      int approved,
      int rejected,
      int reviewing,
      int needsMoreInfo});
}

/// @nodoc
class _$BusinessRequestsStatsCopyWithImpl<$Res>
    implements $BusinessRequestsStatsCopyWith<$Res> {
  _$BusinessRequestsStatsCopyWithImpl(this._self, this._then);

  final BusinessRequestsStats _self;
  final $Res Function(BusinessRequestsStats) _then;

  /// Create a copy of BusinessRequestsStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? pending = null,
    Object? approved = null,
    Object? rejected = null,
    Object? reviewing = null,
    Object? needsMoreInfo = null,
  }) {
    return _then(_self.copyWith(
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      pending: null == pending
          ? _self.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as int,
      approved: null == approved
          ? _self.approved
          : approved // ignore: cast_nullable_to_non_nullable
              as int,
      rejected: null == rejected
          ? _self.rejected
          : rejected // ignore: cast_nullable_to_non_nullable
              as int,
      reviewing: null == reviewing
          ? _self.reviewing
          : reviewing // ignore: cast_nullable_to_non_nullable
              as int,
      needsMoreInfo: null == needsMoreInfo
          ? _self.needsMoreInfo
          : needsMoreInfo // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _BusinessRequestsStats implements BusinessRequestsStats {
  const _BusinessRequestsStats(
      {required this.total,
      required this.pending,
      required this.approved,
      required this.rejected,
      required this.reviewing,
      required this.needsMoreInfo});

  @override
  final int total;
  @override
  final int pending;
  @override
  final int approved;
  @override
  final int rejected;
  @override
  final int reviewing;
  @override
  final int needsMoreInfo;

  /// Create a copy of BusinessRequestsStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BusinessRequestsStatsCopyWith<_BusinessRequestsStats> get copyWith =>
      __$BusinessRequestsStatsCopyWithImpl<_BusinessRequestsStats>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BusinessRequestsStats &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.pending, pending) || other.pending == pending) &&
            (identical(other.approved, approved) ||
                other.approved == approved) &&
            (identical(other.rejected, rejected) ||
                other.rejected == rejected) &&
            (identical(other.reviewing, reviewing) ||
                other.reviewing == reviewing) &&
            (identical(other.needsMoreInfo, needsMoreInfo) ||
                other.needsMoreInfo == needsMoreInfo));
  }

  @override
  int get hashCode => Object.hash(runtimeType, total, pending, approved,
      rejected, reviewing, needsMoreInfo);

  @override
  String toString() {
    return 'BusinessRequestsStats(total: $total, pending: $pending, approved: $approved, rejected: $rejected, reviewing: $reviewing, needsMoreInfo: $needsMoreInfo)';
  }
}

/// @nodoc
abstract mixin class _$BusinessRequestsStatsCopyWith<$Res>
    implements $BusinessRequestsStatsCopyWith<$Res> {
  factory _$BusinessRequestsStatsCopyWith(_BusinessRequestsStats value,
          $Res Function(_BusinessRequestsStats) _then) =
      __$BusinessRequestsStatsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int total,
      int pending,
      int approved,
      int rejected,
      int reviewing,
      int needsMoreInfo});
}

/// @nodoc
class __$BusinessRequestsStatsCopyWithImpl<$Res>
    implements _$BusinessRequestsStatsCopyWith<$Res> {
  __$BusinessRequestsStatsCopyWithImpl(this._self, this._then);

  final _BusinessRequestsStats _self;
  final $Res Function(_BusinessRequestsStats) _then;

  /// Create a copy of BusinessRequestsStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? total = null,
    Object? pending = null,
    Object? approved = null,
    Object? rejected = null,
    Object? reviewing = null,
    Object? needsMoreInfo = null,
  }) {
    return _then(_BusinessRequestsStats(
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      pending: null == pending
          ? _self.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as int,
      approved: null == approved
          ? _self.approved
          : approved // ignore: cast_nullable_to_non_nullable
              as int,
      rejected: null == rejected
          ? _self.rejected
          : rejected // ignore: cast_nullable_to_non_nullable
              as int,
      reviewing: null == reviewing
          ? _self.reviewing
          : reviewing // ignore: cast_nullable_to_non_nullable
              as int,
      needsMoreInfo: null == needsMoreInfo
          ? _self.needsMoreInfo
          : needsMoreInfo // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$BusinessRequestsState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BusinessRequestsState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BusinessRequestsState()';
  }
}

/// @nodoc
class $BusinessRequestsStateCopyWith<$Res> {
  $BusinessRequestsStateCopyWith(
      BusinessRequestsState _, $Res Function(BusinessRequestsState) __);
}

/// @nodoc

class BusinessRequestsInitial implements BusinessRequestsState {
  const BusinessRequestsInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BusinessRequestsInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BusinessRequestsState.initial()';
  }
}

/// @nodoc

class BusinessRequestsLoading implements BusinessRequestsState {
  const BusinessRequestsLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BusinessRequestsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BusinessRequestsState.loading()';
  }
}

/// @nodoc

class BusinessRequestsLoaded implements BusinessRequestsState {
  const BusinessRequestsLoaded(final List<BusinessOwnerRequest> requests,
      {final List<BusinessOwnerRequest> allRequests = const []})
      : _requests = requests,
        _allRequests = allRequests;

  final List<BusinessOwnerRequest> _requests;
  List<BusinessOwnerRequest> get requests {
    if (_requests is EqualUnmodifiableListView) return _requests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requests);
  }

  final List<BusinessOwnerRequest> _allRequests;
  @JsonKey()
  List<BusinessOwnerRequest> get allRequests {
    if (_allRequests is EqualUnmodifiableListView) return _allRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allRequests);
  }

  /// Create a copy of BusinessRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BusinessRequestsLoadedCopyWith<BusinessRequestsLoaded> get copyWith =>
      _$BusinessRequestsLoadedCopyWithImpl<BusinessRequestsLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BusinessRequestsLoaded &&
            const DeepCollectionEquality().equals(other._requests, _requests) &&
            const DeepCollectionEquality()
                .equals(other._allRequests, _allRequests));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_requests),
      const DeepCollectionEquality().hash(_allRequests));

  @override
  String toString() {
    return 'BusinessRequestsState.loaded(requests: $requests, allRequests: $allRequests)';
  }
}

/// @nodoc
abstract mixin class $BusinessRequestsLoadedCopyWith<$Res>
    implements $BusinessRequestsStateCopyWith<$Res> {
  factory $BusinessRequestsLoadedCopyWith(BusinessRequestsLoaded value,
          $Res Function(BusinessRequestsLoaded) _then) =
      _$BusinessRequestsLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<BusinessOwnerRequest> requests,
      List<BusinessOwnerRequest> allRequests});
}

/// @nodoc
class _$BusinessRequestsLoadedCopyWithImpl<$Res>
    implements $BusinessRequestsLoadedCopyWith<$Res> {
  _$BusinessRequestsLoadedCopyWithImpl(this._self, this._then);

  final BusinessRequestsLoaded _self;
  final $Res Function(BusinessRequestsLoaded) _then;

  /// Create a copy of BusinessRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requests = null,
    Object? allRequests = null,
  }) {
    return _then(BusinessRequestsLoaded(
      null == requests
          ? _self._requests
          : requests // ignore: cast_nullable_to_non_nullable
              as List<BusinessOwnerRequest>,
      allRequests: null == allRequests
          ? _self._allRequests
          : allRequests // ignore: cast_nullable_to_non_nullable
              as List<BusinessOwnerRequest>,
    ));
  }
}

/// @nodoc

class BusinessRequestsError implements BusinessRequestsState {
  const BusinessRequestsError(this.message);

  final String message;

  /// Create a copy of BusinessRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BusinessRequestsErrorCopyWith<BusinessRequestsError> get copyWith =>
      _$BusinessRequestsErrorCopyWithImpl<BusinessRequestsError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BusinessRequestsError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'BusinessRequestsState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $BusinessRequestsErrorCopyWith<$Res>
    implements $BusinessRequestsStateCopyWith<$Res> {
  factory $BusinessRequestsErrorCopyWith(BusinessRequestsError value,
          $Res Function(BusinessRequestsError) _then) =
      _$BusinessRequestsErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$BusinessRequestsErrorCopyWithImpl<$Res>
    implements $BusinessRequestsErrorCopyWith<$Res> {
  _$BusinessRequestsErrorCopyWithImpl(this._self, this._then);

  final BusinessRequestsError _self;
  final $Res Function(BusinessRequestsError) _then;

  /// Create a copy of BusinessRequestsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(BusinessRequestsError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
