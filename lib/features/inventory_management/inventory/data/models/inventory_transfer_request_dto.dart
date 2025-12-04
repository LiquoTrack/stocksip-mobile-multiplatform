import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_transfer_request.dart';

/// Data Transfer Object for [InventoryTransferRequest].
/// Facilitates conversion between domain entity and JSON map.
class InventoryTransferRequestDto {
  final String destinationWarehouseId;
  final int quantityToTransfer;
  final DateTime? expirationDate;

  /// Creates an [InventoryTransferRequestDto] with the given parameters.
  const InventoryTransferRequestDto({
    required this.destinationWarehouseId,
    required this.quantityToTransfer,
    this.expirationDate,
  });

  /// Creates an instance of [InventoryTransferRequestDto] from a map.
  factory InventoryTransferRequestDto.fromMap(Map<String, dynamic> map) {
    return InventoryTransferRequestDto(
      destinationWarehouseId: map['destinationWarehouseId'],
      quantityToTransfer: map['quantityToTransfer'],
      expirationDate: map['expirationDate'] != null
          ? DateTime.parse(map['expirationDate'])
          : null,
    );
  }

  /// Converts a domain entity [InventoryTransferRequest] to a DTO.
  factory InventoryTransferRequestDto.fromDomain(InventoryTransferRequest entity) {
    return InventoryTransferRequestDto(
      destinationWarehouseId: entity.destinationWarehouseId,
      quantityToTransfer: entity.quantityToTransfer,
      expirationDate: entity.expirationDate,
    );
  }

  /// Converts the DTO to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'destinationWarehouseId': destinationWarehouseId,
      'quantityToTransfer': quantityToTransfer,
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }
}