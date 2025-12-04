import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/repositories/careguide_repository_impl.dart';
import 'package:stocksip/features/inventory_management/care_guides/data/remote/services/careguide_service.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_bloc.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_event.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_state.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_create_page.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_details_page.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_edit_page.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_assign_page.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/widgets/careguide_card.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class CareGuidePage extends StatefulWidget {
  const CareGuidePage({super.key});

  @override
  State<CareGuidePage> createState() => _CareGuidePageState();
}

class _CareGuidePageState extends State<CareGuidePage> {
  final _searchCtrl = TextEditingController();
  bool _selectionMode = false;
  List<String> _selectedIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final accountId = await TokenStorage().readAccountId();
      if (!mounted) return;
      if (accountId != null && accountId.isNotEmpty) {
        context
            .read<CareguideBloc>()
            .add(GetCareGuidesByAccountIdEvent(accountId: accountId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF4ECEC);

    return Scaffold(
      backgroundColor: bg,
      drawer: const DrawerNavigation(),
      appBar: AppBar(
        backgroundColor: bg,
        iconTheme: const IconThemeData(color: Color(0xFF2B000D)),
        title: Text(
          _selectionMode ? 'Seleccionar elementos' : 'Care Guides',
          style: const TextStyle(color: Color(0xFF2B000D)),
        ),
        elevation: 0,
        actions: _selectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF2B000D)),
                  onPressed: () => setState(() {
                    _selectionMode = false;
                    _selectedIds.clear();
                  }),
                ),
              ]
            : null,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => CareguideCreatePage(parentContext: context),
          );
        },
        backgroundColor: const Color(0xFF4C1F24),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CareguideBloc, CareguideState>(
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == Status.failure) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                }
                final list = state.wrapper.careGuides;
                if (list.isEmpty) {
                  return const Center(child: Text('No care guides found'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final g = list[index];
                    return CareGuideCard(
                      data: g,
                      onTap: () {},
                      onSeeGuide: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CareGuideDetailsPage(careGuide: g),
                          ),
                        );
                      },
                      onAssign: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => CareGuideAssignPage(careGuide: g),
                        );
                      },
                      onEdit: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => CareGuideEditPage(
                            careGuide: g,
                            parentContext: context,
                          ),
                        );
                      },
                      isSelected: _selectedIds.contains(g.id),
                      selectionMode: _selectionMode,
                      onLongPress: () {
                        setState(() {
                          _selectionMode = true;
                          _selectedIds.add(g.id);
                        });
                      },
                      onTapSelect: () {
                        setState(() {
                          if (_selectedIds.contains(g.id)) {
                            _selectedIds.remove(g.id);
                          } else {
                            _selectedIds.add(g.id);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectionMode && _selectedIds.isNotEmpty
          ? SafeArea(
              top: false,
              child: Container(
                height: 68,
                color: const Color(0xFFF4ECEC),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      label: 'Eliminar',
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Eliminar ${_selectedIds.length} guía${_selectedIds.length > 1 ? 's' : ''}'),
                            content: Text('¿Estás seguro de que deseas eliminar ${_selectedIds.length} guía${_selectedIds.length > 1 ? 's' : ''}? Esta acción no se puede deshacer.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          try {
                            final accountId = await TokenStorage().readAccountId() ?? '';
                            if (accountId.isEmpty) return;

                            final repository = CareguideRepositoryImpl(
                              service: CareguideService(client: AuthHttpClient()),
                            );

                            for (final careGuideId in _selectedIds) {
                              await repository.deleteCareGuide(careGuideId: careGuideId);
                            }

                            if (mounted) {
                              context.read<CareguideBloc>().add(
                                GetCareGuidesByAccountIdEvent(accountId: accountId),
                              );
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${_selectedIds.length} guía${_selectedIds.length > 1 ? 's' : ''} eliminada${_selectedIds.length > 1 ? 's' : ''}'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al eliminar guías: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _selectionMode = false;
                                _selectedIds.clear();
                              });
                            }
                          }
                        }
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Editar',
                      onPressed: () async {
                        if (_selectedIds.length != 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor selecciona solo una guía para editar'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        final state = context.read<CareguideBloc>().state;
                        final selectedGuide = state.wrapper.careGuides
                            .where((guide) => guide.id == _selectedIds.first)
                            .firstOrNull;

                        if (selectedGuide == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error: guía no encontrada'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _selectionMode = false;
                          _selectedIds.clear();
                        });

                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => CareGuideEditPage(
                            careGuide: selectedGuide,
                            parentContext: context,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF4C1F24), size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4C1F24),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}