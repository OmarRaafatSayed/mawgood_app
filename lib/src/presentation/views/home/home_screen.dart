import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/admin/admin_add_offers/four-images-offer/admin_four_image_offer_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/home_blocs/carousel_bloc/carousel_image_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/user_cubit/user_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/custom_app_bar.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/home/address_bar.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/home/carousel_image.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/home/deal_of_the_day.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/home/multi_image_offer.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/home/top_categories.dart';
import 'package:flutter_amazon_clone_bloc/src/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CarouselImageBloc>().add(ResetCarouselEvent());
    context.read<AdminFourImageOfferCubit>().adminGetFourImagesOffer(isUser: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserSuccessS && state.user.address.isNotEmpty) {
                  return const AddressBar();
                }
                return const SizedBox();
              },
            ),
            const TopCategories(),
            const CarouselImage(),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DealOfTheDay(),
                    const SizedBox(height: 16),
                    BlocConsumer<AdminFourImageOfferCubit, AdminFourImageOfferState>(
                      listener: (context, state) {
                        if (state is AdminFourImageOfferErrorS) {
                          showSnackBar(context, state.errorString);
                        }
                      },
                      builder: (context, state) {
                        if (state is AdminGetFourImageOfferSuccessS) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.fourImagesOfferList.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final offer = state.fourImagesOfferList[index];
                              return MultiImageOffer(
                                title: offer.title,
                                category: offer.category,
                                images: offer.images,
                                labels: offer.labels,
                              );
                            },
                          );
                        }
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(color: theme.colorScheme.primary),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
