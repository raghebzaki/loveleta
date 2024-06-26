import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:loveleta/core/shared/entities/product_entity.dart';
import 'package:loveleta/core/utils/extensions.dart';
import 'package:loveleta/features/payment_summary/domain/entities/place_order_entity.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../core/dependency_injection/di.dart' as di;
import '../../../../../../core/shared/models/user_data_model.dart';
import '../../../../../../core/shared/widgets/custom_app_bar.dart';
import '../../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../../core/shared/widgets/state_loading_widget.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../core/database/address_class.dart';
import '../../../../core/shared/cubits/cart_cubit/cart_cubit.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../manager/place_order_cubit.dart';

class OrderSummaryView extends StatefulWidget {
  final Address address;

  const OrderSummaryView({
    super.key,
    required this.address,
  });

  @override
  State<OrderSummaryView> createState() => _OrderSummaryViewState();
}

class _OrderSummaryViewState extends State<OrderSummaryView> {
  List<ProductEntity> products = [];

  bool isCoupon = false;
  num totalWithCoupon = 0;
  TextEditingController pinCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartCubit>().cartProducts;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).confirmOrder,
                      style: CustomTextStyle.kTextStyleF20,
                    ),
                    Gap(10.h),
                    Text(
                      S.of(context).pleaseConfirmProceedWithYourOrder,
                      style: CustomTextStyle.kTextStyleF14,
                    ),
                    Gap(15.h),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.p16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.r10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).recipientInfo,
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                            ],
                          ),
                          Gap(10.h),
                          Text(
                            "${S.of(context).name}:",
                            style: CustomTextStyle.kTextStyleF12.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          Gap(5.h),
                          Text(
                            "${UserData.firstName!} ${UserData.lastName!}",
                            style: CustomTextStyle.kTextStyleF14,
                          ),
                          Gap(10.h),
                          Text(
                            "${S.of(context).phoneNumber}:",
                            style: CustomTextStyle.kTextStyleF12.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          Gap(5.h),
                          Text(
                            UserData.phone!,
                            style: CustomTextStyle.kTextStyleF14,
                          ),
                          Gap(10.h),
                          Text(
                            "${S.of(context).address}:",
                            style: CustomTextStyle.kTextStyleF12.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          Gap(5.h),
                          Text(
                            widget.address.address!,
                            style: CustomTextStyle.kTextStyleF14,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.p16,
                                  vertical: Dimensions.p32),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Gap(35.h),
                                  Text(
                                    S.of(context).addPromoCode,
                                    style: CustomTextStyle.kTextStyleF20,
                                  ),
                                  Text(
                                    S.of(context).enterYourPromoCode,
                                    style:
                                        CustomTextStyle.kTextStyleF12.copyWith(
                                      color: AppColors.textPink,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Gap(35.h),
                                  Pinput(
                                    controller: pinCtrl,
                                    onChanged: (value) {
                                      // UserData.otp = value;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z á-ú Á-Ú 0-9]"),
                                      ),
                                    ],
                                    closeKeyboardWhenCompleted: false,
                                    onSubmitted: (value) {},
                                    keyboardType: TextInputType.text,
                                    length: 4,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    focusNode: FocusNode(),
                                    showCursor: true,
                                    defaultPinTheme: PinTheme(
                                      height: 45.h,
                                      width: 66.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.r5,
                                        ),
                                      ),
                                      textStyle: CustomTextStyle.kPinTextStyle,
                                    ),
                                  ),
                                  Gap(35.h),
                                  ConditionalBuilder(
                                      condition: true,
                                      builder: (BuildContext ctx) {
                                        return CustomBtn(
                                          label: S.of(context).applyCoupon,
                                          onPressed: () {
                                            context.pop();
                                          },
                                        );
                                      },
                                      fallback: (BuildContext ctx) {
                                        return const StateLoadingWidget();
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        S.of(context).addPromoCode,
                        style: CustomTextStyle.kTextStyleF14.copyWith(
                          color: AppColors.pinkSecondary,
                        ),
                      ),
                    ),
                    Gap(10.h),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.p16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimensions.r10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).orderSummary,
                            style: CustomTextStyle.kTextStyleF14,
                          ),
                          Gap(15.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).total,
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                              const Spacer(),
                              Text(
                                S.current.price(200.toString()),
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                            ],
                          ),
                          Gap(15.h),
                          Container(
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0x14010C0E),
                                ),
                              ),
                            ),
                          ),
                          Gap(15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).subtotal,
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                              const Spacer(),
                              Text(
                                S.current.price(200.toString()),
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                            ],
                          ),
                          Gap(15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).deliveryFee,
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                              const Spacer(),
                              Text(
                                S.current.price(200.toString()),
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                            ],
                          ),
                          Gap(15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).tax,
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                              const Spacer(),
                              Text(
                                S.current.price(200.toString()),
                                style: CustomTextStyle.kTextStyleF14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(100.h),
                  ],
                ),
              ),
            ),
            BlocProvider(
              create: (context) => di.di<PlaceOrderCubit>(),
              child: BlocConsumer<PlaceOrderCubit, PlaceOrderStates>(
                listener: (context, state) {
                  // PlaceOrderCubit placeOrderCubit = PlaceOrderCubit.get(context);
                  state.maybeWhen(
                    success: (state) {
                      // placeOrderCubit.paymentLauncher(state.paymentUrl!);
                      if (state.status == 1) {
                        context.defaultSnackBar(
                            S.of(context).orderPlacedSuccessfully);
                      } else {
                        context.defaultSnackBar(
                            S.of(context).orderFailedPleaseTryAgain);
                      }
                      // context.pushNamed(orderConfirmationPageRoute);
                      // cartItems.clear();
                    },
                    orElse: () {
                      return null;
                    },
                  );
                },
                builder: (context, state) {
                  PlaceOrderCubit placeOrderCubit =
                      PlaceOrderCubit.get(context);
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      child: CustomBtn(
                        label: S.of(context).placeOrder,
                        onPressed: () async {
                          Map productMap = {};

                          for (int i = 0; i < cartItems.length; i++) {
                            productMap =
                              {
                                "${cartItems[i].id}": {
                                  "color": cartItems[i].userColor,
                                  "quantity": "${cartItems[i].userQty}",
                                },
                              };
                          }

                          placeOrderCubit.placeOrder(PlaceOrderEntity(
                            userId: UserData.id,
                            address: widget.address.address,
                            buildingNo: widget.address.building,
                            flatNo: widget.address.flat,
                            city: widget.address.city,
                            country: widget.address.country,
                            postCode: widget.address.code,
                            products: productMap,
                          ));
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
