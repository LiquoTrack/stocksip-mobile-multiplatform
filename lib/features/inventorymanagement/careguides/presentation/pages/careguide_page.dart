import 'package:flutter/material.dart';
import 'package:stocksip/features/inventorymanagement/careguides/presentation/widgets/careguide_card.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class CareGuidePage extends StatefulWidget {
  const CareGuidePage({super.key});

  @override
  State<CareGuidePage> createState() => _CareGuidePageState();
}

class _CareGuidePageState extends State<CareGuidePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final List<CareGuideCardData> _mockedGuides = const [
    CareGuideCardData(
      id: 'vino-blanco',
      title: 'Vino Blanco',
      subtitle: 'Wine · 8°C – 10°C',
      imageUrl:
          'https://images.pexels.com/photos/1407853/pexels-photo-1407853.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
    CareGuideCardData(
      id: 'vino-tinto',
      title: 'Vino Tinto',
      subtitle: 'Wine · 14°C – 16°C',
      imageUrl:
          'https://images.pexels.com/photos/290316/pexels-photo-290316.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
    CareGuideCardData(
      id: 'whisky-blanco',
      title: 'Whisky Blanco',
      subtitle: 'Whisky · 18°C',
      imageUrl:
          'https://images.pexels.com/photos/5531556/pexels-photo-5531556.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
    CareGuideCardData(
      id: 'ron-cartavio',
      title: 'Ron Cartavio',
      subtitle: 'Rum · 16°C – 20°C',
      imageUrl:
          'https://images.pexels.com/photos/1089930/pexels-photo-1089930.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
    CareGuideCardData(
      id: 'ron-cartavio-reserva',
      title: 'Ron Cartavio',
      subtitle: 'Rum · 16°C – 20°C',
      imageUrl:
          'https://images.pexels.com/photos/290316/pexels-photo-290316.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
  ];

  String _currentSort = 'Most Recent';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color backgroundColor = const Color(0xFFFDF6ED);
    final Color accentColor = const Color(0xFF7A1D2A);
    final filteredGuides = _mockedGuides
        .where(
          (guide) => guide.title.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
        )
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      drawer: const DrawerNavigation(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
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
                    'Care Guides (${filteredGuides.length})',
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 6,
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      '+ New',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: PopupMenuButton<String>(
                    initialValue: _currentSort,
                    onSelected: (value) => setState(() => _currentSort = value),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'Most Recent',
                        child: Text('Most Recent'),
                      ),
                      PopupMenuItem(
                        value: 'Alphabetical',
                        child: Text('Alphabetical'),
                      ),
                    ],
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentSort,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF6C4F4F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredGuides.length,
                  itemBuilder: (context, index) {
                    final guide = filteredGuides[index];
                    return CareGuideCard(
                      data: guide,
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
