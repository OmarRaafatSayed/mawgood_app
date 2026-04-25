import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/src/config/router/app_route_constants.dart';
import 'package:flutter_amazon_clone_bloc/src/utils/constants/constants.dart';
import 'package:flutter_amazon_clone_bloc/src/utils/utils.dart';
import 'package:flutter_amazon_clone_bloc/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

class BottomOffers extends StatelessWidget {
  const BottomOffers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 180,
      width: width,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: Constants.bottomOfferImages.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final offer = Constants.bottomOfferImages[index];
          final category = offer['category']!;
          final imageUrl = offer['image']!;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                if (category == 'MawgoodPay') {
                  showSnackBar(context, '${l10n.appName} Pay coming soon!');
                } else {
                  context.pushNamed(
                    AppRouteConstants.categoryproductsScreenRoute.name,
                    pathParameters: {'category': category},
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 150,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
