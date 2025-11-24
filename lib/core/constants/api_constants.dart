class ApiConstants {

  static final String baseUrl = 'https://stocksip-back-end.azurewebsites.net/api/v1/';

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

  static String getCareGuidesByAccountId(String accountId) {
    return 'accounts/$accountId/care-guides';
  }

  static String getCareGuideById(String careGuideId) {
    return 'care-guides/$careGuideId';
  }

  static String getCareGuideByProductType(String accountId, String productType) {
    return 'care-guides/$accountId/$productType';
  } 

  static String createCareGuide(String accountId) {
    return 'care-guides/$accountId';
  }

  static String updateCareGuide(String careGuideId) {
    return 'care-guides/$careGuideId';
  }

  static String deleteCareGuide(String careGuideId) {
    return 'care-guides/$careGuideId';
  }

  static String unassignCareGuide(String careGuideId) {
    return 'care-guides/$careGuideId/deallocations';
  }

  static String assignCareGuide(String careGuideId, String productId) {
    return 'care-guides/$careGuideId/allocations/$productId';
  }
}