# 🔒 Requerimientos para Core: Sistema de Usuarios Administrativos

## 📋 Problemática Actual

El **Admin Panel de Turbo** necesita un sistema de autenticación y autorización separado del sistema de usuarios regulares de la app móvil, ya que:

1. **Usuarios Regulares**: Consumidores que usan la app para descubrir lugares
2. **Usuarios Administrativos**: Dueños de lugares que gestionan sus propios negocios
3. **Super Administradores**: Personal de Turbo con acceso global

Actualmente ambos tipos de usuarios se guardan en la misma colección `users`, lo que genera:

- ❌ Problemas de seguridad y permisos
- ❌ Falta de segmentación por lugar/negocio
- ❌ Imposibilidad de filtrar datos por propietario
- ❌ Riesgo de acceso no autorizado a datos

## 🎯 Solución Requerida

### 1. **Nueva Colección en Firestore**

```
📁 Firestore Collections
├── users/ (usuarios regulares - EXISTENTE)
└── admin_users/ (usuarios administrativos - NUEVA)
    ├── {userId}
    │   ├── email: string
    │   ├── displayName: string
    │   ├── role: "placeOwner" | "superAdmin"
    │   ├── ownedPlaceIds: string[] // IDs de lugares que administra
    │   ├── permissions: Map<string, string[]> // permisos por lugar
    │   ├── createdAt: Timestamp
    │   ├── lastLogin: Timestamp
    │   └── isActive: boolean
```

### 2. **Modelo de Datos AdminUser**

```dart
class AdminUser {
  final String uid;
  final String email;
  final String? displayName;
  final AdminRole role;
  final List<String> ownedPlaceIds;
  final Map<String, List<Permission>> permissions;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  // Métodos de verificación
  bool canManagePlace(String placeId);
  bool hasPermission(String placeId, Permission permission);
  List<String> getManageablePlaceIds();
}

enum AdminRole { placeOwner, superAdmin }

enum Permission {
  readPlace,
  editPlace,
  deletePlace,
  manageEvents,
  viewReviews,
  moderateReviews,
  viewAnalytics,
  manageUsers, // solo para superAdmin
}
```

### 3. **Repositorio AdminAuthRepository**

```dart
abstract class AdminAuthRepository {
  // Autenticación
  Stream<AdminUser?> get authStateChanges;
  Future<AdminUser?> getCurrentAdminUser();
  Future<AdminUser> signInWithEmailAndPassword(String email, String password);
  Future<AdminUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required List<String> ownedPlaceIds,
    AdminRole role = AdminRole.placeOwner,
  });
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);

  // Gestión de permisos
  Future<void> updateOwnedPlaces(String userId, List<String> placeIds);
  Future<void> updatePermissions(String userId, Map<String, List<Permission>> permissions);
  Future<void> toggleUserStatus(String userId, bool isActive);

  // Consultas
  Future<List<AdminUser>> getAdminsByPlaceId(String placeId);
  Future<List<AdminUser>> getAllAdmins(); // solo superAdmin
}
```

### 4. **Modificaciones en Repositorios Existentes**

Los repositorios de **Places**, **Events**, **Reviews** deben ser modificados para:

#### PlaceRepository

```dart
// AGREGAR métodos que filtren por propietario
Future<List<Place>> getPlacesByOwnerId(String ownerId);
Future<Place> updatePlaceOwnership(String placeId, List<String> ownerIds);
```

#### EventRepository

```dart
// AGREGAR filtros por lugar del administrador
Future<List<Event>> getEventsByPlaceIds(List<String> placeIds);
Future<List<Event>> getEventsByAdminUser(String adminUserId);
```

#### ReviewRepository

```dart
// AGREGAR filtros por lugares administrados
Future<List<Review>> getReviewsByPlaceIds(List<String> placeIds);
Future<List<Review>> getPendingReviewsByPlaceIds(List<String> placeIds);
```

### 5. **Security Rules de Firestore**

```javascript
// admin_users collection
match /admin_users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
  allow read: if request.auth != null &&
    get(/databases/$(database)/documents/admin_users/$(request.auth.uid)).data.role == 'superAdmin';
}

// places collection - modificar para verificar ownership
match /places/{placeId} {
  allow read: if request.auth != null;
  allow write: if request.auth != null &&
    (placeId in get(/databases/$(database)/documents/admin_users/$(request.auth.uid)).data.ownedPlaceIds ||
     get(/databases/$(database)/documents/admin_users/$(request.auth.uid)).data.role == 'superAdmin');
}
```

## 🎪 Casos de Uso Específicos

### Dueño de Lugar (placeOwner)

```dart
final adminUser = await adminAuthRepo.getCurrentAdminUser();
if (adminUser?.canManagePlace(placeId) == true) {
  // Puede ver y editar datos del lugar
  final place = await placeRepo.getPlaceById(placeId);
  final events = await eventRepo.getEventsByPlaceId(placeId);
  final reviews = await reviewRepo.getReviewsByPlaceId(placeId);
}
```

### Super Administrador

```dart
final adminUser = await adminAuthRepo.getCurrentAdminUser();
if (adminUser?.role == AdminRole.superAdmin) {
  // Acceso total a todos los datos
  final allPlaces = await placeRepo.getAllPlaces();
  final allAdmins = await adminAuthRepo.getAllAdmins();
}
```

## 📁 Estructura de Exportación Requerida

```dart
// core/lib/core.dart
export 'src/repositories/admin_auth_repository.dart';
export 'src/models/admin_user.dart';
export 'src/enums/admin_role.dart';
export 'src/enums/permission.dart';

// Los repositorios existentes también deben exportar métodos nuevos
export 'src/repositories/place_repository.dart'; // con métodos de ownership
export 'src/repositories/event_repository.dart'; // con filtros por lugar
export 'src/repositories/review_repository.dart'; // con filtros por lugar
```

## ⚡ Migración de Datos

Para usuarios administrativos existentes en `users`, crear un script de migración:

```dart
Future<void> migrateExistingAdmins() async {
  // 1. Identificar usuarios con role 'admin' en users collection
  // 2. Crear documentos en admin_users collection
  // 3. Asignar ownedPlaceIds basándose en datos existentes
  // 4. Mantener users collection solo para usuarios regulares
}
```

## 🚀 Prioridad de Implementación

1. **ALTA**: AdminUser model + AdminAuthRepository
2. **ALTA**: Modificaciones en security rules
3. **MEDIA**: Filtros por ownership en repositorios existentes
4. **BAJA**: Script de migración de datos

## 📞 Necesidades del Admin Panel

Una vez implementado en el core, el admin panel necesitará:

1. **AdminAuthRepository** para autenticación
2. **Métodos filtrados** en los repositorios existentes
3. **Verificación de permisos** en cada operación
4. **Manejo de errores** específicos de autorización

## 🎯 Resultado Esperado

Con estos cambios, el admin panel podrá:

- ✅ Autenticar dueños de lugares por separado
- ✅ Mostrar solo datos de lugares que administran
- ✅ Prevenir acceso no autorizado
- ✅ Mantener separación clara entre usuarios y admins
- ✅ Escalar con múltiples dueños por lugar

---

**Nota**: Esta separación es crítica para la seguridad y escalabilidad del admin panel. Sin ella, cualquier usuario podría potencialmente acceder a datos administrativos.
