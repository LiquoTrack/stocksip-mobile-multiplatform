import '../../../domain/models/catalog.dart';
import 'catalog_dto.dart';
import 'catalog_item_dto.dart';
import 'supplier_info_dto.dart';
import 'account_info_dto.dart';
import 'business_info_dto.dart';

/// Maps CatalogDto to Catalog domain model
extension CatalogDtoMapper on CatalogDto {
  Catalog toDomain() {
    return Catalog(
      id: id,
      name: name,
      description: description,
      catalogItems: catalogItems.map((item) => item.toDomain()).toList(),
      ownerAccount: ownerAccount,
      contactEmail: contactEmail,
      isPublished: isPublished,
      warehouseId: warehouseId,
    );
  }
}

/// Maps CatalogItemDto to CatalogItem domain model
extension CatalogItemDtoMapper on CatalogItemDto {
  CatalogItem toDomain() {
    return CatalogItem(
      productId: productId,
      productName: productName,
      amount: amount,
      currency: currency,
      addedDate: addedDate,
      imageUrl: imageUrl,
      availableStock: availableStock ?? 0,
    );
  }
}

/// Maps SupplierInfoDto to SupplierInfo domain model
extension SupplierInfoDtoMapper on SupplierInfoDto {
  SupplierInfo toDomain() {
    return SupplierInfo(
      account: account.toDomain(),
      catalogs: catalogs.map((item) => item.toDomain()).toList(),
    );
  }
}

/// Maps AccountInfoDto to AccountInfo domain model
extension AccountInfoDtoMapper on AccountInfoDto {
  AccountInfo toDomain() {
    return AccountInfo(
      id: id,
      business: business.toDomain(),
    );
  }
}

/// Maps BusinessInfoDto to BusinessInfo domain model
extension BusinessInfoDtoMapper on BusinessInfoDto {
  BusinessInfo toDomain() {
    return BusinessInfo(
      businessName: businessName,
      businessEmail: businessEmail,
      ruc: ruc,
    );
  }
}

// Domain models for SupplierInfo, AccountInfo, BusinessInfo
class SupplierInfo {
  final AccountInfo account;
  final List<Catalog> catalogs;

  SupplierInfo({
    required this.account,
    required this.catalogs,
  });
}

class AccountInfo {
  final String id;
  final BusinessInfo business;

  AccountInfo({
    required this.id,
    required this.business,
  });
}

class BusinessInfo {
  final String businessName;
  final String businessEmail;
  final String ruc;

  BusinessInfo({
    required this.businessName,
    required this.businessEmail,
    required this.ruc,
  });
}
