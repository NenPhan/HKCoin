import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/address.dart';
import 'package:hkcoin/data.repositories/checkout_repository.dart';

class AddressListController extends GetxController {
  bool isLoading = false;
  List<Address> listAddress = [];
  int? selectedAddressId;

  @override
  void onInit() {
    getAddressData();
    super.onInit();
  }

  Future getAddressData() async {
    isLoading = true;
    update(["address-list"]);
    await handleEither(await CheckoutRepository().getAddresses(), (r) {
      listAddress = r;
    });
    isLoading = false;
    update(["address-list"]);
  }

  Future<bool> selectAddress(int? id) async {
    selectedAddressId = id;
    update(["address-list"]);
    return await handleEitherReturn(
      await CheckoutRepository().selectAddress(id),
      (r) async {
        return true;
      },
      onError: (message) {
        return false;
      },
    );
  }
}
