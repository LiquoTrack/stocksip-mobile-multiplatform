import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide_wrapper.dart';

class CareguideState {
  final Status status;
  final CareGuideWrapper wrapper;
  final String message;
  final CareGuide? selected;

  const CareguideState({
    this.status = Status.initial,
    this.wrapper = const CareGuideWrapper(count: 0, careGuides: []),
    this.message = '',
    this.selected,
  });

  CareguideState copyWith({
    Status? status,
    CareGuideWrapper? wrapper,
    String? message,
    CareGuide? selected,
  }) {
    return CareguideState(
      status: status ?? this.status,
      wrapper: wrapper ?? this.wrapper,
      message: message ?? this.message,
      selected: selected ?? this.selected,
    );
  }
}