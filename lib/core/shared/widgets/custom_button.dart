// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loveleta/core/utils/extensions.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/dimensions.dart';

class CustomBtn extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final bool isUpperCase;
  double borderRadius;
  Color? bgColor;
  Color? fgColor;
  final TextStyle? textStyle;

  CustomBtn({
    super.key,
    this.label,
    this.onPressed,
    this.isUpperCase = false,
    this.borderRadius = Dimensions.r12,
    this.fgColor = AppColors.textWhite,
    this.bgColor = AppColors.pinkPrimary,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.p16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.p10.w,
            vertical: Dimensions.p10.h,
          ),
          minimumSize: Size(
            double.infinity,
            0.07.sh,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
          ),
          backgroundColor: bgColor,
          foregroundColor: fgColor,
        ),
        child: Text(
          isUpperCase ? label.isNullOrEmpty().toUpperCase() : label.isNullOrEmpty(),
          style: textStyle ?? CustomTextStyle.kBtnTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
