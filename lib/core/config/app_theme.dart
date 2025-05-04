import 'package:flutter/material.dart';
import 'package:hkcoin/gen/colors.gen.dart';
import 'package:hkcoin/gen/fonts.gen.dart';

TextTheme textTheme(context) => Theme.of(context).textTheme;
TextStyle? defaultStyle(context) => Theme.of(context).textTheme.bodyMedium;
ThemeData theme(context) => Theme.of(context);
Size scrSize(context) => MediaQuery.of(context).size;
EdgeInsets viewPadding(context) => MediaQuery.of(context).viewPadding;
double avgSize(context) =>
    (MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) /
    2;

class AppThemes {
  static darkTheme(BuildContext context) {
    var size = avgSize(context);
    return ThemeData.dark().copyWith(
      // primarySwatch: getMaterialColor(AppColors.orangeList[0]),
      primaryColor: AppColor.main01,
      scaffoldBackgroundColor: Colors.black,
      cardColor: AppColor.main01,
      // appBarTheme: AppBarTheme(
      //   systemOverlayStyle:
      //       SystemUiOverlayStyle(statusBarColor: AppColor.main01, statusBarIconBrightness: Brightness.dark),
      // ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(size * 0.02),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(size * 0.02),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(size * 0.02),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(size * 0.02),
        ),
        filled: true,
        labelStyle: TextStyle(
          fontSize: size * 0.024, //14
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: FontFamily.googleSans,
        ),
        hintStyle: TextStyle(
          fontSize: size * 0.024, //14
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
          fontFamily: FontFamily.googleSans,
        ),
        fillColor: Colors.grey[900],
        contentPadding: EdgeInsets.symmetric(
          vertical: scrSize(context).height * 0.015,
          horizontal: scrSize(context).width * 0.02,
        ),
      ),
      textTheme: TextTheme(
        bodySmall: TextStyle(
          fontSize: size * 0.019, //12
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: FontFamily.googleSans,
        ),
        //Default text style
        bodyMedium: TextStyle(
          fontSize: size * 0.023, //14
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: FontFamily.googleSans,
        ),
        //Default content of textfield style
        bodyLarge: TextStyle(
          fontSize: size * 0.026, //17
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: FontFamily.googleSans,
        ),
        titleSmall: TextStyle(
          fontSize: size * 0.028, //16
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: size * 0.03, //20
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: size * 0.034, //25
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      extensions: [
        // AppColors(splashBgr: AppColors.orangeDark, headerColor: MyColor.grayLight)
      ],
    );
  }

  static lightTheme(BuildContext context) {
    var size = avgSize(context);
    return ThemeData.light().copyWith(
      primaryColor: AppColor.main01,
      colorScheme: const ColorScheme.light().copyWith(primary: AppColor.main01),
      scaffoldBackgroundColor: Colors.white,
      cardColor: AppColor.main01,
      // appBarTheme: AppBarTheme(
      //   surfaceTintColor: Colors.grey,
      //   systemOverlayStyle:
      //       SystemUiOverlayStyle(statusBarColor: AppColor.main01, statusBarIconBrightness: Brightness.light),
      // ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: Colors.grey[300],
        selectionHandleColor: AppColor.main01,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
          borderRadius: BorderRadius.circular(size * 0.02),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(size * 0.02),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(size * 0.02),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(size * 0.02),
        ),
        filled: true,
        labelStyle: TextStyle(
          fontSize: size * 0.024, //14
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: FontFamily.googleSans,
        ),
        hintStyle: TextStyle(
          fontSize: size * 0.024, //14
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          fontFamily: FontFamily.googleSans,
        ),
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: scrSize(context).height * 0.015,
          horizontal: scrSize(context).width * 0.02,
        ),
      ),
      textTheme: TextTheme(
        bodySmall: TextStyle(
          fontSize: size * 0.019, //12
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: FontFamily.googleSans,
        ),
        //Default text style
        bodyMedium: TextStyle(
          fontSize: size * 0.023, //14
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: FontFamily.googleSans,
        ),
        //Default content of textfield style
        bodyLarge: TextStyle(
          fontSize: size * 0.026, //17
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: FontFamily.googleSans,
        ),
        titleSmall: TextStyle(
          fontSize: size * 0.028, //16
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontSize: size * 0.03, //20
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: size * 0.034, //25
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      extensions: [
        // AppColors(splashBgr: Colors.blue, headerColor: MyColor.grayLight),
        // AppSizes(
        //     appPadding: scrSize(context).width * 0.05,
        //     homeBottomPadding: scrSize(context).height * 0.07)
      ],
      //Using extension
      //Step 1: add custom color to AppColors class
      //Step 2: define that color in Theme Ex.: extensions: [AppColors(splashBgr: Colors.blue)],
      //Step 3: use it in UI Ex.: theme(context).extension<AppColors>()?.splashBgr
    );
  }
}
