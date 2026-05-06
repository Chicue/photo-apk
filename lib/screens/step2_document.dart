import 'package:flutter/material.dart';
import '../models/photo_options.dart';
import '../widgets/common_widgets.dart';

class Step2Document extends StatefulWidget {
  final PhotoOptions options;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step2Document({
    super.key,
    required this.options,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step2Document> createState() => _Step2DocumentState();
}

class _Step2DocumentState extends State<Step2Document> {
  static const _docs = DocumentType.values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text('Tipo de documento',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        const Text('Selecciona el documento para el que necesitas la foto',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
        const SizedBox(height: 16),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _docs.map((doc) {
            final selected = widget.options.documentType == doc;
            return OptionCard(
              selected: selected,
              onTap: () => setState(() => widget.options.documentType = doc),
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? kPurple.withOpacity(0.1)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(doc.icon,
                    color: selected ? kPurple : const Color(0xFF6B7280),
                    size: 22),
              ),
              title: doc.label,
              subtitle: doc.dimensions,
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Continuar',
          icon: Icons.arrow_forward_rounded,
          onPressed:
              widget.options.documentType != null ? widget.onNext : null,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
