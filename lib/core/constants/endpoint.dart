class Endpoints {
  static String login = "Customers/Login";
  static String register = "Customers/Register";
  static String logout = "Customers/Logout";
  static String getProduct = "Products";
  static String getOrders = "Customers/Orders";
  static String customerInfo = "Customers/Me/";
  static String getWalletInfo = "Wallets/Dashboard";
  static String getWalletBalances = "Wallets/Balances";
  static String getCart = "ShoppingCartItems/GetCart";
  static String addToCart = "ShoppingCartItems/AddToCart";
  static String deleteCart = "ShoppingCartItems/DeleteCart";
  static String updateCartItem(int id) => "ShoppingCartItems($id)/UpdateItem";
  static String getNews = "NewsItems";
  static String getNewsDetail(int id) => "NewsItems($id)";
  static String changePassword = "Customers/ChangePassword";
  static String getSlides = "Sliders";
  static String getAddresses = "Customers/Addresses";
  static String getProvinces({int countryCode = 230}) =>
      "Countries($countryCode)/StateProvinces";
  static String addAddress = "Orders/AddAddress";
  static String selectAddress = "Orders/SelectBillingAddress";
  static String checkout = "Orders/Checkout";
  static String checkoutComplete = "Orders/CheckoutComplate";
  static String selectPaymentMethod = "Orders/SelectPaymentMethod";
  static String orderTotal = "Orders/OrderTotal";
  static String getLanguage = "Languages/GetLanguage";
  static String getLanguages = "Languages";
  static String setLanguage = "Languages/SetLanguage";
}
