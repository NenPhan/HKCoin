class Endpoints {
  static String login = "Customers/Login";
  static String register = "Customers/Register";
  static String getProduct = "Products";
  static String getCustomerInfo = "Customers/Me/";
  static String getWalletInfo = "Wallets/Dashboard";
  static String getCart = "ShoppingCartItems";
  static String addToCart = "ShoppingCartItems/AddToCart";
  static String deleteCart = "ShoppingCartItems/DeleteCart";
  static String updateCartItem(int id) => "ShoppingCartItems($id)/UpdateItem";
}
