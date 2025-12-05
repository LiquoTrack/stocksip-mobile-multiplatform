import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_bloc.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_event.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_state.dart';

class AlertsPage extends StatefulWidget {
  // Asumimos que pasas el accountId al abrir esta página
  final String accountId; 

  const AlertsPage({super.key, required this.accountId});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  void initState() {
    super.initState();
    // Disparar la carga de alertas al iniciar la pantalla
    context.read<AlertsBloc>().add(LoadAlerts(accountId: widget.accountId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: BlocBuilder<AlertsBloc, AlertsState>(
        builder: (context, state) {
          if (state is AlertsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlertsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is AlertsLoaded) {
            if (state.alerts.isEmpty) {
              return const Center(child: Text('No tienes notificaciones.'));
            }
            return ListView.builder(
              itemCount: state.alerts.length,
              itemBuilder: (context, index) {
                final alert = state.alerts[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: alert.severity == 'HIGH' ? Colors.red : Colors.blue,
                    ),
                    title: Text(alert.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert.message),
                        const SizedBox(height: 4),
                        Text(
                          'Tipo: ${alert.type}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Cargando notificaciones...'));
        },
      ),
    );
  }
}