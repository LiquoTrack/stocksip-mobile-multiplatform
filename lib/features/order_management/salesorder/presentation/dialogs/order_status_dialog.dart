import 'package:flutter/material.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_bloc.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_event.dart';

class OrderStatusDialog extends StatefulWidget {
  final String orderId;
  final String currentStatus;
  final SaleorderBloc bloc;

  const OrderStatusDialog({
    super.key,
    required this.orderId,
    required this.currentStatus,
    required this.bloc,
  });

  @override
  State<OrderStatusDialog> createState() => _OrderStatusDialogState();
}

class _OrderStatusDialogState extends State<OrderStatusDialog> {
  late String? selectedStatus;
  late String? draggedStatus;

  final List<String> allStatuses = ['Pending', 'Confirmed', 'Shipped', 'Received', 'Canceled'];

  final Map<String, Color> statusColors = {
    'Pending': const Color(0xFFFFF3CD), // Soft yellow
    'Confirmed': const Color(0xFFD1ECF1), // Soft cyan
    'Shipped': const Color(0xFFD4EDDA), // Soft green
    'Received': const Color(0xFFD4EDDA), // Soft green
    'Canceled': const Color(0xFFF8D7DA), // Soft red
  };

  final Map<String, IconData> statusIcons = {
    'Pending': Icons.schedule,
    'Confirmed': Icons.check_circle,
    'Shipped': Icons.local_shipping,
    'Received': Icons.done_all,
    'Canceled': Icons.cancel,
  };

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
    draggedStatus = null;
  }

  List<String> _getAvailableStatuses() {
    final currentIndex = allStatuses.indexWhere(
      (s) => s.toLowerCase() == widget.currentStatus.toLowerCase(),
    );
    
    if (currentIndex < 0) return allStatuses;
    
    return allStatuses.sublist(currentIndex);
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFF856404); // Dark yellow/brown text
      case 'confirmed':
        return const Color(0xFF0C5460); // Dark cyan text
      case 'shipped':
        return const Color(0xFF155724); // Dark green text
      case 'received':
        return const Color(0xFF155724); // Dark green text
      case 'canceled':
        return const Color(0xFF721C24); // Dark red text
      default:
        return const Color(0xFF4C1F24); // Default dark text
    }
  }

  void _updateOrderStatus(String newStatus) {
    if (newStatus == widget.currentStatus) return;

    print('>>> [OrderStatusDialog] Actualizando estado a: $newStatus');
    
    final event = _getEventForStatus(newStatus);
    widget.bloc.add(event);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updating order to $newStatus...'),
        duration: const Duration(seconds: 2),
      ),
    );
    
    Navigator.pop(context);
  }

  SaleorderEvent _getEventForStatus(String status) {
    switch (status) {
      case 'Confirmed':
        return ConfirmOrderEvent(widget.orderId);
      case 'Shipped':
        return ShipOrderEvent(widget.orderId);
      case 'Received':
        return ReceiveOrderEvent(widget.orderId);
      case 'Canceled':
        return CancelOrderEvent(widget.orderId);
      default:
        throw Exception('Unknown status: $status');
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableStatuses = _getAvailableStatuses();
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF5E6E8),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Order Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4C1F24),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Status: ${widget.currentStatus}',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF4C1F24).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Drag the package to the new status',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF4C1F24).withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            
            // Draggable package icon
            Draggable<String>(
              data: 'package',
              feedback: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 48),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: availableStatuses.asMap().entries.map((entry) {
                  final status = entry.value;
                  final isCurrentStatus = status.toLowerCase() == widget.currentStatus.toLowerCase();
                  final isSelected = status == selectedStatus;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DragTarget<String>(
                      onWillAccept: (data) {
                        setState(() {
                          draggedStatus = status;
                        });
                        return true;
                      },
                      onLeave: (data) {
                        setState(() {
                          draggedStatus = null;
                        });
                      },
                      onAccept: (data) {
                        setState(() {
                          selectedStatus = status;
                          draggedStatus = null;
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        final isHovering = draggedStatus == status;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            color: isHovering
                                ? (statusColors[status] ?? Colors.grey).withOpacity(0.8)
                                : isCurrentStatus
                                    ? statusColors[status]
                                    : isSelected
                                        ? statusColors[status]?.withOpacity(0.9)
                                        : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isHovering || isSelected || isCurrentStatus
                                  ? const Color(0xFF6B6B6B)
                                  : Colors.grey.withOpacity(0.3),
                              width: isHovering || isSelected || isCurrentStatus ? 2 : 1,
                            ),
                            boxShadow: isHovering || isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF6B6B6B).withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcons[status],
                                color: isHovering || isSelected
                                    ? Colors.white
                                    : _getStatusTextColor(status),
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isHovering || isSelected
                                      ? Colors.white
                                      : _getStatusTextColor(status),
                                ),
                              ),
                              if (isCurrentStatus) ...[
                                const SizedBox(height: 4),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4C1F24),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: const Color(0xFF4C1F24)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {
                    if (selectedStatus != null && selectedStatus != widget.currentStatus) {
                      _updateOrderStatus(selectedStatus!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select a different status'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

