class Endpoints {
  static String login = "Customers/Login";
  static String register = "Customers/Register";
  static String logout = "Customers/Logout";
  static String getProduct = "Products";
  static String getOrders = "Customers/Orders";
  static String customerInfo = "Customers/Me/";
  static String getWalletInfo = "Wallets/Dashboard";
  static String getCart = "ShoppingCartItems/GetCart";
  static String addToCart = "ShoppingCartItems/AddToCart";
  static String deleteCart = "ShoppingCartItems/DeleteCart";
  static String updateCartItem(int id) => "ShoppingCartItems($id)/UpdateItem";
  static String getNews = "NewsItems";
  static String changePassword = "Customers/ChangePassword";
  static String getSlides = "Sliders";
}
