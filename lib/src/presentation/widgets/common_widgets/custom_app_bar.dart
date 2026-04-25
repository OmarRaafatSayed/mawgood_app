import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/src/config/router/app_route_constants.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/search_text_form_field.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      title: SearchTextFormField(
        onTapSearchField: (String query) {
          context.pushNamed(
            AppRouteConstants.searchScreenRoute.name,
            pathParameters: {'searchQuery': query},
          );
        },
      ),
    );
  }
}
