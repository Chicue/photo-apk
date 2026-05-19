# Reglas Flutter App

## Contexto del proyecto

Aplicación Flutter para generación profesional de imágenes con IA.

Objetivo:

Crear una experiencia premium, fluida y profesional para transformar imágenes usando inteligencia artificial.

Stack:

- Flutter
- Dart
- Laravel API REST
- Image upload
- Cache de imágenes
- Responsive UI

---

## Arquitectura Flutter

Siempre usar arquitectura limpia.

Separar:

- screens
- widgets
- services
- models
- providers/controllers
- utils

No mezclar lógica de negocio dentro de Widgets.

---

## Estado

Preferir:

- Riverpod
o
- Provider

Nunca:

- lógica compleja en UI
- setState excesivo

---

## API

Toda comunicación backend:

- Debe ir en Services.
- Manejar errores correctamente.
- Timeout handling.
- Retry básico.

Nunca:
- llamadas API directamente en Widgets.

---

## UI / UX

Diseño:

- Premium
- Minimalista
- Profesional
- Moderno

Siempre:

- Responsive
- Buen spacing
- Buen typography
- Skeleton loading
- Estados vacíos
- Loading states

Animaciones:
- Suaves
- Profesionales
- No excesivas

---

## Imágenes

Siempre:

- Optimizar memoria
- Lazy loading
- Cache
- Compression antes upload

Nunca:
- bloquear UI
- render innecesario
- imágenes pesadas sin optimización

---

## Código

Siempre:

- Código producción
- Widgets reutilizables
- Clean architecture
- Explicar dónde pegar archivos
- Mantener rendimiento

Cuando modifiques código:

1. Explica qué cambia
2. Muestra archivo completo
3. Mantén arquitectura limpia
4. Evita romper funcionalidades existentes

No inventar paquetes inexistentes.
No usar soluciones temporales.
