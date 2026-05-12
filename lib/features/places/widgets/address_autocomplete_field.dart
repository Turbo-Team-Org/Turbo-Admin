import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Campo de dirección con autocompletado servido por `LocationRepository`.
///
/// Es un widget **presentacional puro**: recibe las sugerencias y callbacks
/// desde el exterior (típicamente un `PlaceFormCubit`) y no conoce nada del
/// proveedor (Google Places). Eso lo hace barato de testear y reutilizable.
class AddressAutocompleteField extends StatelessWidget {
  const AddressAutocompleteField({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.onChanged,
    required this.onSuggestionSelected,
    this.isLoading = false,
    this.errorMessage,
    this.labelText = 'Buscar dirección',
    this.hintText = 'Ej: Calle Obispo, La Habana',
    this.maxSuggestionsHeight = 240,
  });

  final TextEditingController controller;
  final List<GooglePlace> suggestions;
  final ValueChanged<String> onChanged;
  final ValueChanged<GooglePlace> onSuggestionSelected;
  final bool isLoading;
  final String? errorMessage;
  final String labelText;
  final String hintText;
  final double maxSuggestionsHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: LinearProgressIndicator(minHeight: 2),
          ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        if (suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxSuggestionsHeight),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    final hasFormatted =
                        suggestion.formattedAddress.trim().isNotEmpty;
                    final primary = hasFormatted
                        ? suggestion.formattedAddress
                        : suggestion.name;
                    final secondary = hasFormatted &&
                            suggestion.name.isNotEmpty &&
                            suggestion.name != suggestion.formattedAddress
                        ? suggestion.name
                        : null;
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(
                        primary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: secondary == null
                          ? null
                          : Text(
                              secondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      onTap: () => onSuggestionSelected(suggestion),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
