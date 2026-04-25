import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/src/config/router/app_route_constants.dart';
import 'package:flutter_amazon_clone_bloc/src/data/models/order.dart';
import 'package:flutter_amazon_clone_bloc/src/data/models/user.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/account/orders/widgets/tracking_details_bottom_sheet.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/account/orders/widgets/you_might_also_like_block.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/custom_app_bar.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/divider_with_sizedbox.dart';
import 'package:flutter_amazon_clone_bloc/src/utils/utils.dart';
import 'package:flutter_amazon_clone_bloc/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TrackingDetailsScreen extends StatelessWidget {
  final Order order;
  final User user;
  const TrackingDetailsScreen({super.key, required this.order, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: CustomAppBar()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user.type == 'user')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getStatus(order.status),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                getSubStatus(order.status),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () => context.pushNamed(
                                AppRouteConstants.orderDetailsScreenRoute.name,
                                extra: order),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: order.products[0].images[0],
                                height: 80,
                                width: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const DividerWithSizedBox(thickness: 0.5, sB1Height: 12),
                    UserAddressBlock(order: order, user: user),
                    const DividerWithSizedBox(thickness: 8, sB1Height: 24, sB2Height: 24),
                    Text(
                      l10n.deliveryBy,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Order ID: ${order.id}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                )
              else
                TrackingDetailsBottomSheet(order: order, user: user),
              const DividerWithSizedBox(thickness: 8, sB1Height: 24, sB2Height: 20),
              Text(
                'Order Info',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => context.pushNamed(
                    AppRouteConstants.orderDetailsScreenRoute.name,
                    extra: order),
                title: Text('View order details', style: theme.textTheme.bodyLarge),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
              const Divider(thickness: 0.5),
              const SizedBox(height: 24),
              if (user.type == 'user')
                YouMightAlsoLikeBlock(
                  productName: order.products[0].name.length >= 30
                      ? order.products[0].name.substring(0, 30)
                      : order.products[0].name,
                )
            ],
          ),
        ),
      ),
    );
  }
}

class UserAddressBlock extends StatelessWidget {
  const UserAddressBlock({super.key, required this.user, required this.order});

  final Order order;
  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.done, size: 20, color: theme.colorScheme.onSecondary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getStatus(order.status), style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(capitalizeFirstLetter(string: user.name), style: theme.textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(user.address, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: theme.colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => TrackingDetailsBottomSheet(order: order, user: user),
                  );
                },
                child: Text(
                  'See all updates',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
