import 'package:flutter/material.dart';
import '../models/photo_options.dart';
import '../widgets/common_widgets.dart';

class Step4Outfit extends StatefulWidget {
  final PhotoOptions options;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Outfit({
    super.key,
    required this.options,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4Outfit> createState() => _Step4OutfitState();
}

class _Step4OutfitState extends State<Step4Outfit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text('Tipo de traje',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        const Text('La IA ajustará el vestuario de forma profesional',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
        const SizedBox(height: 28),

        // ── Tarjetas grandes ────────────────────────────────────────────
        Row(
          children: OutfitType.values.map((outfit) {
            final selected = widget.options.outfitType == outfit;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => widget.options.outfitType = outfit),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  margin: EdgeInsets.only(
                    left:  outfit == OutfitType.hombre ? 0 : 8,
                    right: outfit == OutfitType.hombre ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selected ? kPurple : Colors.white,
                    border: Border.all(
                      color: selected ? kPurple : const Color(0xFFE5E7EB),
                      width: selected ? 2 : 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: selected
                            ? kPurple.withOpacity(0.25)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ícono grande
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white.withOpacity(0.2)
                              : kPurple.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(outfit.icon,
                            size: 38,
                            color: selected ? Colors.white : kPurple),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        outfit.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF1A1A2E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        outfit.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: selected
                              ? Colors.white.withOpacity(0.8)
                              : const Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      if (selected)
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 16),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // ── Nota ────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFD0FF)),
          ),
          child: const Row(
            children: [
              Icon(Icons.auto_fix_high, color: kPurple, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'La IA cambiará el vestuario manteniendo tu rostro original',
                  style: TextStyle(fontSize: 12, color: Color(0xFF374151)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        PrimaryButton(
          label: 'Generar foto profesional',
          icon: Icons.auto_awesome,
          onPressed: widget.options.outfitType != null ? widget.onNext : null,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
