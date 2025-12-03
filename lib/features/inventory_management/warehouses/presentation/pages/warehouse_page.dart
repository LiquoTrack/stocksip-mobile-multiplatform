import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/pages/inventory_page.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_bloc.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_event.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_state.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  @override
  void initState() {
    super.initState();
    context.read<WarehouseBloc>().add(const GetAllWarehouses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warehouses"),
      ),
      body: BlocBuilder<WarehouseBloc, WarehouseState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == Status.failure) {
            return Center(
              child: Text(
                state.messsage ?? "Error loading warehouses",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final warehouses = state.warehouseWrapper.warehouses;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Current: ${warehouses.length}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Max Allowed: ${state.warehouseWrapper.maxWarehousesAllowed}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),

                if (warehouses.isEmpty)
                  const Center(child: Text("No warehouses found"))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: warehouses.length,
                    itemBuilder: (context, index) {
                      final warehouse = warehouses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(warehouse.name),
                          subtitle: Text(
                              "${warehouse.addressStreet}, ${warehouse.addressCity}"),
                          trailing: Text(
                              "${warehouse.capacity.toStringAsFixed(1)} units"),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryPage()));
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
