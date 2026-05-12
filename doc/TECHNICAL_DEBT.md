# Turbo-Admin — Deuda Técnica

> Registro vivo de deuda técnica del subproyecto **Turbo-Admin** (panel web Flutter).
> Cada entrada debe incluir: contexto, alcance, riesgo y próximo paso accionable.

---

## TD-001 · i18n no implementada en Turbo-Admin

| Campo | Valor |
|---|---|
| **Estado** | 🟡 Aceptada (deferida) |
| **Detectada** | Sprint 2 (cierre S2-T1 `google-places-api`) |
| **Última revisión** | 2026-05-12 |
| **Owner sugerido** | Equipo Admin |

### Contexto

`Turbo-Admin` no tiene la stack de internacionalización configurada:

- No depende de `flutter_localizations` ni `intl_translation`.
- No hay carpeta `lib/**/l10n/` ni archivos `.arb`.
- No existe paso `flutter gen-l10n` en el flujo de build.
- Todas las strings visibles del panel (categorías, dashboard, reviews, lugares, autenticación, etc.) están **hardcodeadas en español** dentro de los widgets.

A diferencia de `Turbo_App` (móvil), `Turbo-Admin/CLAUDE.md` **no exige** i18n
como regla inquebrantable, dado que el panel es una herramienta interna usada por
business owners y administradores hispanohablantes.

### Decisión durante S2-T1

Durante el cierre de `google-places-api` se evaluó migrar las strings de la
feature (autocompletado de direcciones) a un sistema de l10n. Se descartó:

- Bootstrappear l10n para **una sola feature** introduciría inconsistencia con el
  resto del subproyecto (todo `lib/features/` sigue con strings literales).
- El alcance de un bootstrap real (configuración + migración de todo el panel)
  excede ampliamente el sprint y la feature.
- El riesgo de mantener strings hardcodeadas es bajo en un panel mono-lenguaje.

En la feature `google-places-api`, las strings nuevas relacionadas al
autocompletado están encapsuladas en el widget
`lib/features/places/widgets/address_autocomplete_field.dart` y aceptan
`labelText`/`hintText` como parámetros, lo que facilitará el reemplazo cuando
se haga el bootstrap.

### Alcance

- `lib/features/auth/`
- `lib/features/business_requests/`
- `lib/features/categories/`
- `lib/features/dashboard/`
- `lib/features/diagnostics/`
- `lib/features/events/`
- `lib/features/places/`
- `lib/features/reservations/`
- `lib/features/reviews/`
- `lib/features/users/`
- `lib/core/widgets/`

En resumen: prácticamente todo el árbol `lib/`.

### Riesgo

- **Producto/UX:** bajo. Audiencia hispanohablante; sin demanda de multi-idioma.
- **Mantenibilidad:** medio. Cambios de copy requieren tocar widgets.
- **QA:** bajo. Strings estables.

### Próximo paso

Cuando el roadmap del Admin priorice un sprint específico de hardening
(post-MVP), planificar:

1. ADR que adopte `flutter_localizations` + `gen-l10n` (alineado con
   `Turbo_App` para reutilizar convenciones).
2. Setear `lib/app/l10n/arb/{es,en}.arb` con migración incremental por
   feature.
3. Validar con `dart analyze` + tests que ninguna pantalla quedó con literal.
4. Actualizar `Turbo-Admin/CLAUDE.md` para promover i18n a regla
   inquebrantable.

### Referencias

- `/CLAUDE.md` §8 — convención i18n a nivel workspace.
- `Turbo_App/CLAUDE.md` §3.5 — referencia de cómo está hecho en la App móvil.
- `Turbo-Admin/CLAUDE.md` — sin sección de i18n hoy.

---

## TD-002 · Pendientes verificables tras `/review` S2-T1

| Campo | Valor |
|---|---|
| **Estado** | 🟢 No bloqueante |
| **Detectada** | 2026-05-12 |

### Hallazgos no bloqueantes pendientes (del subproyecto, fuera del PR)

- `flutter analyze` reporta ~245 issues preexistentes en archivos no tocados
  por la feature (`reviews`, `dashboard`, `theme_service`, etc.), principalmente
  `withOpacity` deprecated, `prefer_const_constructors` y `unused_import`.
- `test_timestamp_fix.dart` en raíz tiene 14 issues; archivo de utilería
  legacy. Evaluar si moverlo a `tool/` o eliminarlo.
- Cobertura global de `lib/` ronda 36% por falta de tests en features sin
  estrenar (events, reservations, dashboard).

### Próximo paso

Cleanup sprint específico tras MVP: barrido global de `withOpacity` →
`withValues`, eliminación de `unused_import`, y subida progresiva de
cobertura.
