import 'package:get/get.dart';
import 'package:hkcoin/core/presentation/storage.dart';
import 'package:hkcoin/core/request_handler.dart';
import 'package:hkcoin/core/toast.dart';
import 'package:hkcoin/data.models/cart.dart';
import 'package:hkcoin/data.repositories/cart_repository.dart';

class CartController extends GetxController {
  Cart? cart;

  void getCartData() async {
    if (Storage().getToken != null) {
      handleEither(await CartRepository().getCart(), (r) {
        cart = r;
      });
      update(["cart", "home-cart-icon"]);
    }
  }

  Future<bool> addToCart({required int productId, required int price}) async {
    bool isSuccess = true;
    var either1 = await CartRepository().deleteCart();
    handleEither(
      either1,
      (r) {},
      onError: (message) {
        if (message != "ShoppingCart.CartItems.NotFound") {
          Toast.showErrorToast(message);
          isSuccess = false;
        }
      },
      shouldHandleError: false,
    );
    var either2 = await CartRepository().addToCart(productId, price);
    handleEither(
      either2,
      (r) {},
      onError: (message) {
        isSuccess = false;
      },
    );
    return isSuccess;
  }

  Future updateCart({required int productId, required int price}) async {
    var either = await CartRepository().updateCartItem(productId, price);
    handleEither(either, (r) {});
  }

  Future<bool> deleteCart() async {
    var either = await CartRepository().deleteCart();
    return handleEitherReturn(
      either,
      (r) {
        getCartData();
        return true;
      },
      onError: () {
        return false;
      },
    );
  }
}
