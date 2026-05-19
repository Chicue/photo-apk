# Contexto del Proyecto Flutter

Proyecto:

Aplicación móvil Flutter para generación de fotografías profesionales mediante inteligencia artificial.

Objetivo:

Transformar fotografías normales en fotos tipo documento profesional, hoja de vida, perfil corporativo o fotografía formal de alta calidad.

La aplicación debe sentirse premium, rápida y profesional.

---

## Flujo principal

1. Usuario ingresa a la app.

2. Usuario sube una foto.

3. Usuario selecciona tipo de documento.

Ejemplos:
- Hoja de vida
- Visa
- Pasaporte
- Perfil corporativo
- Documento formal

4. Usuario selecciona fondo.

Ejemplos:
- Blanco
- Azul

5. Usuario selecciona tipo de ropa.

Ejemplos:
- Formal hombre
- Formal mujer
- Médico
- Ejecutivo
- Casual profesional

6. Sistema analiza autenticación.

Si usuario está logueado:
→ continúa a pantalla de vista previa.

Si NO está logueado:
→ enviar a Login/Register.

7. Pantalla Login/Register.

8. Usuario inicia sesión o crea cuenta.

9. Pantalla de vista previa.

Sistema analiza créditos:

Si usuario tiene créditos:
- Consume 1 crédito.
- Imagen se genera SIN marca de agua.

Si usuario NO tiene créditos:
- Imagen se genera CON marca de agua.

10. Flutter envía imagen + configuraciones al backend Laravel.

11. Backend procesa IA.

12. Resultado generado.

13. Usuario ve comparación antes/después.

14. Usuario puede exportar HD.

15. Sistema guarda historial.

16. Si usuario no tiene créditos:
→ puede comprar créditos.

---

## Pantallas principales

- Splash
  splash_screen.dart

- Login
  login_screen.dart

- Register
  register_screen.dart

- Home / Wizard principal
  photo_wizard.dart

- Paso 1: Subir foto
  step1_photo.dart

- Paso 2: Tipo documento
  step2_document.dart

- Paso 3: Selección fondo
  step3_background.dart

- Paso 4: Selección ropa
  step4_outfit.dart

- Paso 5: Resultado
  step5_result.dart

- History

- Profile

- Payments

---

## UI / UX Deseada

Diseño:
- Premium
- Minimalista
- Moderno
- Profesional

Experiencia:
- Muy simple de usar
- Wizard intuitivo
- Carga rápida
- Buen feedback visual

Animaciones:
- Suaves
- Elegantes
- Profesionales

No usar UI recargada.

---

## Backend

La aplicación consume una API REST Laravel 12.

Toda la lógica de generación ocurre en backend.

Flutter solo:
- Envía datos
- Muestra progreso
- Presenta resultado
- Maneja autenticación
- Maneja créditos