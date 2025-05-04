import 'package:get/get.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/data.models/cart.dart';
import 'package:hkcoin/data.models/checkout_data.dart';
import 'package:hkcoin/data.models/order_total.dart';
import 'package:hkcoin/data.repositories/checkout_repository.dart';

class CheckoutController extends GetxController {
  bool isCheckingOut = false;
  CheckoutData? data;
  Cart? cart;
  OrderTotal? orderTotal;

  @override
  void onInit() {
    getCheckoutData();
    getCartData();
    getOrderTotal();
    super.onInit();
  }

  Future getCheckoutData() async {
    await handleEither(await CheckoutRepository().getCheckoutData(), (r) {
      data = r;
    });
    update(["checkout"]);
  }

  Future getCartData() async {
    await handleEither(await CheckoutRepository().getCart(), (r) {
      cart = r;
    });
    update(["checkout"]);
  }

  Future selectPaymentMethod(String? methodName) async {
    update(["checkout"]);
    await handleEither(
      await CheckoutRepository().selectPaymmentMethod(methodName),
      (r) {},
    );
    update(["checkout"]);
  }

  Future<bool> checkoutComplete() async {
    if (data != null) {
      isCheckingOut = true;
      update(["checkout-button"]);
      await handleEither(
        await CheckoutRepository().checkout(
          data?.existingAddresses?.id,
          data?.paymentMethod?.paymentMethods
              ?.where((e) => e.selected ?? false)
              .firstOrNull
              ?.paymentMethodSystemName,
        ),
        (r) {
          return true;
        },
      );
      isCheckingOut = false;
      update(["checkout-button"]);
    }
    return false;
  }

  Future getOrderTotal() async {
    await handleEither(await CheckoutRepository().getOrderTotal(), (r) {
      orderTotal = r;
    });
    update(["checkout"]);
  }
}
