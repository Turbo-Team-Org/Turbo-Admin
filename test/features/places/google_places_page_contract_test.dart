import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('google-places-api RED contract', () {
    late String source;

    setUpAll(() {
      source = File('lib/features/places/pages/place_form_page.dart')
          .readAsStringSync();
    });

    test('PlaceFormPage should not hardcode Google API key', () {
      // Arrange-Act already done in setUpAll

      // Assert
      expect(
        source.contains('AIza'),
        isFalse,
        reason: 'La API key debe venir desde configuracion segura, no hardcodeada',
      );
    });

    test('PlaceFormPage should not call Google Places endpoint directly', () {
      // Arrange-Act already done in setUpAll

      // Assert
      expect(
        source.contains('maps.googleapis.com/maps/api/place'),
        isFalse,
        reason: 'La UI debe delegar llamadas de Places al Core/Repository',
      );
    });
  });
}
