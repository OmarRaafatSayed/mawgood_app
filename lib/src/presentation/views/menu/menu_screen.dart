import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/src/config/router/app_route_constants.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/custom_app_bar.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/custom_text_button.dart';
import 'package:flutter_amazon_clone_bloc/src/utils/constants/constants.dart';
import 'package:flutter_amazon_clone_bloc/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/menu/container_clipper.dart';

class MenuScreen extends StatelessWidget {
  static const String routeName = '/menu-screen';
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: CustomAppBar()),
      bottomSheet: Container(
        height: 80,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomTextButton(
                buttonText: l10n.orders,
                onPressed: () => context.pushNamed(AppRouteConstants.yourOrdersScreenRoute.name),
                isMenuScreenButton: true),
            CustomTextButton(
                buttonText: l10n.history,
                onPressed: () => context.pushNamed(AppRouteConstants.browsingHistoryScreenRoute.name),
                isMenuScreenButton: true),
            CustomTextButton(
                buttonText: l10n.account,
                onPressed: () {},
                isMenuScreenButton: true),
            CustomTextButton(
                buttonText: l10n.wishList,
                onPressed: () => context.pushNamed(AppRouteConstants.yourWishListScreenRoute.name),
                isMenuScreenButton: true),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
        ),
        child: GridView.builder(
            itemCount: Constants.menuScreenImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              final category = Constants.menuScreenImages[index];
              return MenuCategoryContainer(
                title: category['title']!,
                category: category['category']!,
                imageLink: category['image']!,
              );
            }),
      ),
    );
  }
}

class MenuCategoryContainer extends StatelessWidget {
  const MenuCategoryContainer({
    super.key,
    required this.title,
    required this.imageLink,
    required this.category,
  });

  final String title;
  final String imageLink;
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.pushNamed(
          AppRouteConstants.categoryproductsScreenRoute.name,
          pathParameters: {'category': category}),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ClipPath(
                clipper: ContainerClipper(),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: imageLink,
                      height: 80,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const SizedBox(height: 80),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
