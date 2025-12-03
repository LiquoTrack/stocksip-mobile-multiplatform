import 'package:stocksip/features/inventory_management/inventory/domain/entities/inventory_subtrack_request.dart';

/// Data Transfer Object for [InventorySubtrackRequest].
/// Facilitates conversion between domain entity and JSON map.
class InventorySubtrackRequestDto {
  final int quantityToSubtrack;
  final String subtrackReason;
  final DateTime? expirationDate;

  /// Creates an [InventorySubtrackRequestDto] with the given parameters.
  const InventorySubtrackRequestDto({
    required this.quantityToSubtrack,
    required this.subtrackReason,
    this.expirationDate,
  });

  /// Creates an instance of [InventorySubtrackRequestDto] from a map.
  factory InventorySubtrackRequestDto.fromMap(Map<String, dynamic> map) {
    return InventorySubtrackRequestDto(
      quantityToSubtrack: map['quantityToDecrease'],
      subtrackReason: map['exitReason'],
      expirationDate: map['expirationDate'] != null
          ? DateTime.parse(map['expirationDate'])
          : null,
    );
  }

  /// Converts a domain entity [InventorySubtrackRequest] to a DTO.
  factory InventorySubtrackRequestDto.fromDomain(InventorySubtrackRequest entity) {
    return InventorySubtrackRequestDto(
      quantityToSubtrack: entity.quantityToSubtrack,
      subtrackReason: entity.subtrackReason,
      expirationDate: entity.expirationDate,
    );
  }

  /// Converts the DTO to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'quantityToDecrease': quantityToSubtrack,
      'exitReason': subtrackReason,
      'expirationDate': expirationDate?.toIso8601String(),
    };
  }
}