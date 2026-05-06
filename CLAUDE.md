# Turbo-Admin — CLAUDE.md (Panel web Flutter)

> Subproyecto: panel **web** Flutter para business owners y superAdmins de Turbo.
> **Hereda de:** [`../CLAUDE.md`](../CLAUDE.md) (workspace).
> Este archivo solo describe lo único de este subproyecto.

---

## 1. Responsabilidad end-to-end del subproyecto

**Turbo-Admin** es el panel web para gestores de negocios. Su responsabilidad es:

1. **Gestión de lugares:** CRUD de negocios propios (business owner) o de todos (superAdmin).
2. **Gestión de eventos:** crear/editar eventos asociados a lugares.
3. **Gestión de reservas:** ver, confirmar, cancelar reservas de los negocios propios.
4. **Moderación de reviews:** aprobar/rechazar reseñas pendientes.
5. **Dashboard analítico:** métricas de negocio (visitantes, reservas, rating, traffic horario).
6. **Gestión de usuarios:** solo superAdmin.
7. **Solicitudes de negocio:** flujo de alta de nuevos business owners.
8. **Notificaciones push:** envío masivo a usuarios (Sprint 3).
9. **Categorías:** taxonomía global de lugares (solo superAdmin).
10. **Diagnostics:** herramientas internas de debug y health checks.

**Roles soportados** (vía `admin_auth_repository`):
- `superAdmin` — acceso total
- `businessOwner` — solo a sus propios lugares y métricas
- `moderator` (futuro) — solo moderación de reviews

**Lo que NUNCA debe hacer este subproyecto:**
- ❌ Llamar a Supabase directamente. Todo va vía `Turbo_Core`.
- ❌ Compartir UI con la app móvil sin pasar por `turbo_ui`.
- ❌ Asumir un único rol — siempre validar permisos.
- ❌ Hardcodear breakpoints. Usar tokens responsivos.

---

## 2. Estructura por feature (convención del subproyecto)

> **Diferencia con `Turbo_App`:** aquí no usamos `module/` ni `state_management/<n>_cubit/cubit/`. La estructura es más plana, alineada con el target web.

```
lib/features/<feature>/
├── cubit/
│   ├── <feature>_cubit.dart
│   ├── <feature>_state.dart           # @freezed sealed
│   └── <feature>_cubit.freezed.dart
├── pages/
│   ├── <feature>_page.dart            # página principal de la feature
│   └── <feature>_detail_page.dart     # opcional
├── widgets/                           # widgets locales de la feature
│   └── <widget>.dart
└── utils/                             # opcional
    └── <utility>.dart
```

Features actuales:

```
features/
├── auth                  ✅ login + roles
├── business_requests     ✅ alta de business owners
├── categories            ✅ CRUD categorías (superAdmin)
├── dashboard             ⚠️ Cubit existe, falta validar con datos reales
├── diagnostics           ✅ health checks internos
├── events                ✅ CRUD eventos
├── places                ⚠️ Falta autocompletado de direcciones (Google Places)
├── reservations          ✅ gestión de reservas
├── reviews               ✅ moderación
└── users                 ✅ gestión usuarios (superAdmin)
```

Pendiente de crear: `notifications/` (Sprint 3 — `admin-push`).

---

## 3. Estructura compartida (`lib/core/` y `lib/di/`)

```
lib/
├── core/
│   ├── config/             # endpoints, feature flags
│   ├── error/              # error handling global
│   ├── firebase/           # legacy — migrar a Supabase
│   ├── state_management/   # cubits compartidos (auth, theme)
│   ├── theme/              # tema web (colores, breakpoints)
│   ├── usecases/           # use cases compartidos
│   ├── utils/              # helpers
│   └── widgets/            # componentes UI reusables
├── app/                    # configuración de la app + router
├── di/
│   └── injection.dart      # GetIt config
└── main.dart
```

---

## 4. Patrones específicos del Admin

### 4.1 Cubit + State (mismo patrón que App)

```dart
@freezed
sealed class PlacesAdminState with _$PlacesAdminState {
  const factory PlacesAdminState.initial() = PlacesAdminInitial;
  const factory PlacesAdminState.loading() = PlacesAdminLoading;
  const factory PlacesAdminState.loaded({required List<Place> places}) = PlacesAdminLoaded;
  const factory PlacesAdminState.error({required String message}) = PlacesAdminError;
}
```

### 4.2 Validación de permisos por feature

```dart
// En cada cubit/page que requiere rol
final authState = context.read<AuthCubit>().state;
if (authState is! Authenticated) {
  context.router.replace(SignInRoute());
  return;
}
if (authState.user.role != UserRole.superAdmin) {
  showDialog(context: context, builder: (_) => UnauthorizedDialog());
  return;
}
```

### 4.3 Layouts responsivos (web)

> **Diferencia clave vs App:** este subproyecto corre en navegadores. Usar breakpoints, no asumir mobile.

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 600) return mobile;
    if (width < 1024) return tablet;
    return desktop;
  }
}
```

**Breakpoints estándar:**
- `mobile`: < 600px
- `tablet`: 600 – 1023px
- `desktop`: ≥ 1024px

### 4.4 Routing (auto_route web)

Mismas reglas que la App: `auto_route ^9.2.2`, `@RoutePage()`, `context.router.push(XRoute())`, `maybePop()`.

Diferencia: el router del Admin tiene **guards de roles** que la App no necesita.

### 4.5 Theming (tema propio)

A diferencia de la App, el Admin tiene su propio tema (`lib/core/theme/`) con foco en legibilidad de tablas, dashboards y formularios.

- Usar tokens de `core/theme/`, no `turbo_ui` directamente (`turbo_ui` está optimizado para mobile).
- Permitido cierto solapamiento con la paleta de `turbo_ui` (consistencia de marca).

---

## 5. Tests del Admin

### Estructura
```
test/
├── features/
│   └── <feature>/
│       ├── <feature>_cubit_test.dart
│       └── <feature>_page_test.dart    # widget tests críticos
└── core/
    └── ...
```

### Cobertura mínima
- Cubits: 90%
- Use Cases: 80%
- Páginas críticas (dashboard, places CRUD): 70%

### Mocks
- **Supabase nunca mockeado directo** — siempre vía repos del Core.
- Mockear `<X>Repository` o use cases.

---

## 6. Reglas inquebrantables

1. **Validación de roles obligatoria** en cada feature sensible.
2. **No usar Supabase directo** — siempre repos del Core.
3. **Layouts responsive** — sin asumir resolución fija.
4. **States freezed sealed** + switch exhaustivo.
5. **DI en `lib/di/injection.dart`** con GetIt.
6. **Build runner** tras tocar `@freezed` o `auto_route`.
7. **Sin `firebase_*`** en código nuevo (solo legacy en `core/firebase/`, en migración a Supabase).

---

## 7. Comandos

```bash
# Desde /Turbo-Admin
flutter pub get

# Code generation
dart run build_runner build --delete-conflicting-outputs

# Run web
flutter run -d chrome

# Build web
flutter build web --release

# Tests
flutter test
flutter test --coverage

# Análisis
flutter analyze
```

---

## 8. Estado actual del subproyecto (verificado)

| Feature | Estado | Notas |
|---|---|---|
| `auth` | ✅ Completo | Roles funcionando |
| `business_requests` | ✅ Completo | — |
| `categories` | ✅ Completo | — |
| `dashboard` | ⚠️ Parcial | Cubit existe, falta validar conexión real con `AnalyticsServiceSupabase` y tests |
| `diagnostics` | ✅ Completo | — |
| `events` | ✅ Completo | — |
| `places` | ⚠️ Falta | Autocompletado Google Places (depende del Sprint 2: `google-places-api`) |
| `reservations` | ✅ Completo | — |
| `reviews` | ✅ Completo | Moderación funcionando |
| `users` | ✅ Completo | — |
| `notifications` | ❌ No existe | Sprint 3 (`admin-push`) |

---

## 9. Cómo añadir una nueva feature en Admin (checklist)

1. Verificar que el repositorio en Core está disponible.
2. Crear `lib/features/<feature>/` con la estructura estándar.
3. Implementar cubit + state freezed sealed.
4. Crear páginas con layouts responsive.
5. Validación de roles si aplica.
6. Registrar en `lib/di/injection.dart`.
7. Registrar ruta en el router (con guards de rol si aplica).
8. Tests: `test/features/<feature>/`.
9. Ejecutar build_runner.
10. Verificar con `flutter analyze`.

---

## 10. Referencias

- **Workspace** (paraguas): [`../CLAUDE.md`](../CLAUDE.md)
- **Core** (lógica de negocio): [`../Turbo_Core/core/CLAUDE.md`](../Turbo_Core/core/CLAUDE.md)
- **Sprints:** [`../.claude/sprints/`](../.claude/sprints/)
- **Sistema agéntico:** [`../.claude/`](../.claude/)
