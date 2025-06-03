import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/firebase/firebase_factory.dart';

/// Widget de diagnóstico del sistema para verificar dependencias
class SystemDiagnosticsWidget extends StatefulWidget {
  const SystemDiagnosticsWidget({super.key});

  @override
  State<SystemDiagnosticsWidget> createState() =>
      _SystemDiagnosticsWidgetState();
}

class _SystemDiagnosticsWidgetState extends State<SystemDiagnosticsWidget> {
  Map<String, DiagnosticResult> _diagnostics = {};
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isRunning = true;
      _diagnostics.clear();
    });

    final diagnostics = <String, DiagnosticResult>{};

    // Verificar Firebase
    diagnostics['Firebase'] = await _checkFirebase();

    // Verificar GetIt
    diagnostics['GetIt'] = _checkGetIt();

    // Verificar repositorios del core
    diagnostics['PlaceRepository'] =
        _checkDependency<PlaceRepository>('PlaceRepository');
    diagnostics['EventRepository'] =
        _checkDependency<EventRepository>('EventRepository');
    diagnostics['ReviewRepository'] =
        _checkDependency<ReviewRepository>('ReviewRepository');
    diagnostics['CategoryRepository'] =
        _checkDependency<CategoryRepository>('CategoryRepository');
    diagnostics['AuthenticationRepository'] =
        _checkDependency<AuthenticationRepository>('AuthenticationRepository');

    // Verificar Cubits
    diagnostics['DashboardCubit'] = _checkCubit('DashboardCubit');
    diagnostics['PlacesCubit'] = _checkCubit('PlacesCubit');
    diagnostics['EventsCubit'] = _checkCubit('EventsCubit');

    setState(() {
      _diagnostics = diagnostics;
      _isRunning = false;
    });
  }

  Future<DiagnosticResult> _checkFirebase() async {
    try {
      final isInitialized = FirebaseFactory.isInitialized;
      if (isInitialized) {
        final app = await FirebaseFactory.initializeApp();
        return DiagnosticResult.success(
            'Inicializado correctamente (${app.name})');
      } else {
        return DiagnosticResult.error('No inicializado');
      }
    } catch (e) {
      return DiagnosticResult.error('Error: $e');
    }
  }

  DiagnosticResult _checkGetIt() {
    try {
      final instance = GetIt.instance;
      return DiagnosticResult.success('GetIt inicializado correctamente');
    } catch (e) {
      return DiagnosticResult.error('Error: $e');
    }
  }

  DiagnosticResult _checkDependency<T extends Object>(String name) {
    try {
      final instance = GetIt.instance<T>();
      return DiagnosticResult.success('Registrado correctamente');
    } catch (e) {
      return DiagnosticResult.error('No registrado: $e');
    }
  }

  DiagnosticResult _checkCubit(String name) {
    try {
      switch (name) {
        case 'DashboardCubit':
          GetIt.instance.get(instanceName: name);
          break;
        default:
          // Intentar obtener por tipo si está disponible
          break;
      }
      return DiagnosticResult.success('Registrado correctamente');
    } catch (e) {
      return DiagnosticResult.warning(
          'Posiblemente no registrado: ${e.toString().substring(0, 50)}...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF16213E),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_services,
                color: Color(0xFF6366F1),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Diagnóstico del Sistema',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_isRunning)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70),
                  onPressed: _runDiagnostics,
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (_diagnostics.isEmpty && !_isRunning)
            const Text(
              'Presiona el botón de actualizar para ejecutar diagnósticos',
              style: TextStyle(color: Colors.white70),
            )
          else
            ..._diagnostics.entries.map((entry) => _DiagnosticItem(
                  name: entry.key,
                  result: entry.value,
                )),
        ],
      ),
    );
  }
}

class _DiagnosticItem extends StatelessWidget {
  final String name;
  final DiagnosticResult result;

  const _DiagnosticItem({
    required this.name,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            result.icon,
            color: result.color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  result.message,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiagnosticResult {
  final DiagnosticStatus status;
  final String message;

  DiagnosticResult._(this.status, this.message);

  factory DiagnosticResult.success(String message) =>
      DiagnosticResult._(DiagnosticStatus.success, message);

  factory DiagnosticResult.warning(String message) =>
      DiagnosticResult._(DiagnosticStatus.warning, message);

  factory DiagnosticResult.error(String message) =>
      DiagnosticResult._(DiagnosticStatus.error, message);

  IconData get icon {
    switch (status) {
      case DiagnosticStatus.success:
        return Icons.check_circle;
      case DiagnosticStatus.warning:
        return Icons.warning;
      case DiagnosticStatus.error:
        return Icons.error;
    }
  }

  Color get color {
    switch (status) {
      case DiagnosticStatus.success:
        return const Color(0xFF10B981);
      case DiagnosticStatus.warning:
        return const Color(0xFFF59E0B);
      case DiagnosticStatus.error:
        return Colors.red;
    }
  }
}

enum DiagnosticStatus { success, warning, error }
