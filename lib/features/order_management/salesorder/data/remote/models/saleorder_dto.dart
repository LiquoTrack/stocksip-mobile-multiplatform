import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';

class SaleorderDto {
  final String id;
  final String orderCode;
  final String purchaseOrderId;
  final List<SaleorderItemDto> items;
  final String status;
  final String catalogToBuyFrom;
  final String? receiptDate;
  final String? completitionDate;
  final String buyer;
  final DeliveryProposalDto? deliveryProposal;
  final String supplierId;
  final String? accountId;

  const SaleorderDto({
    required this.id,
    required this.orderCode,
    required this.purchaseOrderId,
    required this.items,
    required this.status,
    required this.catalogToBuyFrom,
    required this.receiptDate,
    required this.completitionDate,
    required this.buyer,
    required this.deliveryProposal,
    required this.supplierId,
    this.accountId,
  });

  factory SaleorderDto.fromJson(Map<String, dynamic> json) {
    List<SaleorderItemDto> parseItems(dynamic v) {
      if (v is List) {
        return v
            .map((e) => SaleorderItemDto.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
      }
      return const <SaleorderItemDto>[];
    }
    return SaleorderDto(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      orderCode: (json['orderCode'] ?? '').toString(),
      purchaseOrderId: (json['purchaseOrderId'] ?? '').toString(),
      items: parseItems(json['items']),
      status: (json['status'] ?? '').toString(),
      catalogToBuyFrom: (json['catalogToBuyFrom'] ?? '').toString(),
      receiptDate: (json['receiptDate'])?.toString(),
      completitionDate: (json['completitionDate'])?.toString(),
      buyer: (json['buyer'] ?? '').toString(),
      deliveryProposal: json['deliveryProposal'] is Map
          ? DeliveryProposalDto.fromJson(
              (json['deliveryProposal'] as Map).cast<String, dynamic>())
          : null,
      supplierId: (json['supplierId'] ?? '').toString(),
      accountId: (json['accountId'])?.toString(),
    );
  }

  Saleorder toDomain() {
    DateTime? parseDate(String? v) {
      if (v == null || v.isEmpty) return null;
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }

    return Saleorder(
      id: id,
      orderCode: orderCode,
      purchaseOrderId: purchaseOrderId,
      items: items.map((e) => e.toDomain()).toList(),
      status: status,
      catalogToBuyFrom: catalogToBuyFrom,
      receiptDate: parseDate(receiptDate),
      completitionDate: parseDate(completitionDate),
      buyer: buyer,
      deliveryProposal: deliveryProposal?.toDomain(),
      supplierId: supplierId,
    );
  }
}

class SaleorderItemDto {
  final String productId;
  final String productName;
  final double unitPrice;
  final String currency;
  final String inventoryId;
  final double quantityToSell;

  const SaleorderItemDto({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.currency,
    required this.inventoryId,
    required this.quantityToSell,
  });

  factory SaleorderItemDto.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }
    return SaleorderItemDto(
      productId: (json['productId'] ?? '').toString(),
      productName: (json['productName'] ?? '').toString(),
      unitPrice: toDouble(json['unitPrice']),
      currency: (json['currency'] ?? '').toString(),
      inventoryId: (json['inventoryId'] ?? '').toString(),
      quantityToSell: toDouble(json['quantityToSell']),
    );
  }

  SaleorderItem toDomain() => SaleorderItem(
        productId: productId,
        productName: productName,
        unitPrice: unitPrice,
        currency: currency,
        inventoryId: inventoryId,
        quantityToSell: quantityToSell,
      );
}

class DeliveryProposalDto {
  final String? proposedDate;
  final String notes;
  final String status;
  final String? createdAt;
  final String? respondedAt;

  const DeliveryProposalDto({
    required this.proposedDate,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.respondedAt,
  });

  factory DeliveryProposalDto.fromJson(Map<String, dynamic> json) {
    return DeliveryProposalDto(
      proposedDate: json['proposedDate']?.toString(),
      notes: (json['notes'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: json['createdAt']?.toString(),
      respondedAt: json['respondedAt']?.toString(),
    );
  }

  DeliveryProposal toDomain() {
    DateTime? parseDate(String? v) {
      if (v == null || v.isEmpty) return null;
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }
    return DeliveryProposal(
      proposedDate: parseDate(proposedDate),
      notes: notes,
      status: status,
      createdAt: parseDate(createdAt),
      respondedAt: parseDate(respondedAt),
    );
  }
}