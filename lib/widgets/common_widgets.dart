import 'package:flutter/material.dart';

const Color kPurple      = Color(0xFF6C3CE1);
const Color kPurpleLight = Color(0xFF9B72EF);
const Color kBg          = Color(0xFFF5F3FF);
const Color kCard        = Colors.white;

class StepIndicator extends StatelessWidget {
  final int currentStep; // 0-indexed  (0 = Foto … 4 = Resultado)

  static const _labels = ['Foto', 'Documento', 'Fondo', 'Traje', 'Resultado'];

  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Línea conectora
            final leftDone = (i ~/ 2) < currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 2,
                margin: const EdgeInsets.only(bottom: 22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: leftDone
                      ? const LinearGradient(colors: [kPurple, kPurpleLight])
                      : null,
                  color: leftDone ? null : const Color(0xFFE5E7EB),
                ),
              ),
            );
          }

          final step   = i ~/ 2;
          final done   = step < currentStep;
          final active = step == currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active ? kPurple : const Color(0xFFE5E7EB),
                  boxShadow: active
                      ? [BoxShadow(color: kPurple.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)]
                      : [],
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : Text(
                          '${step + 1}',
                          style: TextStyle(
                            color: active ? Colors.white : const Color(0xFF9CA3AF),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _labels[step],
                style: TextStyle(
                  fontSize: 9,
                  color: done || active ? kPurple : const Color(0xFF9CA3AF),
                  fontWeight: active ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Tarjeta de opción reutilizable ─────────────────────────────────────────
class OptionCard extends StatelessWidget {
  final bool     selected;
  final VoidCallback onTap;
  final Widget   leading;
  final String   title;
  final String?  subtitle;

  const OptionCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.leading,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? kPurple.withOpacity(0.07) : kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? kPurple : const Color(0xFFE5E7EB),
            width: selected ? 2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: selected ? kPurple : const Color(0xFF1A1A2E),
                      )),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? kPurple : Colors.transparent,
                border: Border.all(
                  color: selected ? kPurple : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Botón primario ──────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String   label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
        label: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFD1D5DB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}
