/// Enumeration representing different account roles
enum AccountRole {
  liquorstoreowner,
  supplier  
}

/// Extension methods for AccountRole enum
extension AccountRoleX on AccountRole {
  String toApi() {
    switch (this) {
      case AccountRole.supplier:
        return "Supplier";
      case AccountRole.liquorstoreowner:
        return "LiquorStoreOwner";
    }
  }
}