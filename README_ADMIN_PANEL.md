# 🚀 Turbo Admin Panel

Panel de administración para dueños de lugares de la plataforma Turbo.

## 🎯 Estado Actual

### ✅ **Completamente Implementado**

- 🎨 **UI/UX**: Branding oficial, logos SVG/PNG, fuente MuseoSans
- 🔐 **Autenticación**: Sistema completo con login/registro
- 🏗️ **Arquitectura**: Clean Architecture + BLoC + GoRouter
- 📱 **Responsive**: Desktop y mobile ready
- 🎪 **Splash Screen**: Animada con branding Turbo

### ⏳ **Pendiente del Core**

El admin panel está **95% completo** pero necesita que el core implemente:

- `AdminAuthRepository` para autenticación de dueños de lugares
- Separación de usuarios regulares vs administradores
- Filtros por ownership en repositorios existentes

## 📋 Documentación

- **[CORE_REQUIREMENTS.md](./CORE_REQUIREMENTS.md)**: Requerimientos detallados para el equipo del core
- **[ADMIN_PANEL_READY.md](./ADMIN_PANEL_READY.md)**: Estado actual de la UI implementada

## 🔧 Instalación

```bash
# Instalar dependencias
flutter pub get

# Generar archivos de build_runner
flutter packages pub run build_runner build

# Ejecutar en web
flutter run -d chrome
```

## 🏗️ Arquitectura

```
lib/
├── core/
│   ├── widgets/           # Componentes reutilizables
│   ├── firebase/          # Configuración Firebase
│   └── repositories/      # [Pendiente del core]
├── features/
│   ├── auth/             # ✅ Autenticación completa
│   ├── dashboard/        # ✅ Dashboard con métricas
│   ├── places/           # ✅ Gestión de lugares
│   ├── events/           # ✅ Gestión de eventos
│   ├── reviews/          # ✅ Moderación de reseñas
│   ├── categories/       # ✅ Gestión de categorías
│   └── users/            # ✅ Gestión de usuarios
├── di/                   # ✅ Inyección de dependencias
└── app/                  # ✅ Router y tema
```

## 🎨 Componentes Destacados

### Logos Flexibles

```dart
TurboLogo.svg()          // Logo SVG principal
TurboLogo.png()          // Logo PNG alternativo
TurboLogoSmall()         // Para sidebar
TurboLogoAnimated()      // Para splash screens
```

### Formularios con Branding

```dart
TurboTextField()         // Campos con diseño Turbo
TurboButton()           // Botones con branding oficial
```

## 🚀 Funcionalidades

- ✅ **Dashboard**: Métricas, gráficos, estadísticas
- ✅ **Lugares**: CRUD completo con formularios
- ✅ **Eventos**: Gestión de eventos por lugar
- ✅ **Reviews**: Moderación y aprobación
- ✅ **Categorías**: Gestión de categorías
- ✅ **Usuarios**: Administración de accesos

## 🔐 Seguridad

- ✅ Protección de rutas con `AuthWrapper`
- ✅ Verificación de autenticación en navegación
- ✅ Redirección automática a login
- ⏳ Filtros por ownership (pendiente del core)

## 📱 Responsive Design

- ✅ Optimizado para desktop (1200px+)
- ✅ Adaptado para tablet (768px+)
- ✅ Sidebar colapsible
- ✅ Formularios adaptativos

## 🎯 Próximos Pasos

1. **Core Team**: Implementar `AdminAuthRepository` según [CORE_REQUIREMENTS.md](./CORE_REQUIREMENTS.md)
2. **Admin Panel**: Migración rápida (30 minutos) cuando esté listo
3. **Testing**: Pruebas completas del flujo de autenticación
4. **Deploy**: Listo para producción

## 🤝 Contribución

El admin panel sigue Clean Architecture y buenas prácticas:

- Feature-first approach
- BLoC para estado
- Widgets reutilizables
- Tipografía y colores consistentes

## 📞 Contacto

Para cualquier duda sobre la implementación o integración con el core, revisar la documentación en los archivos `.md` del proyecto.

---

**Estado**: ✅ UI Completa | ⏳ Esperando Core | 🚀 95% Listo
