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

  String get apiValue => name; // e.g. "cedulaCiudadania"
}

// ─── FONDO ────────────────────────────────────────────────────────────────────
enum BackgroundType { azul, blanco, gris, rojo, verde }

extension BackgroundTypeX on BackgroundType {
  String get label {
    switch (this) {
      case BackgroundType.azul:
        return 'Azul';
      case BackgroundType.blanco:
        return 'Blanco';
      case BackgroundType.gris:
        return 'Gris';
      case BackgroundType.rojo:
        return 'Rojo';
      case BackgroundType.verde:
        return 'Verde';
    }
  }

  Color get color {
    switch (this) {
      case BackgroundType.azul:
        return const Color(0xFF1565C0);
      case BackgroundType.blanco:
        return Colors.white;
      case BackgroundType.gris:
        return const Color(0xFF9E9E9E);
      case BackgroundType.rojo:
        return const Color(0xFFC62828);
      case BackgroundType.verde:
        return const Color(0xFF2E7D32);
    }
  }

  String get promptColor {
    switch (this) {
      case BackgroundType.azul:
        return 'solid blue background';
      case BackgroundType.blanco:
        return 'solid white background';
      case BackgroundType.gris:
        return 'solid gray background';
      case BackgroundType.rojo:
        return 'solid red background';
      case BackgroundType.verde:
        return 'solid green background';
    }
  }

  String get apiValue => name;
}

// ─── TRAJE ────────────────────────────────────────────────────────────────────
enum OutfitType { hombre, mujer }

extension OutfitTypeX on OutfitType {
  String get label {
    switch (this) {
      case OutfitType.hombre:
        return 'Traje Hombre';
      case OutfitType.mujer:
        return 'Traje Mujer';
    }
  }

  String get description {
    switch (this) {
      case OutfitType.hombre:
        return 'Traje formal de caballero';
      case OutfitType.mujer:
        return 'Traje formal de dama';
    }
  }

  IconData get icon {
    switch (this) {
      case OutfitType.hombre:
        return Icons.person;
      case OutfitType.mujer:
        return Icons.person_2;
    }
  }

  String get promptHint {
    switch (this) {
      case OutfitType.hombre:
        return 'wearing formal business suit and tie, professional attire';
      case OutfitType.mujer:
        return 'wearing formal business blazer, professional attire';
    }
  }

  String get apiValue => name;
}

// ─── MODELO GLOBAL ─────────────────────────────────────────────────────────────
class PhotoOptions {
  File? photo;
  DocumentType? documentType;
  BackgroundType? backgroundType;
  OutfitType? outfitType;

  PhotoOptions();

  bool get isComplete =>
      photo != null &&
      documentType != null &&
      backgroundType != null &&
      outfitType != null;

  /// Prompt que se envía al backend → IA
  String buildPrompt() {
    final bgDescription = backgroundType == BackgroundType.blanco
        ? 'pure white (#FFFFFF)'
        : backgroundType == BackgroundType.azul
        ? 'official blue (#1E5FA6)'
        : backgroundType?.promptColor ?? 'white';

    final attireDescription =
        outfitType?.description ?? 'professional formal attire';

    final documentLabel = documentType?.label ?? 'document';

    return '''Create a professional ID/document photo. 
Take the person from the uploaded photo and:
1. Remove the original background completely.
2. Replace it with a solid $bgDescription background.
3. Dress the person in a $attireDescription. The attire should look natural and professional.
4. The photo should be a close-up portrait/headshot suitable for a $documentLabel document.
5. The person should be looking straight at the camera, centered in the frame.
6. The photo should be well-lit, sharp, and professional looking.
7. Keep the person's face, skin tone, and features exactly as they are in the original photo.
Make it look like a real professional document photo taken in a studio.''';
  }
}
