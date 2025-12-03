import 'package:flutter/material.dart';

class CareGuideCreate extends StatefulWidget {
  const CareGuideCreate({super.key});

  @override
  State<CareGuideCreate> createState() => _CareGuideCreateState();
}

class _CareGuideCreateState extends State<CareGuideCreate> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProduct;
  final _typeController = TextEditingController();
  final _commentsController = TextEditingController();
  final _minTempController = TextEditingController();
  final _maxTempController = TextEditingController();

  @override
  void dispose() {
    _typeController.dispose();
    _commentsController.dispose();
    _minTempController.dispose();
    _maxTempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color pageBg = const Color(0xFFF3E9E7);

    OutlineInputBorder border() => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Color(0xFFB1A6A6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border(),
      enabledBorder: border(),
      focusedBorder: border(),
    );

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF471725)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Guide', style: TextStyle(color: Color(0xFF471725), fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedProduct,
                    decoration: inputDecoration.copyWith(hintText: 'Select Product'),
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF471725)),
                    items: const [
                      DropdownMenuItem(value: 'Whiskey', child: Text('Whiskey')),
                      DropdownMenuItem(value: 'Wine', child: Text('Wine')),
                      DropdownMenuItem(value: 'Rum', child: Text('Rum')),
                    ],
                    onChanged: (v) => setState(() => _selectedProduct = v),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _typeController,
                  decoration: inputDecoration.copyWith(hintText: 'Type'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _commentsController,
                  maxLines: 5,
                  decoration: inputDecoration.copyWith(hintText: 'Comments'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minTempController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(hintText: 'Min. Temperature'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _maxTempController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(hintText: 'Max. Temperature'),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A0A14),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}