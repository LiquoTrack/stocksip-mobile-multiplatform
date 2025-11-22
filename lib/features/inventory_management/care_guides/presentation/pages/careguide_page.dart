import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/widgets/careguide_card.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_bloc.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_state.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/blocs/careguide_event.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_create.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_detail.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_asign.dart';
import 'package:stocksip/features/inventory_management/care_guides/presentation/pages/careguide_update.dart';

class CareGuidePage extends StatefulWidget {
  const CareGuidePage({super.key});

  @override
  State<CareGuidePage> createState() => _CareGuidePageState();
}

class _CareGuidePageState extends State<CareGuidePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadAccountAndFetch();
  }

  Future<void> _loadAccountAndFetch() async {
    final accountId = await _storage.read(key: 'accountId');
    if (!mounted) return;
    if (accountId != null && accountId.isNotEmpty) {
      final bloc = context.read<CareguideBloc>();
      bloc.add(GetCareGuidesByAccountIdEvent(accountId: accountId));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color backgroundColor = const Color(0xFFF3E9E7);
    final Color accentColor = const Color(0xFF471725);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      drawer: const DrawerNavigation(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: BlocBuilder<CareguideBloc, CareguideState>(
            builder: (context, state) {
              List<CareGuideCardData> guides = state.guides.map((g) {
                final subtitle = '${g.productAssociated} · ${g.recommendedMinTemperature.toStringAsFixed(0)}°C – ${g.recommendedMaxTemperature.toStringAsFixed(0)}°C';
                return CareGuideCardData(
                  id: g.careGuideId,
                  title: g.title,
                  subtitle: subtitle,
                  imageUrl: g.imageUrl,
                );
              }).toList();

              guides = guides
                  .where((guide) => guide.title.toLowerCase().contains(_searchController.text.toLowerCase()))
                  .toList();

              return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu, color: Color(0xFF522534)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Care Guides',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'New',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CareGuideCreate()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (state.status == Status.loading) ...[
                const Expanded(child: Center(child: CircularProgressIndicator()))
              ] else if (state.status == Status.failure) ...[
                Expanded(
                  child: Center(
                    child: Text(state.message ?? 'Failed to load care guides'),
                  ),
                )
              ] else ...[
              Expanded(
                child: ListView.separated(
                  itemCount: guides.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final guide = guides[index];
                    final domainGuide = state.guides[index];
                    return CareGuideCard(
                      data: guide,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CareGuideUpdate(guide: domainGuide),
                          ),
                        );
                      },
                      onSeeGuide: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CareGuideDetail(guide: domainGuide),
                          ),
                        );
                      },
                      onAssign: () {
                        Navigator.of(context)
                            .push<bool>(
                              MaterialPageRoute(
                                builder: (_) => CareGuideAssign(careGuideId: domainGuide.careGuideId),
                              ),
                            )
                            .then((assigned) {
                          if (assigned == true) {
                            _loadAccountAndFetch();
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              ]
            ],
          );
            },
          ),
        ),
      ),
    );
  }
}
