import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/cart.dart';
import 'package:hkcoin/data.repositories/checkout_repository.dart';

class CartController extends GetxController {
  Cart? cart;
  bool isAddingToCart = false;
  bool isLoadingCart = false;

  void getCartData() async {
    isAddingToCart = true;
    update(["cart"]);
    if (Storage().getToken != null) {
      await handleEither(await CheckoutRepository().getCart(), (r) {
        cart = r;
        update(["home-cart-icon"]);
      });
    }
    isAddingToCart = false;
    update(["cart"]);
  }

  Future<bool> addToCart({required int productId, required int price}) async {
    isAddingToCart = true;
    update(["add-to-cart-button"]);
    bool isSuccess = true;
    var either1 = await CheckoutRepository().deleteCart();
    handleEither(
      either1,
      (r) {},
      onError: (message) {
        if (message != "ShoppingCart.CartItems.NotFound") {
          Toast.showErrorToast(message);
          isSuccess = false;
        }
      },
    );
    var either2 = await CheckoutRepository().addToCart(productId, price);
    handleEither(
      either2,
      (r) {},
      onError: (message) {
        isSuccess = false;
      },
    );
    isAddingToCart = false;
    update(["add-to-cart-button"]);
    return isSuccess;
  }

  Future updateCart({required int productId, required int price}) async {
    var either = await CheckoutRepository().updateCartItem(productId, price);
    handleEither(either, (r) {});
  }

  Future<bool> deleteCart() async {
    var either = await CheckoutRepository().deleteCart();
    return handleEitherReturn(
      either,
      (r) async {
        getCartData();
        return true;
      },
      onError: (message) async {
        return false;
      },
    );
  }
}
