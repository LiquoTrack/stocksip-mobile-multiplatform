import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_bloc.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_event.dart';
import 'package:stocksip/features/alerts_and_notification/alerts/presentation/blocs/alerts_state.dart';

class AlertsPage extends StatefulWidget {

  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AlertsBloc>().add(LoadAlerts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts & Notifications')),
      body: BlocBuilder<AlertsBloc, AlertsState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == Status.failure) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state.status == Status.success) {
            if (state.alerts.isEmpty) {
              return const Center(child: Text('No alerts generated for this account!'));
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
                          'Type: ${alert.type}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Loading notifications...'));
        },
      ),
    );
  }
}