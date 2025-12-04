class PlanLimits {
  final int? maxWarehouses;
  final int? maxProducts;
  final int? maxUsers;
  final bool? storageGuides;
  final bool? communitySupport;
  final bool? prioritySupport;
  final bool? premiumStorageGuides;

  PlanLimits({
    this.maxWarehouses,
    this.maxProducts,
    this.maxUsers,
    this.storageGuides,
    this.communitySupport,
    this.prioritySupport,
    this.premiumStorageGuides,
  });

  factory PlanLimits.fromJson(Map<String, dynamic> json) {
    return PlanLimits(
      maxWarehouses: json['MaxWarehouses'] as int?,
      maxProducts: json['MaxProducts'] as int?,
      maxUsers: json['MaxUsers'] as int?,
      storageGuides: json['storageGuides'] as bool?,
      communitySupport: json['communitySupport'] as bool?,
      prioritySupport: json['prioritySupport'] as bool?,
      premiumStorageGuides: json['premiumStorageGuides'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaxWarehouses': maxWarehouses,
      'MaxProducts': maxProducts,
      'MaxUsers': maxUsers,
      'storageGuides': storageGuides,
      'communitySupport': communitySupport,
      'prioritySupport': prioritySupport,
      'premiumStorageGuides': premiumStorageGuides,
    };
  }

  PlanLimits copyWith({
    int? maxWarehouses,
    int? maxProducts,
    int? maxUsers,
    bool? storageGuides,
    bool? communitySupport,
    bool? prioritySupport,
    bool? premiumStorageGuides,
  }) {
    return PlanLimits(
      maxWarehouses: maxWarehouses ?? this.maxWarehouses,
      maxProducts: maxProducts ?? this.maxProducts,
      maxUsers: maxUsers ?? this.maxUsers,
      storageGuides: storageGuides ?? this.storageGuides,
      communitySupport: communitySupport ?? this.communitySupport,
      prioritySupport: prioritySupport ?? this.prioritySupport,
      premiumStorageGuides: premiumStorageGuides ?? this.premiumStorageGuides,
    );
  }
}
