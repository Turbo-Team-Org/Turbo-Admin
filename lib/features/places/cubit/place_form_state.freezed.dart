// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaceFormState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PlaceFormState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PlaceFormState()';
  }
}

/// @nodoc
class $PlaceFormStateCopyWith<$Res> {
  $PlaceFormStateCopyWith(PlaceFormState _, $Res Function(PlaceFormState) __);
}

/// @nodoc

class PlaceFormInitial implements PlaceFormState {
  const PlaceFormInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PlaceFormInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PlaceFormState.initial()';
  }
}

/// @nodoc

class PlaceFormLoading implements PlaceFormState {
  const PlaceFormLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PlaceFormLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PlaceFormState.loading()';
  }
}

/// @nodoc

class PlaceFormLoaded implements PlaceFormState {
  const PlaceFormLoaded(
      {required final List<Category> categories,
      this.place,
      final List<GooglePlace> autocompleteSuggestions = const <GooglePlace>[],
      this.isAutocompleteLoading = false,
      this.autocompleteError,
      this.selectedAddress,
      this.selectedLatitude,
      this.selectedLongitude})
      : _categories = categories,
        _autocompleteSuggestions = autocompleteSuggestions;

  final List<Category> _categories;
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final Place? place;
  final List<GooglePlace> _autocompleteSuggestions;
  @JsonKey()
  List<GooglePlace> get autocompleteSuggestions {
    if (_autocompleteSuggestions is EqualUnmodifiableListView)
      return _autocompleteSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_autocompleteSuggestions);
  }

  @JsonKey()
  final bool isAutocompleteLoading;
  final String? autocompleteError;
  final String? selectedAddress;
  final double? selectedLatitude;
  final double? selectedLongitude;

  /// Create a copy of PlaceFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlaceFormLoadedCopyWith<PlaceFormLoaded> get copyWith =>
      _$PlaceFormLoadedCopyWithImpl<PlaceFormLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlaceFormLoaded &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.place, place) || other.place == place) &&
            const DeepCollectionEquality().equals(
                other._autocompleteSuggestions, _autocompleteSuggestions) &&
            (identical(other.isAutocompleteLoading, isAutocompleteLoading) ||
                other.isAutocompleteLoading == isAutocompleteLoading) &&
            (identical(other.autocompleteError, autocompleteError) ||
                other.autocompleteError == autocompleteError) &&
            (identical(other.selectedAddress, selectedAddress) ||
                other.selectedAddress == selectedAddress) &&
            (identical(other.selectedLatitude, selectedLatitude) ||
                other.selectedLatitude == selectedLatitude) &&
            (identical(other.selectedLongitude, selectedLongitude) ||
                other.selectedLongitude == selectedLongitude));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      place,
      const DeepCollectionEquality().hash(_autocompleteSuggestions),
      isAutocompleteLoading,
      autocompleteError,
      selectedAddress,
      selectedLatitude,
      selectedLongitude);

  @override
  String toString() {
    return 'PlaceFormState.loaded(categories: $categories, place: $place, autocompleteSuggestions: $autocompleteSuggestions, isAutocompleteLoading: $isAutocompleteLoading, autocompleteError: $autocompleteError, selectedAddress: $selectedAddress, selectedLatitude: $selectedLatitude, selectedLongitude: $selectedLongitude)';
  }
}

/// @nodoc
abstract mixin class $PlaceFormLoadedCopyWith<$Res>
    implements $PlaceFormStateCopyWith<$Res> {
  factory $PlaceFormLoadedCopyWith(
          PlaceFormLoaded value, $Res Function(PlaceFormLoaded) _then) =
      _$PlaceFormLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<Category> categories,
      Place? place,
      List<GooglePlace> autocompleteSuggestions,
      bool isAutocompleteLoading,
      String? autocompleteError,
      String? selectedAddress,
      double? selectedLatitude,
      double? selectedLongitude});

  $PlaceCopyWith<$Res>? get place;
}

/// @nodoc
class _$PlaceFormLoadedCopyWithImpl<$Res>
    implements $PlaceFormLoadedCopyWith<$Res> {
  _$PlaceFormLoadedCopyWithImpl(this._self, this._then);

  final PlaceFormLoaded _self;
  final $Res Function(PlaceFormLoaded) _then;

  /// Create a copy of PlaceFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categories = null,
    Object? place = freezed,
    Object? autocompleteSuggestions = null,
    Object? isAutocompleteLoading = null,
    Object? autocompleteError = freezed,
    Object? selectedAddress = freezed,
    Object? selectedLatitude = freezed,
    Object? selectedLongitude = freezed,
  }) {
    return _then(PlaceFormLoaded(
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      place: freezed == place
          ? _self.place
          : place // ignore: cast_nullable_to_non_nullable
              as Place?,
      autocompleteSuggestions: null == autocompleteSuggestions
          ? _self._autocompleteSuggestions
          : autocompleteSuggestions // ignore: cast_nullable_to_non_nullable
              as List<GooglePlace>,
      isAutocompleteLoading: null == isAutocompleteLoading
          ? _self.isAutocompleteLoading
          : isAutocompleteLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      autocompleteError: freezed == autocompleteError
          ? _self.autocompleteError
          : autocompleteError // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedAddress: freezed == selectedAddress
          ? _self.selectedAddress
          : selectedAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedLatitude: freezed == selectedLatitude
          ? _self.selectedLatitude
          : selectedLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      selectedLongitude: freezed == selectedLongitude
          ? _self.selectedLongitude
          : selectedLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of PlaceFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlaceCopyWith<$Res>? get place {
    if (_self.place == null) {
      return null;
    }

    return $PlaceCopyWith<$Res>(_self.place!, (value) {
      return _then(_self.copyWith(place: value));
    });
  }
}

/// @nodoc

class PlaceFormSaving implements PlaceFormState {
  const PlaceFormSaving();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PlaceFormSaving);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PlaceFormState.saving()';
  }
}

/// @nodoc

class PlaceFormSuccess implements PlaceFormState {
  const PlaceFormSuccess({required this.isNewPlace});

  final bool isNewPlace;

  /// Create a copy of PlaceFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlaceFormSuccessCopyWith<PlaceFormSuccess> get copyWith =>
      _$PlaceFormSuccessCopyWithImpl<PlaceFormSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlaceFormSuccess &&
            (identical(other.isNewPlace, isNewPlace) ||
                other.isNewPlace == isNewPlace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isNewPlace);

  @override
  String toString() {
    return 'PlaceFormState.success(isNewPlace: $isNewPlace)';
  }
}

/// @nodoc
abstract mixin class $PlaceFormSuccessCopyWith<$Res>
    implements $PlaceFormStateCopyWith<$Res> {
  factory $PlaceFormSuccessCopyWith(
          PlaceFormSuccess value, $Res Function(PlaceFormSuccess) _then) =
      _$PlaceFormSuccessCopyWithImpl;
  @useResult
  $Res call({bool isNewPlace});
}

/// @nodoc
class _$PlaceFormSuccessCopyWithImpl<$Res>
    implements $PlaceFormSuccessCopyWith<$Res> {
  _$PlaceFormSuccessCopyWithImpl(this._self, this._then);

  final PlaceFormSuccess _self;
  final $Res Function(PlaceFormSuccess) _then;

  /// Create a copy of PlaceFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isNewPlace = null,
  }) {
    return _then(PlaceFormSuccess(
      isNewPlace: null == isNewPlace
          ? _self.isNewPlace
          : isNewPlace // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class PlaceFormError implements PlaceFormState {
  const PlaceFormError(this.message);

  final String message;

  /// Create a copy of PlaceFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlaceFormErrorCopyWith<PlaceFormError> get copyWith =>
      _$PlaceFormErrorCopyWithImpl<PlaceFormError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlaceFormError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'PlaceFormState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $PlaceFormErrorCopyWith<$Res>
    implements $PlaceFormStateCopyWith<$Res> {
  factory $PlaceFormErrorCopyWith(
          PlaceFormError value, $Res Function(PlaceFormError) _then) =
      _$PlaceFormErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$PlaceFormErrorCopyWithImpl<$Res>
    implements $PlaceFormErrorCopyWith<$Res> {
  _$PlaceFormErrorCopyWithImpl(this._self, this._then);

  final PlaceFormError _self;
  final $Res Function(PlaceFormError) _then;

  /// Create a copy of PlaceFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(PlaceFormError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
