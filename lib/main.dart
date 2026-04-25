import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amazon_clone_bloc/src/config/router/router.dart';
import 'package:flutter_amazon_clone_bloc/src/config/themes/app_theme.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/account_repository.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/admin_repository.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/auth_repository.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/category_products_repository.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/products_repository.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/user_repository.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/account/fetch_account_screen_data/fetch_account_screen_data_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/account/fetch_orders/fethc_orders_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/account/keep_shopping_for/cubit/keep_shopping_for_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/account/product_rating/product_rating_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/account/wish_list/wish_list_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/admin/admin_add_offers/four-images-offer/admin_four_image_offer_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/admin/admin_add_products/sell_product_cubit/admin_sell_product_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/admin/admin_bottom_bar_cubit/admin_bottom_bar_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/admin/admin_change_order_status/admin_change_order_status_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/admin/admin_fetch_category_products/admin_fetch_category_products_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/admin/admin_fetch_orders/admin_fetch_orders_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/admin/admin_get_analytics/admin_get_analytics_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/auth_bloc/radio_bloc/radio_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/bottom_bar/bottom_bar_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_offers_cubit1/cart_offers_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_offers_cubit2/cart_offers_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_offers_cubit3/cart_offers_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/category_products/fetch_category_products_bloc/fetch_category_products_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/home_blocs/carousel_bloc/carousel_image_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/home_blocs/deal_of_the_day/deal_of_the_day_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/order/order_cubit/order_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/order/place_order_buy_now/place_order_buy_now_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/page_redirection_cubit/page_redirection_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/product_details/averageRating/average_rating_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/product_details/user_rating/user_rating_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/search/bloc/search_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/user_cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // Ensures that the Flutter binding is initialized before any Flutter-specific code is run.
  WidgetsFlutterBinding.ensureInitialized();

  // Restricts the app to portrait mode.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initializes HydratedBloc for state persistence.
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

  // Loads environment variables from the .env file.
  await dotenv.load(fileName: "config.env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiRepositoryProvider to provide repository instances to the widget tree.
    // This decouples the repositories from the Blocs and makes them easily mockable for tests.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
        RepositoryProvider<UserRepository>(create: (context) => UserRepository()),
        RepositoryProvider<ProductsRepository>(
            create: (context) => ProductsRepository()),
        RepositoryProvider<AccountRepository>(
            create: (context) => AccountRepository()),
        RepositoryProvider<AdminRepository>(create: (context) => AdminRepository()),
        RepositoryProvider<CategoryProductsRepository>(
            create: (context) => CategoryProductsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          // Blocs are now created using the repositories provided by MultiRepositoryProvider.
          // This follows the dependency injection principle.
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
          BlocProvider<RadioBloc>(create: (context) => RadioBloc()),
          BlocProvider<UserCubit>(
            create: (context) => UserCubit(context.read<UserRepository>()),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(context.read<UserRepository>()),
          ),
          BlocProvider<PageRedirectionCubit>(
            create: (context) =>
                PageRedirectionCubit(context.read<AuthRepository>()),
          ),
          BlocProvider<BottomBarBloc>(create: (context) => BottomBarBloc()),
          BlocProvider<CarouselImageBloc>(
              create: (context) => CarouselImageBloc()),
          BlocProvider<FetchCategoryProductsBloc>(
            create: (context) => FetchCategoryProductsBloc(
                context.read<CategoryProductsRepository>()),
          ),
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(context.read<ProductsRepository>()),
          ),
          BlocProvider<FetchAccountScreenDataCubit>(
            create: (context) =>
                FetchAccountScreenDataCubit(context.read<UserRepository>()),
          ),
          BlocProvider<FetchOrdersCubit>(
            create: (context) =>
                FetchOrdersCubit(context.read<AccountRepository>()),
          ),
          BlocProvider<ProductRatingBloc>(
            create: (context) =>
                ProductRatingBloc(context.read<AccountRepository>()),
          ),
          BlocProvider<KeepShoppingForCubit>(
            create: (context) =>
                KeepShoppingForCubit(context.read<AccountRepository>()),
          ),
          BlocProvider<WishListCubit>(
            create: (context) => WishListCubit(
                accountRepository: context.read<AccountRepository>(),
                userRepository: context.read<UserRepository>()),
          ),
          BlocProvider<UserRatingCubit>(
            create: (context) =>
                UserRatingCubit(context.read<AccountRepository>()),
          ),
          BlocProvider<CartOffersCubit1>(
              create: (context) =>
                  CartOffersCubit1(context.read<AccountRepository>())),
          BlocProvider<CartOffersCubit2>(
              create: (context) =>
                  CartOffersCubit2(context.read<AccountRepository>())),
          BlocProvider<CartOffersCubit3>(
              create: (context) =>
                  CartOffersCubit3(context.read<AccountRepository>())),
          BlocProvider<OrderCubit>(
            create: (context) => OrderCubit(context.read<UserRepository>()),
          ),
          BlocProvider<PlaceOrderBuyNowCubit>(
            create: (context) =>
                PlaceOrderBuyNowCubit(context.read<UserRepository>()),
          ),
          BlocProvider<AverageRatingCubit>(
            create: (context) =>
                AverageRatingCubit(context.read<AccountRepository>()),
          ),
          BlocProvider<AdminBottomBarCubit>(
              create: (context) => AdminBottomBarCubit()),
          BlocProvider<AdminFetchCategoryProductsBloc>(
            create: (context) =>
                AdminFetchCategoryProductsBloc(context.read<AdminRepository>()),
          ),
          BlocProvider<AdminFetchOrdersCubit>(
            create: (context) =>
                AdminFetchOrdersCubit(context.read<AdminRepository>()),
          ),
          BlocProvider<AdminChangeOrderStatusCubit>(
            create: (context) =>
                AdminChangeOrderStatusCubit(context.read<AdminRepository>()),
          ),
          BlocProvider<AdminGetAnalyticsCubit>(
            create: (context) =>
                AdminGetAnalyticsCubit(context.read<AdminRepository>()),
          ),
          BlocProvider<AdminSellProductCubit>(
            create: (context) =>
                AdminSellProductCubit(context.read<AdminRepository>()),
          ),
          BlocProvider<AdminFourImageOfferCubit>(
            create: (context) =>
                AdminFourImageOfferCubit(context.read<AdminRepository>()),
          ),
          BlocProvider<DealOfTheDayCubit>(
            create: (context) =>
                DealOfTheDayCubit(context.read<ProductsRepository>()),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
        ),
      ),
    );
  }
}
