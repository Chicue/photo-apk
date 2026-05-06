import 'package:flutter/material.dart';
import '../models/photo_options.dart';
import '../widgets/common_widgets.dart';

class Step3Background extends StatefulWidget {
  final PhotoOptions options;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Background({
    super.key,
    required this.options,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step3Background> createState() => _Step3BackgroundState();
}

class _Step3BackgroundState extends State<Step3Background> {
  static const _bgs = BackgroundType.values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text('Color de fondo',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        const Text('Elige el fondo según el documento requerido',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
        const SizedBox(height: 20),

        // ── Grid de colores ─────────────────────────────────────────────
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _bgs.map((bg) {
            final selected = widget.options.backgroundType == bg;
            return GestureDetector(
              onTap: () => setState(() => widget.options.backgroundType = bg),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? kPurple : const Color(0xFFE5E7EB),
                    width: selected ? 2.5 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    children: [
                      // Muestra del color
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 56,
                        child: Container(
                          color: bg.color,
                          child: bg == BackgroundType.blanco
                              ? Center(
                                  child: Icon(Icons.texture,
                                      color: Colors.grey.shade300, size: 18))
                              : null,
                        ),
                      ),
                      // Nombre
                      Positioned.fill(
                        left: 56,
                        child: Container(
                          color: selected
                              ? kPurple.withOpacity(0.07)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  bg.label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: selected
                                        ? kPurple
                                        : const Color(0xFF1A1A2E),
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(Icons.check_circle,
                                    color: kPurple, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // ── Tip informativo ─────────────────────────────────────────────
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFFF59E0B), size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tip: Visa Americana → Fondo Blanco  •  Cédula/Pasaporte → Fondo Azul',
                  style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        PrimaryButton(
          label: 'Continuar',
          icon: Icons.arrow_forward_rounded,
          onPressed:
              widget.options.backgroundType != null ? widget.onNext : null,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
