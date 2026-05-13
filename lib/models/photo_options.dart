import 'dart:io';
import 'package:flutter/material.dart';

// ─── DOCUMENTO ────────────────────────────────────────────────────────────────
enum DocumentType {
  cedulaCiudadania,
  pasaporte,
  visaAmericana,
  licenciaConducir,
  carnetEstudiantil,
  hojaDeVida,
}

extension DocumentTypeX on DocumentType {
  String get label {
    switch (this) {
      case DocumentType.cedulaCiudadania:
        return 'Cédula de Ciudadanía';
      case DocumentType.pasaporte:
        return 'Pasaporte';
      case DocumentType.visaAmericana:
        return 'Visa Americana';
      case DocumentType.licenciaConducir:
        return 'Licencia de Conducir';
      case DocumentType.carnetEstudiantil:
        return 'Carnet Estudiantil';
      case DocumentType.hojaDeVida:
        return 'Hoja de Vida';
    }
  }

  String get dimensions {
    switch (this) {
      case DocumentType.cedulaCiudadania:
        return '3 × 4 cm';
      case DocumentType.pasaporte:
        return '3.5 × 4.5 cm';
      case DocumentType.visaAmericana:
        return '5 × 5 cm';
      case DocumentType.licenciaConducir:
        return '2.5 × 3 cm';
      case DocumentType.carnetEstudiantil:
        return '3 × 4 cm';
      case DocumentType.hojaDeVida:
        return '4 × 5 cm';
    }
  }

  IconData get icon {
    switch (this) {
      case DocumentType.cedulaCiudadania:
        return Icons.badge_outlined;
      case DocumentType.pasaporte:
        return Icons.menu_book_outlined;
      case DocumentType.visaAmericana:
        return Icons.language;
      case DocumentType.licenciaConducir:
        return Icons.directions_car_outlined;
      case DocumentType.carnetEstudiantil:
        return Icons.school_outlined;
      case DocumentType.hojaDeVida:
        return Icons.description_outlined;
    }
  }

  String get apiValue => name;
}

// ─── FONDO ────────────────────────────────────────────────────────────────────
enum BackgroundType { azul, blanco }

extension BackgroundTypeX on BackgroundType {
  String get label {
    switch (this) {
      case BackgroundType.azul:
        return 'Azul';
      case BackgroundType.blanco:
        return 'Blanco';
    }
  }

  String get description {
    switch (this) {
      case BackgroundType.azul:
        return 'Para pasaportes y visas';
      case BackgroundType.blanco:
        return 'Estándar para documentos oficiales';
    }
  }

  Color get color {
    switch (this) {
      case BackgroundType.azul:
        return const Color(0xFF1565C0);
      case BackgroundType.blanco:
        return Colors.white;
    }
  }

  String get promptColor {
    switch (this) {
      case BackgroundType.azul:
        return 'solid official blue background';
      case BackgroundType.blanco:
        return 'solid pure white background';
    }
  }

  String get apiValue => name;
}

// ─── MODELO GLOBAL ─────────────────────────────────────────────────────────────
class PhotoOptions {
  File? photo;
  DocumentType? documentType;
  BackgroundType? backgroundType;

  /// Categoría de persona: 'Hombre', 'Mujer', 'Niño' o 'Niña'
  String? outfitCategory;

  /// Nombre del traje seleccionado, e.g. 'Traje Negro Clásico'
  String? outfitName;

  /// Descripción detallada del traje para el prompt de IA
  String? outfitDescription;

  PhotoOptions();

  bool get isComplete =>
      photo != null &&
      documentType != null &&
      backgroundType != null &&
      outfitCategory != null &&
      outfitName != null;

  /// Prompt que se envía al backend → IA
  String buildPrompt() {
    final bgColor = backgroundType == BackgroundType.blanco
        ? 'pure white (#FFFFFF)'
        : 'official document blue (#1E5FA6)';

    final category  = outfitCategory  ?? 'person';
    final attire    = outfitName      ?? 'professional formal attire';
    final detail    = outfitDescription != null ? ': ${outfitDescription}' : '';
    final docLabel  = documentType?.label ?? 'official document';

    return '''Create a professional ID/document photo.
Take the person from the uploaded photo and:
1. Remove the original background completely.
2. Replace it with a solid $bgColor background — no shadows, no gradients.
3. Dress the $category in "$attire"$detail. The attire must look natural, realistic and professional.
4. Produce a close-up portrait/headshot suitable for a $docLabel.
5. The subject must look straight at the camera, perfectly centered in the frame.
6. The image must be well-lit, sharp and professional, as if taken in a studio.
7. Preserve the person's face, skin tone, hair and facial features exactly as in the original photo.
Output: a real-looking professional document photo taken in a photography studio.''';
  }
}
