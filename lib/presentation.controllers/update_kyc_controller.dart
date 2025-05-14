import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/country.dart';
import 'package:hkcoin/data.models/kyc_info.dart';
import 'package:hkcoin/data.models/kyc_status.dart';
import 'package:hkcoin/data.models/params/update_kyc_param.dart';
import 'package:hkcoin/data.repositories/kyc_repository.dart';
import 'package:hkcoin/data.repositories/util_repository.dart';

class UpdateKycController extends GetxController {
  List<IdentificationCardType> iCardTypes = [
    IdentificationCardType(
      id: 0,
      name: tr("Enums.IdentificationCardType.Passport"),
    ),
    IdentificationCardType(
      id: 1,
      name: tr("Enums.IdentificationCardType.Identification"),
    ),
  ];
  final formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cidController = TextEditingController();

  RxBool isLoadingSaveButton = false.obs;
  RxBool canSave = false.obs;
  bool isLoading = false;
  bool verifyKyc = false;

  List<Country> listCountry = [];
  KycStatus? kycStatus;
  Country? selectedCountry;
  IdentificationCardType? selectedICardType;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  Future initData() async {
    isLoading = true;
    update(["update-kyc-page"]);
    await getKycStatus();
    isLoading = false;
    update(["update-kyc-page"]);
    validate();
  }

  Future getKycStatus() async {
    await handleEitherReturn(await KycRepository().getKycStatus(), (r) async {
      kycStatus = r;
      switch (kycStatus?.nextStep) {
        case "Infomation":
          await getData();
          break;
        case "Complete":
          await getData();
          break;
        default:
      }
    });
  }

  Future getData() async {
    await getCountry();
    await getKycInfo();
  }

  Future getKycInfo() async {
    handleEither(await KycRepository().getKycInfo(), (r) {
      fNameController.text = r.firstName ?? "";
      lNameController.text = r.lastName ?? "";
      phoneController.text = r.phone ?? "";
      cidController.text = r.identificationCardNumber ?? "";
      if (r.countryId != null) {
        var item = listCountry.where((e) => e.id == r.countryId).firstOrNull;
        if (item != null) {
          selectedCountry = item;
        }
      }
      if (r.identificationCardTypeId != null) {
        var item =
            iCardTypes
                .where((e) => e.id == r.identificationCardTypeId)
                .firstOrNull;
        if (item != null) {
          selectedICardType = item;
        }
      }
      verifyKyc = r.verifyKyc ?? false;
    });
  }

  Future getCountry() async {
    if (listCountry.isEmpty) {
      await handleEither(await UtilRepository().getCountries(), (r) {
        listCountry = r;
        listCountry.sort((a, b) => a.name.compareTo(b.name));
        int i = listCountry.indexWhere((e) => e.id == 230);
        var item = listCountry[i];
        listCountry.removeAt(i);
        listCountry.insert(0, item);
        selectedCountry = listCountry.first;
      });
    }
  }

  Future updateKycInfo() async {
    isLoadingSaveButton.value = true;
    await handleEitherReturn(
      await KycRepository().updateKycInfo(
        UpdateKycParam(
          firstName: fNameController.text.trim(),
          lastName: lNameController.text.trim(),
          phone: phoneController.text.trim(),
          identificationCardNumber: cidController.text.trim(),
          identificationCardTypeId: selectedICardType?.id,
          countryId: selectedCountry?.id,
        ),
      ),
      (r) async {
        initData();
      },
    );

    isLoadingSaveButton.value = false;
  }

  kycValidatePhoto({required String name, required File file}) async {
    await handleEitherReturn(
      await KycRepository().kycValidate(name: name, file: file),
      (r) async {
        await initData();
      },
    );
  }

  validate() {
    canSave.value =
        fNameController.text.trim() != "" &&
        lNameController.text.trim() != "" &&
        phoneController.text.trim() != "" &&
        cidController.text.trim() != "" &&
        selectedICardType != null &&
        selectedCountry != null;
  }
}
