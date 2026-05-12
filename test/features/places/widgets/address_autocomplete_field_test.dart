import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_admin/features/places/widgets/address_autocomplete_field.dart';

GooglePlace _suggestion(String label, {String id = 'p'}) {
  return GooglePlace(
    placeId: id,
    name: label,
    formattedAddress: label,
    location: const LocationData(latitude: 0, longitude: 0),
  );
}

Future<void> _pump(
  WidgetTester tester, {
  required TextEditingController controller,
  required List<GooglePlace> suggestions,
  bool isLoading = false,
  String? errorMessage,
  ValueChanged<String>? onChanged,
  ValueChanged<GooglePlace>? onSelected,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: AddressAutocompleteField(
            controller: controller,
            suggestions: suggestions,
            isLoading: isLoading,
            errorMessage: errorMessage,
            onChanged: onChanged ?? (_) {},
            onSuggestionSelected: onSelected ?? (_) {},
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('AddressAutocompleteField', () {
    testWidgets('renderiza cada sugerencia con su formattedAddress',
        (tester) async {
      await _pump(
        tester,
        controller: TextEditingController(),
        suggestions: [
          _suggestion('Calle Obispo 123, La Habana', id: 'a'),
          _suggestion('Calle Mercaderes 45, La Habana', id: 'b'),
        ],
      );

      expect(find.text('Calle Obispo 123, La Habana'), findsOneWidget);
      expect(find.text('Calle Mercaderes 45, La Habana'), findsOneWidget);
    });

    testWidgets(
        'tap sobre una sugerencia invoca onSuggestionSelected con el GooglePlace',
        (tester) async {
      GooglePlace? selected;
      final picked = _suggestion('Calle Obispo 123, La Habana', id: 'pick');

      await _pump(
        tester,
        controller: TextEditingController(),
        suggestions: [picked],
        onSelected: (gp) => selected = gp,
      );

      await tester.tap(find.text('Calle Obispo 123, La Habana'));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.placeId, 'pick');
    });

    testWidgets('onChanged se dispara cuando el usuario tipea', (tester) async {
      String? captured;
      await _pump(
        tester,
        controller: TextEditingController(),
        suggestions: const [],
        onChanged: (value) => captured = value,
      );

      await tester.enterText(find.byType(TextFormField), 'Obispo');
      await tester.pump();

      expect(captured, 'Obispo');
    });

    testWidgets('muestra indicador de carga cuando isLoading=true',
        (tester) async {
      await _pump(
        tester,
        controller: TextEditingController(),
        suggestions: const [],
        isLoading: true,
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('muestra mensaje de error cuando errorMessage no es null',
        (tester) async {
      await _pump(
        tester,
        controller: TextEditingController(),
        suggestions: const [],
        errorMessage: 'Sin conexión',
      );

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets(
        'no renderiza ListTiles cuando suggestions está vacío y NO hay loading',
        (tester) async {
      await _pump(
        tester,
        controller: TextEditingController(),
        suggestions: const [],
      );

      expect(find.byType(ListTile), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });
}
