import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/src/config/router/app_route_constants.dart';
import 'package:flutter_amazon_clone_bloc/src/data/models/product.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_offers_cubit1/cart_offers_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_offers_cubit2/cart_offers_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_offers_cubit3/cart_offers_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/cart/add_to_card_offer.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/cart/mawgood_pay_banner_ad.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/cart/cart_icon.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/cart/cart_product.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/cart/save_for_later_single.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/cart/swipe_container.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/custom_app_bar.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/custom_elevated_button.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/divider_with_sizedbox.dart';
import 'package:flutter_amazon_clone_bloc/src/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_amazon_clone_bloc/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> getCartOffers(BuildContext context) async {
    List<String> categories =
        await BlocProvider.of<CartOffersCubit1>(context).setOfferCategories();
    if (!context.mounted) return;
    BlocProvider.of<CartOffersCubit1>(context)
        .cartOffers1(category: categories[0]);
    BlocProvider.of<CartOffersCubit2>(context)
        .cartOffers2(category: categories[1]);
    BlocProvider.of<CartOffersCubit3>(context)
        .cartOffers3(category: categories[2]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    context.read<CartBloc>().add(GetCartPressed());
    getCartOffers(context);

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: CustomAppBar()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<CartBloc, CartState>(
              listener: (context, state) {
                if (state is CartProductErrorS) {
                  showSnackBar(context, state.errorString);
                }
              },
              builder: (context, state) {
                if (state is CartLoadingS) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height - 180,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is CartProductSuccessS) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: state.cartProducts.isEmpty
                            ? _buildEmptyCart(context, l10n, theme)
                            : _buildCartContent(context, state, l10n, theme),
                      ),
                      if (state.cartProducts.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.cartProducts.length,
                          itemBuilder: (context, index) {
                            final product = state.cartProducts[index];
                            final quantity = state.productsQuantity[index];
                            return _buildCartItem(context, product, quantity, theme);
                          },
                        ),
                      const DividerWithSizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const CartIcon(iconName: 'secure_payment.png', title: 'Secure Payment'),
                          CartIcon(iconName: 'delivered_alt.png', title: l10n.appDelivered),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const MawgoodPayBannerAd(),
                      if (state.saveForLaterProducts.isNotEmpty)
                        _buildSaveForLater(context, state, l10n, theme),
                      const SizedBox(height: 16),
                      _buildRecommendations(context, l10n, theme),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/empty_cart.png',
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            l10n.cartEmpty,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartProductSuccessS state, AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('SubTotal ', style: theme.textTheme.titleLarge),
            Text('₹', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
            Text(
              formatPriceWithDecimal(state.total),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        CustomElevatedButton(
          buttonText: 'Proceed to Buy (${state.cartProducts.length} ${state.cartProducts.length == 1 ? 'item' : 'items'})',
          onPressed: () {
            context.pushNamed(AppRouteConstants.paymentScreenRoute.name, extra: state.total);
          },
          isRectangle: true,
        ),
        const DividerWithSizedBox(thickness: 0.5, sB1Height: 20),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, Product product, int quantity, ThemeData theme) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          context.read<CartBloc>().add(DeleteFromCart(product: product));
          showSnackBar(context, 'Deleted!');
        } else {
          context.read<CartBloc>().add(SaveForLaterE(product: product));
          showSnackBar(context, 'Saved for later!');
        }
      },
      background: const SwipeContainer(isDelete: true, secondaryBackgroundText: 'Save for later'),
      secondaryBackground: const SwipeContainer(isDelete: false, secondaryBackgroundText: 'Save for later'),
      child: InkWell(
        onTap: () => context.pushNamed(AppRouteConstants.productDetailsScreenRoute.name, extra: {
          "product": product,
          "deliveryDate": getDeliveryDate(),
        }),
        child: CartProduct(quantity: quantity, product: product),
      ),
    );
  }

  Widget _buildSaveForLater(BuildContext context, CartProductSuccessS state, AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: const EdgeInsets.symmetric(vertical: 16), color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3), height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Saved for later (${state.saveForLaterProducts.length} ${state.saveForLaterProducts.length == 1 ? 'item' : 'items'})',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.saveForLaterProducts.length,
          itemBuilder: (context, index) {
            final product = state.saveForLaterProducts[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  context.read<CartBloc>().add(DeleteFromLaterE(product: product));
                } else {
                  context.read<CartBloc>().add(MoveToCartE(product: product));
                }
              },
              background: const SwipeContainer(isDelete: true, secondaryBackgroundText: 'Move to cart'),
              secondaryBackground: const SwipeContainer(isDelete: false, secondaryBackgroundText: 'Move to cart'),
              child: InkWell(
                onTap: () => context.pushNamed(AppRouteConstants.productDetailsScreenRoute.name, extra: {
                  "product": product,
                  "deliveryDate": getDeliveryDate(),
                }),
                child: SaveForLaterSingle(product: product),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Column(
      children: [
        BlocBuilder<CartOffersCubit1, CartOffersState1>(
          builder: (context, state) => state is CartOffersSuccessS1 && state.productList.isNotEmpty
              ? AddToCartWidget(title: 'Top picks for you', isTitleLong: false, productList: state.productList, averageRating: state.averageRatingList)
              : const SizedBox(),
        ),
        BlocBuilder<CartOffersCubit2, CartOffersState2>(
          builder: (context, state) => state is CartOffersSuccessS2 && state.productList.isNotEmpty
              ? AddToCartWidget(title: 'Frequently viewed together', isTitleLong: true, productList: state.productList, averageRating: state.averageRatingList)
              : const SizedBox(),
        ),
        BlocBuilder<CartOffersCubit3, CartOffersState3>(
          builder: (context, state) => state is CartOffersSuccessS3 && state.productList.isNotEmpty
              ? AddToCartWidget(title: 'Recommendations for you', isTitleLong: false, productList: state.productList, averageRating: state.averageRatingList)
              : const SizedBox(),
        ),
      ],
    );
  }
}

class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({super.key, required this.productList, required this.averageRating, required this.title, required this.isTitleLong});
  final List<Product>? productList;
  final List<double>? averageRating;
  final String title;
  final bool isTitleLong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: theme.colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: productList!.length > 20 ? 20 : productList!.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => AddToCartOffer(product: productList![index], averageRating: averageRating![index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
