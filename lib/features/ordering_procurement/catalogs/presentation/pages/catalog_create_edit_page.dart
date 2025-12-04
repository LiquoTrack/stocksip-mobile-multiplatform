import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';

class CatalogCreateEditPage extends StatefulWidget {
  final String? catalogId;
  final bool isEditMode;

  const CatalogCreateEditPage({
    super.key,
    this.catalogId,
    this.isEditMode = false,
  });

  @override
  State<CatalogCreateEditPage> createState() => _CatalogCreateEditPageState();
}

class _CatalogCreateEditPageState extends State<CatalogCreateEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _emailController;
  bool _isPublished = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _emailController = TextEditingController();

    if (widget.isEditMode && widget.catalogId != null) {
      context.read<CatalogBloc>().add(
            LoadCatalogById(catalogId: widget.catalogId!),
          );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<CatalogBloc>().state;
    if (widget.isEditMode && state.selectedCatalog != null) {
      final catalog = state.selectedCatalog!;
      _nameController.text = catalog.name;
      _descriptionController.text = catalog.description;
      _emailController.text = catalog.contactEmail;
      _isPublished = catalog.isPublished;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveCatalog(BuildContext context) {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a catalog name')),
      );
      return;
    }

    if (widget.isEditMode && widget.catalogId != null) {
      context.read<CatalogBloc>().add(
            UpdateCatalog(
              catalogId: widget.catalogId!,
              name: name,
              description: description,
              contactEmail: email,
            ),
          );
      if (_isPublished) {
        context.read<CatalogBloc>().add(
              PublishCatalog(catalogId: widget.catalogId!),
            );
      } else {
        context.read<CatalogBloc>().add(
              UnpublishCatalog(catalogId: widget.catalogId!),
            );
      }
    } else {
      // For create, need account ID from storage
      context.read<CatalogBloc>().add(
            CreateCatalog(
              accountId: 'account_id_placeholder',
              name: name,
              description: description,
              contactEmail: email,
            ),
          );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditMode ? 'Edit Catalog' : 'Create Catalog'),
          backgroundColor: const Color(0xFFF4ECEC),
          foregroundColor: const Color(0xFF4A1B2A),
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFF4ECEC),
        body: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Catalog Info Section
                    Text(
                      'Catalog Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFFE8B4BE),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12.0),
                    // Name Field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Catalog name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    // Description Field
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12.0),
                    // Email Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Contact email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    // Status Section (only for edit mode)
                    if (widget.isEditMode) ...[
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color(0xFFE8B4BE),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12.0),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Publish',
                                style: TextStyle(
                                  color: Color(0xFF8B4C5C),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Switch(
                                value: _isPublished,
                                onChanged: (value) {
                                  setState(() => _isPublished = value);
                                },
                                activeColor: const Color(0xFFE8B4BE),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: state.status == Status.loading
                            ? null
                            : () => _saveCatalog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C1F2E),
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: state.status == Status.loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.isEditMode ? 'Save Changes' : 'Create',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
