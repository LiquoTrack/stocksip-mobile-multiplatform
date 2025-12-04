class Saleorder {
  final String id;
  final String orderCode;
  final String purchaseOrderId;
  final List<SaleorderItem> items;
  final String status;
  final String catalogToBuyFrom;
  final DateTime? receiptDate;
  final DateTime? completitionDate;
  final String buyer;
  final DeliveryProposal? deliveryProposal;
  final String supplierId;

  const Saleorder({
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
  });

  Saleorder copyWith({
    String? id,
    String? orderCode,
    String? purchaseOrderId,
    List<SaleorderItem>? items,
    String? status,
    String? catalogToBuyFrom,
    DateTime? receiptDate,
    DateTime? completitionDate,
    String? buyer,
    DeliveryProposal? deliveryProposal,
    String? supplierId,
  }) {
    return Saleorder(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      items: items ?? this.items,
      status: status ?? this.status,
      catalogToBuyFrom: catalogToBuyFrom ?? this.catalogToBuyFrom,
      receiptDate: receiptDate ?? this.receiptDate,
      completitionDate: completitionDate ?? this.completitionDate,
      buyer: buyer ?? this.buyer,
      deliveryProposal: deliveryProposal ?? this.deliveryProposal,
      supplierId: supplierId ?? this.supplierId,
    );
  }

  factory Saleorder.fromJson(Map<String, dynamic> json) {
    List<SaleorderItem> parseItems(dynamic v) {
      if (v is List) {
        return v
            .map((e) => SaleorderItem.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
      }
      return const <SaleorderItem>[];
    }

    DateTime? parseDate(dynamic v) {
      if (v == null || (v is String && v.isEmpty)) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return Saleorder(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      orderCode: (json['orderCode'] ?? '').toString(),
      purchaseOrderId: (json['purchaseOrderId'] ?? '').toString(),
      items: parseItems(json['items']),
      status: (json['status'] ?? '').toString(),
      catalogToBuyFrom: (json['catalogToBuyFrom'] ?? '').toString(),
      receiptDate: parseDate(json['receiptDate']),
      completitionDate: parseDate(json['completitionDate']),
      buyer: (json['buyer'] ?? '').toString(),
      deliveryProposal: json['deliveryProposal'] is Map
          ? DeliveryProposal.fromJson(
              (json['deliveryProposal'] as Map).cast<String, dynamic>())
          : null,
      supplierId: (json['supplierId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderCode': orderCode,
        'purchaseOrderId': purchaseOrderId,
        'items': items.map((e) => e.toJson()).toList(),
        'status': status,
        'catalogToBuyFrom': catalogToBuyFrom,
        'receiptDate': receiptDate?.toIso8601String(),
        'completitionDate': completitionDate?.toIso8601String(),
        'buyer': buyer,
        'deliveryProposal': deliveryProposal?.toJson(),
        'supplierId': supplierId,
      };
}

class SaleorderItem {
  final String productId;
  final String productName;
  final double unitPrice;
  final String currency;
  final String inventoryId;
  final double quantityToSell;

  const SaleorderItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.currency,
    required this.inventoryId,
    required this.quantityToSell,
  });

  factory SaleorderItem.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return SaleorderItem(
      productId: (json['productId'] ?? '').toString(),
      productName: (json['productName'] ?? '').toString(),
      unitPrice: toDouble(json['unitPrice']),
      currency: (json['currency'] ?? '').toString(),
      inventoryId: (json['inventoryId'] ?? '').toString(),
      quantityToSell: toDouble(json['quantityToSell']),
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'unitPrice': unitPrice,
        'currency': currency,
        'inventoryId': inventoryId,
        'quantityToSell': quantityToSell,
      };
}

class DeliveryProposal {
  final DateTime? proposedDate;
  final String notes;
  final String status;
  final DateTime? createdAt;
  final DateTime? respondedAt;

  const DeliveryProposal({
    required this.proposedDate,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.respondedAt,
  });

  factory DeliveryProposal.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null || (v is String && v.isEmpty)) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return DeliveryProposal(
      proposedDate: parseDate(json['proposedDate']),
      notes: (json['notes'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: parseDate(json['createdAt']),
      respondedAt: parseDate(json['respondedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'proposedDate': proposedDate?.toIso8601String(),
        'notes': notes,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'respondedAt': respondedAt?.toIso8601String(),
      };
}