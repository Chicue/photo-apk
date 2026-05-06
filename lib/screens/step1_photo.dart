import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/photo_options.dart';
import '../widgets/common_widgets.dart';

class Step1Photo extends StatefulWidget {
  final PhotoOptions options;
  final VoidCallback onNext;

  const Step1Photo({super.key, required this.options, required this.onNext});

  @override
  State<Step1Photo> createState() => _Step1PhotoState();
}

class _Step1PhotoState extends State<Step1Photo> {
  final _picker = ImagePicker();
  bool _dragging = false;

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 90);
    if (picked != null) {
      setState(() => widget.options.photo = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = widget.options.photo != null;

    return Column(
      children: [
        const SizedBox(height: 8),
        const Text('Sube tu foto',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        const Text(
          'Foto tipo retrato con buena iluminación',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 24),

        // ── Zona de carga ───────────────────────────────────────────────
        GestureDetector(
          onTap: () => _pick(ImageSource.gallery),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _dragging
                  ? kPurple.withOpacity(0.08)
                  : hasPhoto
                      ? Colors.transparent
                      : const Color(0xFFF9F8FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _dragging
                    ? kPurple
                    : hasPhoto
                        ? kPurple.withOpacity(0.4)
                        : const Color(0xFFDDD8F8),
                width: _dragging ? 2 : 1.5,
                style: hasPhoto ? BorderStyle.solid : BorderStyle.solid,
              ),
            ),
            child: hasPhoto
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(widget.options.photo!, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => setState(() => widget.options.photo = null),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: kPurple.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_photo_alternate_outlined,
                            size: 32, color: kPurple),
                      ),
                      const SizedBox(height: 14),
                      const Text('Arrastra tu foto aquí',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF374151))),
                      const SizedBox(height: 4),
                      const Text('o haz clic para seleccionar  •  JPG, PNG',
                          style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 14),

        // ── Botón cámara ────────────────────────────────────────────────
        if (!hasPhoto)
          TextButton.icon(
            onPressed: () => _pick(ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined, size: 16),
            label: const Text('Tomar foto con la cámara'),
            style: TextButton.styleFrom(foregroundColor: kPurple),
          ),

        const Spacer(),

        PrimaryButton(
          label: 'Continuar',
          icon: Icons.arrow_forward_rounded,
          onPressed: hasPhoto ? widget.onNext : null,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
