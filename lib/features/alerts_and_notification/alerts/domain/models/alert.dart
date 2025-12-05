class Alert {
  final String id;
  final String title;
  final String message;
  final String severity;
  final String type;
  final String accountId;
  final String inventoryId;

  const Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.type,
    required this.accountId,
    required this.inventoryId,
  });
}