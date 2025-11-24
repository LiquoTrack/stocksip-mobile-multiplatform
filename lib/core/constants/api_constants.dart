class ApiConstants {

  static final String baseUrl = 'http://10.0.2.2:5283/api/v1/';

  static final String signIn = 'sign-in';

  static final String signUp = 'sign-up';
  
  static String getWarehousesByAccountId(String accountId) {
    return 'accounts/$accountId/warehouses';
  }

  static String registerProduct(String accountId) {
    return 'accounts/$accountId/products';
  }

  static String updateProduct(String productId) {
    return 'products/$productId';
  }

  static String getProductById(String productId) {
    return 'products/$productId';
  }

  static String getProductsByAccountId(String accountId) {
    return 'accounts/$accountId/products';
  }

  static String getCareGuidesByAccountId(String careGuideId) {
    return 'care-guides/$careGuideId';
  }
}