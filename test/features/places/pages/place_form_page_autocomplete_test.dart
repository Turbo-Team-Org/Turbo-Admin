import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Test de contrato que garantiza que `PlaceFormPage` ya **no** depende de las
/// APIs web legacy (`dart:html`, `dart:js`, `dart:ui_web`, `initPlacesAutocomplete`)
/// y que el autocompletado se resuelve por el cubit + `LocationRepository` del
/// core en lugar del JS embebido en `web/index.html`.
///
/// Mantiene además el contrato previo: sin `AIza` ni URL directa a la Places API.
void main() {
  group('PlaceFormPage · Refactor autocomplete (contract)', () {
    late String source;

    setUpAll(() {
      source = File('lib/features/places/pages/place_form_page.dart')
          .readAsStringSync();
    });

    test('no debe importar dart:html', () {
      expect(
        source.contains("import 'dart:html'"),
        isFalse,
        reason: 'El autocompletado debe usar Flutter + Cubit, no APIs web puras',
      );
    });

    test('no debe importar dart:js', () {
      expect(
        source.contains("import 'dart:js'"),
        isFalse,
        reason: 'No se permite interop JS directo desde la UI',
      );
    });

    test('no debe importar dart:ui_web', () {
      expect(
        source.contains("import 'dart:ui_web'"),
        isFalse,
        reason: 'No debe registrar viewFactories para el input legacy',
      );
    });

    test('no debe usar la función JS global initPlacesAutocomplete', () {
      expect(
        source.contains('initPlacesAutocomplete'),
        isFalse,
        reason: 'La integración con Places debe pasar por LocationRepository',
      );
    });

    test('no debe suscribirse a html.window.onMessage', () {
      expect(
        source.contains('html.window.onMessage'),
        isFalse,
        reason: 'No debe quedar puente postMessage para Places',
      );
    });

    test('no debe usar HtmlElementView para el autocomplete', () {
      expect(
        source.contains('HtmlElementView'),
        isFalse,
        reason: 'El input de dirección debe ser un TextFormField Flutter',
      );
    });

    test('no debe hardcodear la API key (AIza...) ni el endpoint /maps/api/place',
        () {
      expect(source.contains('AIza'), isFalse);
      expect(source.contains('maps.googleapis.com/maps/api/place'), isFalse);
    });
  });
}
