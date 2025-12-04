import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_addition_request.dart';

/// Data Transfer Object for [InventoryAdditionRequest].
/// Facilitates conversion between domain entity and JSON map.
class InventoryAdditionRequestDto {
  final int quantityToAdd;
  final DateTime? expirationDate;

  /// Constructs an [InventoryAdditionRequestDto] instance with the given parameters.
  const InventoryAdditionRequestDto({
    required this.quantityToAdd,
    this.expirationDate,
  });

  /// Creates an [InventoryAdditionRequestDto] from a JSON map.
  factory InventoryAdditionRequestDto.fromMap(Map<String, dynamic> map) {
    return InventoryAdditionRequestDto(
      quantityToAdd: map['quantityToAdd'],
      expirationDate: map['expirationDate'] != null
          ? DateTime.parse(map['expirationDate'])
          : null,
    );
  }

  /// Converts a domain [InventoryAdditionRequest] to an [InventoryAdditionRequestDto].
  factory InventoryAdditionRequestDto.fromDomain(InventoryAdditionRequest domain) {
    return InventoryAdditionRequestDto(
      quantityToAdd: domain.quantityToAdd,
      expirationDate: domain.expirationDate,
    );
  }

  /// Converts the [InventoryAdditionRequestDto] instance to a JSON map.
  Map<String, dynamic> toMap() {
    return {
      'quantityToAdd': quantityToAdd,
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }
}