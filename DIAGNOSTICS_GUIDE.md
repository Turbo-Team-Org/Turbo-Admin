# Guía de Diagnóstico - Turbo Admin Panel

## Problema Identificado

Las pantallas del admin panel no muestran datos porque el paquete `core` de Turbo no se está inicializando correctamente.

## Herramientas de Diagnóstico Implementadas

### 1. Logging Mejorado en `initUIDependencies`

He añadido logging detallado en `lib/di/injection.dart` que mostrará:

```
🔄 Iniciando configuración de dependencias del Admin Panel...
✅ Firebase verificado como inicializado
✅ Firebase App obtenido: [default]
🔄 Inicializando dependencias del core...
✅ Dependencias del core inicializadas
✅ PlaceRepository registrado correctamente
✅ EventRepository registrado correctamente
... (otros repositorios)
🔄 Registrando Cubits del Admin Panel...
✅ DashboardCubit registrado
... (otros cubits)
🎉 Inicialización del Admin Panel completada exitosamente
```

### 2. Página de Diagnóstico Completa

Creé `lib/features/diagnostics/pages/diagnostics_page.dart` que ejecuta pruebas exhaustivas:

- ✅ Verificación de Firebase
- ✅ Verificación de GetIt
- ✅ Verificación de repositorios del core
- ✅ Verificación de Cubits del UI
- ✅ Pruebas de carga de datos

### 3. Widget de Diagnóstico del Sistema

`lib/core/widgets/system_diagnostics_widget.dart` proporciona diagnóstico en tiempo real.

### 4. Dashboard Mejorado

La página del dashboard ahora:

- Usa BLoC pattern correctamente
- Muestra estados de carga, error y éxito
- Incluye información de diagnóstico
- Maneja errores de forma elegante

## Cómo Diagnosticar el Problema

### Paso 1: Verificar Logs de Inicialización

1. Ejecuta la aplicación:

   ```bash
   flutter run -d chrome --web-port 8080
   ```

2. Abre las herramientas de desarrollador del navegador (F12)

3. Ve a la pestaña "Console" y busca los logs de inicialización

4. Identifica dónde falla la inicialización:
   - ❌ Si no ves "✅ Firebase verificado como inicializado" → Problema con Firebase
   - ❌ Si no ves "✅ Dependencias del core inicializadas" → Problema con `initCoreDependencies`
   - ❌ Si no ves repositorios registrados → Problema con el paquete core

### Paso 2: Usar la Página de Diagnóstico

1. Navega a la página de diagnóstico (si está disponible en el router)
2. Observa qué pruebas fallan
3. Los errores te dirán exactamente qué dependencia no está disponible

### Paso 3: Verificar el Dashboard

1. Ve al dashboard principal
2. Si ves "Error al cargar datos", presiona el botón de detalles
3. El mensaje de error te dará información específica

## Posibles Problemas y Soluciones

### Problema 1: `initCoreDependencies` no existe o falla

**Síntomas:**

```
❌ Error durante la inicialización de dependencias: NoSuchMethodError: The method 'initCoreDependencies' was called on null.
```

**Solución:**

1. Verificar que el paquete `core` esté correctamente importado
2. Verificar que `initCoreDependencies` esté exportado en `package:core/core.dart`
3. Verificar la versión del commit del paquete core en `pubspec.yaml`

### Problema 2: Repositorios no registrados

**Síntomas:**

```
❌ PlaceRepository NO está registrado: Object/factory with type PlaceRepository is not registered inside GetIt.
```

**Solución:**

1. El paquete core no está registrando los repositorios correctamente
2. Verificar la implementación de `initCoreDependencies` en el paquete core
3. Asegurar que Firebase esté pasándose correctamente

### Problema 3: Firebase no inicializado

**Síntomas:**

```
❌ Firebase debe estar inicializado antes de configurar las dependencias
```

**Solución:**

1. Verificar configuración en `web/index.html`
2. Verificar credenciales en `firebase_config.dart`
3. Verificar conexión a internet

### Problema 4: Versión incorrecta del paquete core

**Síntomas:**

- Métodos no encontrados
- Tipos no disponibles
- Errores de compilación

**Solución:**

1. Verificar el commit hash en `pubspec.yaml`:

   ```yaml
   core:
     git:
       url: git@github.com:Turbo-Team-Org/Turbo_Core.git
       ref: 1cce6bfcb97ac3c0592836038893c6b832776816 # ← Verificar este hash
       path: core
   ```

2. Actualizar a la versión más reciente:
   ```bash
   flutter pub upgrade
   ```

## Comandos Útiles para Diagnóstico

### Verificar dependencias

```bash
flutter pub deps
```

### Limpiar y reinstalar dependencias

```bash
flutter clean
flutter pub get
```

### Ejecutar con logs detallados

```bash
flutter run -d chrome --web-port 8080 --verbose
```

### Verificar el paquete core específicamente

```bash
flutter pub deps | grep core
```

## Próximos Pasos

1. **Ejecutar diagnóstico completo** usando las herramientas implementadas
2. **Identificar el punto exacto de falla** usando los logs
3. **Verificar la implementación del paquete core** si es necesario
4. **Actualizar la versión del core** si hay incompatibilidades
5. **Implementar datos de prueba** si los repositorios están vacíos

## Contacto y Soporte

Si el problema persiste después de seguir esta guía:

1. Captura los logs completos de la consola
2. Ejecuta la página de diagnóstico y captura los resultados
3. Verifica la implementación de `initCoreDependencies` en el paquete core
4. Considera crear datos de prueba para verificar la funcionalidad

---

**Última actualización**: $(date)
**Herramientas implementadas**: ✅ Logging, ✅ Diagnóstico, ✅ Dashboard mejorado
