// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_dashboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReservationDashboardState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationDashboardState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationDashboardState()';
  }
}

/// @nodoc
class $ReservationDashboardStateCopyWith<$Res> {
  $ReservationDashboardStateCopyWith(
      ReservationDashboardState _, $Res Function(ReservationDashboardState) __);
}

/// @nodoc

class ReservationDashboardInitial implements ReservationDashboardState {
  const ReservationDashboardInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationDashboardInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationDashboardState.initial()';
  }
}

/// @nodoc

class ReservationDashboardLoading implements ReservationDashboardState {
  const ReservationDashboardLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationDashboardLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReservationDashboardState.loading()';
  }
}

/// @nodoc

class ReservationDashboardLoaded implements ReservationDashboardState {
  const ReservationDashboardLoaded(
      {required final List<Reservation> todayReservations,
      required final List<Reservation> pendingReservations,
      required final List<Reservation> weekReservations,
      required this.stats,
      final List<Reservation> allReservations = const []})
      : _todayReservations = todayReservations,
        _pendingReservations = pendingReservations,
        _weekReservations = weekReservations,
        _allReservations = allReservations;

  final List<Reservation> _todayReservations;
  List<Reservation> get todayReservations {
    if (_todayReservations is EqualUnmodifiableListView)
      return _todayReservations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todayReservations);
  }

  final List<Reservation> _pendingReservations;
  List<Reservation> get pendingReservations {
    if (_pendingReservations is EqualUnmodifiableListView)
      return _pendingReservations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingReservations);
  }

  final List<Reservation> _weekReservations;
  List<Reservation> get weekReservations {
    if (_weekReservations is EqualUnmodifiableListView)
      return _weekReservations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekReservations);
  }

  final ReservationStats stats;
  final List<Reservation> _allReservations;
  @JsonKey()
  List<Reservation> get allReservations {
    if (_allReservations is EqualUnmodifiableListView) return _allReservations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allReservations);
  }

  /// Create a copy of ReservationDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationDashboardLoadedCopyWith<ReservationDashboardLoaded>
      get copyWith =>
          _$ReservationDashboardLoadedCopyWithImpl<ReservationDashboardLoaded>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationDashboardLoaded &&
            const DeepCollectionEquality()
                .equals(other._todayReservations, _todayReservations) &&
            const DeepCollectionEquality()
                .equals(other._pendingReservations, _pendingReservations) &&
            const DeepCollectionEquality()
                .equals(other._weekReservations, _weekReservations) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality()
                .equals(other._allReservations, _allReservations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_todayReservations),
      const DeepCollectionEquality().hash(_pendingReservations),
      const DeepCollectionEquality().hash(_weekReservations),
      stats,
      const DeepCollectionEquality().hash(_allReservations));

  @override
  String toString() {
    return 'ReservationDashboardState.loaded(todayReservations: $todayReservations, pendingReservations: $pendingReservations, weekReservations: $weekReservations, stats: $stats, allReservations: $allReservations)';
  }
}

/// @nodoc
abstract mixin class $ReservationDashboardLoadedCopyWith<$Res>
    implements $ReservationDashboardStateCopyWith<$Res> {
  factory $ReservationDashboardLoadedCopyWith(ReservationDashboardLoaded value,
          $Res Function(ReservationDashboardLoaded) _then) =
      _$ReservationDashboardLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<Reservation> todayReservations,
      List<Reservation> pendingReservations,
      List<Reservation> weekReservations,
      ReservationStats stats,
      List<Reservation> allReservations});

  $ReservationStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$ReservationDashboardLoadedCopyWithImpl<$Res>
    implements $ReservationDashboardLoadedCopyWith<$Res> {
  _$ReservationDashboardLoadedCopyWithImpl(this._self, this._then);

  final ReservationDashboardLoaded _self;
  final $Res Function(ReservationDashboardLoaded) _then;

  /// Create a copy of ReservationDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? todayReservations = null,
    Object? pendingReservations = null,
    Object? weekReservations = null,
    Object? stats = null,
    Object? allReservations = null,
  }) {
    return _then(ReservationDashboardLoaded(
      todayReservations: null == todayReservations
          ? _self._todayReservations
          : todayReservations // ignore: cast_nullable_to_non_nullable
              as List<Reservation>,
      pendingReservations: null == pendingReservations
          ? _self._pendingReservations
          : pendingReservations // ignore: cast_nullable_to_non_nullable
              as List<Reservation>,
      weekReservations: null == weekReservations
          ? _self._weekReservations
          : weekReservations // ignore: cast_nullable_to_non_nullable
              as List<Reservation>,
      stats: null == stats
          ? _self.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as ReservationStats,
      allReservations: null == allReservations
          ? _self._allReservations
          : allReservations // ignore: cast_nullable_to_non_nullable
              as List<Reservation>,
    ));
  }

  /// Create a copy of ReservationDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReservationStatsCopyWith<$Res> get stats {
    return $ReservationStatsCopyWith<$Res>(_self.stats, (value) {
      return _then(_self.copyWith(stats: value));
    });
  }
}

/// @nodoc

class ReservationDashboardError implements ReservationDashboardState {
  const ReservationDashboardError(this.message);

  final String message;

  /// Create a copy of ReservationDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationDashboardErrorCopyWith<ReservationDashboardError> get copyWith =>
      _$ReservationDashboardErrorCopyWithImpl<ReservationDashboardError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationDashboardError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ReservationDashboardState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ReservationDashboardErrorCopyWith<$Res>
    implements $ReservationDashboardStateCopyWith<$Res> {
  factory $ReservationDashboardErrorCopyWith(ReservationDashboardError value,
          $Res Function(ReservationDashboardError) _then) =
      _$ReservationDashboardErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ReservationDashboardErrorCopyWithImpl<$Res>
    implements $ReservationDashboardErrorCopyWith<$Res> {
  _$ReservationDashboardErrorCopyWithImpl(this._self, this._then);

  final ReservationDashboardError _self;
  final $Res Function(ReservationDashboardError) _then;

  /// Create a copy of ReservationDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ReservationDashboardError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ReservationStats {
  int get totalThisMonth;
  int get completedThisMonth;
  int get cancelledThisMonth;
  double get averagePartySize;

  /// Create a copy of ReservationStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReservationStatsCopyWith<ReservationStats> get copyWith =>
      _$ReservationStatsCopyWithImpl<ReservationStats>(
          this as ReservationStats, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReservationStats &&
            (identical(other.totalThisMonth, totalThisMonth) ||
                other.totalThisMonth == totalThisMonth) &&
            (identical(other.completedThisMonth, completedThisMonth) ||
                other.completedThisMonth == completedThisMonth) &&
            (identical(other.cancelledThisMonth, cancelledThisMonth) ||
                other.cancelledThisMonth == cancelledThisMonth) &&
            (identical(other.averagePartySize, averagePartySize) ||
                other.averagePartySize == averagePartySize));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalThisMonth,
      completedThisMonth, cancelledThisMonth, averagePartySize);

  @override
  String toString() {
    return 'ReservationStats(totalThisMonth: $totalThisMonth, completedThisMonth: $completedThisMonth, cancelledThisMonth: $cancelledThisMonth, averagePartySize: $averagePartySize)';
  }
}

/// @nodoc
abstract mixin class $ReservationStatsCopyWith<$Res> {
  factory $ReservationStatsCopyWith(
          ReservationStats value, $Res Function(ReservationStats) _then) =
      _$ReservationStatsCopyWithImpl;
  @useResult
  $Res call(
      {int totalThisMonth,
      int completedThisMonth,
      int cancelledThisMonth,
      double averagePartySize});
}

/// @nodoc
class _$ReservationStatsCopyWithImpl<$Res>
    implements $ReservationStatsCopyWith<$Res> {
  _$ReservationStatsCopyWithImpl(this._self, this._then);

  final ReservationStats _self;
  final $Res Function(ReservationStats) _then;

  /// Create a copy of ReservationStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalThisMonth = null,
    Object? completedThisMonth = null,
    Object? cancelledThisMonth = null,
    Object? averagePartySize = null,
  }) {
    return _then(_self.copyWith(
      totalThisMonth: null == totalThisMonth
          ? _self.totalThisMonth
          : totalThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      completedThisMonth: null == completedThisMonth
          ? _self.completedThisMonth
          : completedThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledThisMonth: null == cancelledThisMonth
          ? _self.cancelledThisMonth
          : cancelledThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      averagePartySize: null == averagePartySize
          ? _self.averagePartySize
          : averagePartySize // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _ReservationStats implements ReservationStats {
  const _ReservationStats(
      {required this.totalThisMonth,
      required this.completedThisMonth,
      required this.cancelledThisMonth,
      required this.averagePartySize});

  @override
  final int totalThisMonth;
  @override
  final int completedThisMonth;
  @override
  final int cancelledThisMonth;
  @override
  final double averagePartySize;

  /// Create a copy of ReservationStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReservationStatsCopyWith<_ReservationStats> get copyWith =>
      __$ReservationStatsCopyWithImpl<_ReservationStats>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReservationStats &&
            (identical(other.totalThisMonth, totalThisMonth) ||
                other.totalThisMonth == totalThisMonth) &&
            (identical(other.completedThisMonth, completedThisMonth) ||
                other.completedThisMonth == completedThisMonth) &&
            (identical(other.cancelledThisMonth, cancelledThisMonth) ||
                other.cancelledThisMonth == cancelledThisMonth) &&
            (identical(other.averagePartySize, averagePartySize) ||
                other.averagePartySize == averagePartySize));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalThisMonth,
      completedThisMonth, cancelledThisMonth, averagePartySize);

  @override
  String toString() {
    return 'ReservationStats(totalThisMonth: $totalThisMonth, completedThisMonth: $completedThisMonth, cancelledThisMonth: $cancelledThisMonth, averagePartySize: $averagePartySize)';
  }
}

/// @nodoc
abstract mixin class _$ReservationStatsCopyWith<$Res>
    implements $ReservationStatsCopyWith<$Res> {
  factory _$ReservationStatsCopyWith(
          _ReservationStats value, $Res Function(_ReservationStats) _then) =
      __$ReservationStatsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalThisMonth,
      int completedThisMonth,
      int cancelledThisMonth,
      double averagePartySize});
}

/// @nodoc
class __$ReservationStatsCopyWithImpl<$Res>
    implements _$ReservationStatsCopyWith<$Res> {
  __$ReservationStatsCopyWithImpl(this._self, this._then);

  final _ReservationStats _self;
  final $Res Function(_ReservationStats) _then;

  /// Create a copy of ReservationStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalThisMonth = null,
    Object? completedThisMonth = null,
    Object? cancelledThisMonth = null,
    Object? averagePartySize = null,
  }) {
    return _then(_ReservationStats(
      totalThisMonth: null == totalThisMonth
          ? _self.totalThisMonth
          : totalThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      completedThisMonth: null == completedThisMonth
          ? _self.completedThisMonth
          : completedThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledThisMonth: null == cancelledThisMonth
          ? _self.cancelledThisMonth
          : cancelledThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      averagePartySize: null == averagePartySize
          ? _self.averagePartySize
          : averagePartySize // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
