import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/bottom_bar/bottom_bar_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/cart/cart_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/user_cubit/user_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/views/account/account_screen.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/views/another_screen.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/views/cart/cart_screen.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/views/home/home_screen.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/views/menu/menu_screen.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/bottom_bar/custom_bottom_nav_bar.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/bottom_bar/custom_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_amazon_clone_bloc/l10n/generated/app_localizations.dart';

// ignore: must_be_immutable
class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  final List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const AnotherScreen(appBarTitle: 'More Screen'),
    const CartScreen(),
    const MenuScreen(),
  ];

  int lastIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    context.read<UserCubit>().getUserData();
    context.read<CartBloc>().add(GetCartPressed());

    return BlocBuilder<BottomBarBloc, BottomBarState>(
      builder: (context, state) {
        bool isOpen = false;
        int currentIndex = 0;

        if (state is BottomBarMoreClickedState) {
          isOpen = state.isOpen;
          currentIndex = state.index;
        } else if (state is BottomBarPageState) {
          currentIndex = state.index;
        }

        return Scaffold(
          body: Stack(
            children: [
              pages[currentIndex == 2 ? lastIndex : currentIndex],
              if (isOpen)
                GestureDetector(
                  onTap: () {
                    context.read<BottomBarBloc>().add(BottomBarMoreClickedEvent(currentIndex, false));
                    context.read<BottomBarBloc>().add(BottomBarClickedEvent(index: lastIndex));
                  },
                  child: Container(color: Colors.black54),
                ),
            ],
          ),
          bottomSheet: isOpen
              ? BottomSheet(
                  backgroundColor: theme.colorScheme.surface,
                  dragHandleColor: theme.colorScheme.outlineVariant,
                  dragHandleSize: const Size(50, 4),
                  enableDrag: false,
                  showDragHandle: true,
                  constraints: const BoxConstraints(minHeight: 400, maxHeight: 400),
                  onClosing: () {},
                  builder: (context) => const CustomBottomSheet(),
                )
              : null,
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            bottomNavBarList: _buildItems(context, currentIndex, l10n, theme),
            onTap: (page) {
              if (page == 2) {
                context.read<BottomBarBloc>().add(BottomBarMoreClickedEvent(page, !isOpen));
              } else {
                lastIndex = page;
                context.read<BottomBarBloc>().add(BottomBarClickedEvent(index: page));
              }
            },
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> _buildItems(BuildContext context, int index, AppLocalizations l10n, ThemeData theme) {
    return [
      _bottomNavBarItem(context, index: index, iconName: 'home', page: 0, label: l10n.home, theme: theme),
      _bottomNavBarItem(context, index: index, iconName: 'you', page: 1, label: l10n.account, theme: theme),
      _bottomNavBarItem(context, index: index, iconName: 'more', page: 2, label: l10n.menu, theme: theme), // 'More' mapped to Menu/More
      _bottomNavBarItem(context, index: index, iconName: 'cart', page: 3, label: l10n.cart, theme: theme),
      _bottomNavBarItem(context, index: index, iconName: 'menu', page: 4, label: l10n.menu, theme: theme),
    ];
  }

  BottomNavigationBarItem _bottomNavBarItem(
    BuildContext context, {
    required String iconName,
    required int page,
    required int index,
    required String label,
    required ThemeData theme,
  }) {
    final bool isSelected = index == page;
    final Color iconColor = isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;

    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: isSelected && index != 2 ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
            ),
          ),
          const SizedBox(height: 6),
          if (page == 3)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/images/bottom_nav_bar/$iconName.png',
                  height: 24,
                  width: 24,
                  color: iconColor,
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state is CartProductSuccessS && state.cartProducts.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            state.cartProducts.length.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            )
          else
            Image.asset(
              'assets/images/bottom_nav_bar/$iconName.png',
              height: 24,
              width: 24,
              color: iconColor,
            ),
          const SizedBox(height: 4),
        ],
      ),
      label: label,
    );
  }
}
