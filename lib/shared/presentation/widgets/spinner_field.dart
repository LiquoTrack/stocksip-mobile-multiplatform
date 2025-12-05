import 'package:flutter/material.dart';

/// A custom spinner field widget that allows users to select from a list of options.
class CustomSpinnerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final List<String> options;

  const CustomSpinnerField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = options.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label encima de la caja
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),

        GestureDetector(
          onTap: disabled
              ? null
              : () async {
                  final selected = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (sheetContext) {
                      return SafeArea(
                        child: SizedBox(
                          height: MediaQuery.of(sheetContext).size.height * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),

                              // Label dentro del modal
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Divider(height: 1),

                              // Lista scrollable de opciones
                              Expanded(
                                child: ListView.builder(
                                  itemCount: options.length,
                                  itemBuilder: (_, index) {
                                    final option = options[index];
                                    return ListTile(
                                      title: Text(option),
                                      onTap: () =>
                                          Navigator.pop(sheetContext, option),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  if (selected != null) {
                    controller.text = selected;
                  }
                },

          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
              color: disabled ? Colors.grey.shade200 : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Texto que se actualiza automáticamente
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (_, __, ___) {
                    final value = controller.text;
                    return Text(
                      value.isNotEmpty ? value : hint,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            value.isNotEmpty ? Colors.black : Colors.grey.shade500,
                      ),
                    );
                  },
                ),

                // Icono de dropdown o spinner de carga si no hay opciones
                disabled
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}