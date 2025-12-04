class ApiConstants {

  static final String baseUrl = 'https://stocksip-back-end.azurewebsites.net/api/v1/';

  static final String signIn = 'sign-in';

  static final String signUp = 'sign-up';
  
  static String warehousesByAccountId(String accountId) {
    return 'accounts/$accountId/warehouses';
  }

  static String warehouseById(String warehouseId) {
    return 'warehouses/$warehouseId';
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

  static String getInventoriesByWarehouseId(String warehouseId) {
    return 'warehouses/$warehouseId/products';
  }

  static String getInventoryByProductIdAndWarehouseId(String productId, String warehouseId) {
    return 'warehouses/$warehouseId/products/$productId';
  }

  static String addProductsToWarehouseInventory(String warehouseId, String productId) {
    return 'warehouses/$warehouseId/products/$productId/additions';
  }

  static String subtractProductsFromWarehouseInventory(String warehouseId, String productId) {
    return 'warehouses/$warehouseId/products/$productId/subtractions';
  }

  static String transferProductsBetweenWarehouses(String fromWarehouseId, String productId) {
    return 'warehouses/$fromWarehouseId/products/$productId/transfers';
  }

  static String getInventoryById(String inventoryId) {
    return 'inventories/$inventoryId';
  }

  static String deleteInventoryById(String inventoryId) {
    return 'inventories/$inventoryId';
  }

  static final String getMyProfile = 'profiles/me';

  static final String createProfile = 'profiles';

  static String getProfileById(String profileId) {
    return 'profiles/$profileId';
  }

  static String updateProfile(String profileId) {
    return 'profiles/$profileId';
  }

  static String sendRecoveryCode() {
    return 'users/recovery-code';
  }

  static String verifyRecoveryCode() {
    return 'users/verify-recovery-code';
  }

  static String resetPassword() {
    return 'users/reset-password';
  }

  static String getAllBrands() {
    return 'brands';
  }

  static String getAllProductTypes() {
    return 'product-types';
  }
}