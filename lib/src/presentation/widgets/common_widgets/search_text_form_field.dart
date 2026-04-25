import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/l10n/generated/app_localizations.dart';

class SearchTextFormField extends StatelessWidget {
  const SearchTextFormField({super.key, required this.onTapSearchField});

  final Function(String)? onTapSearchField;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final OutlineInputBorder textFieldStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
    );

    return TextFormField(
      onFieldSubmitted: onTapSearchField,
      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
      cursorColor: theme.colorScheme.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface,
        hintText: '${l10n.appName}...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        constraints: const BoxConstraints(maxHeight: 45, minHeight: 45),
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        focusedBorder: textFieldStyle.copyWith(
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        enabledBorder: textFieldStyle,
        border: textFieldStyle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        suffixIcon: SizedBox(
          width: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.center_focus_strong_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.mic_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
