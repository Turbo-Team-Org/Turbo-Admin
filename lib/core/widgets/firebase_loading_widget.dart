import 'package:flutter/material.dart';

/// Widget que muestra el estado de carga durante la inicialización de Firebase
class FirebaseLoadingWidget extends StatelessWidget {
  const FirebaseLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turbo Admin',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o icono de la aplicación
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              // Título
              const Text(
                'Turbo Admin Panel',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Subtítulo
              Text(
                'Inicializando conexión con Firebase...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 40),

              // Indicador de carga
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF6366F1).withOpacity(0.8),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Texto de estado
              Text(
                'Configurando servicios...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget para mostrar errores de Firebase con información detallada
class FirebaseErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const FirebaseErrorWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono de error
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),

            // Título del error
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
            ),
            const SizedBox(height: 16),

            // Mensaje de error
            Text(
              _getFormattedErrorMessage(errorMessage),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 24),

            // Botón de reintentar
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

            // Información adicional para errores de timestamp
            if (errorMessage.contains('Timestamp') ||
                errorMessage.contains('String'))
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Información técnica',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este error indica un problema con el formato de fechas en la base de datos. Los datos pueden estar almacenados como texto en lugar de timestamps de Firebase.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFormattedErrorMessage(String error) {
    if (error.contains('Timestamp') || error.contains('String')) {
      return 'Error al procesar fechas de eventos. Por favor, verifica que los datos estén correctamente formateados.';
    } else if (error.contains('Error al obtener eventos')) {
      return 'Error al cargar eventos desde la base de datos.';
    } else if (error.contains('Error al obtener lugares')) {
      return 'Error al cargar lugares desde la base de datos.';
    } else if (error.contains('Error al obtener reseñas')) {
      return 'Error al cargar reseñas desde la base de datos.';
    } else if (error.contains('Firebase')) {
      return 'Error de conexión con Firebase. Verifica tu conexión a internet.';
    }
    return error;
  }
}
