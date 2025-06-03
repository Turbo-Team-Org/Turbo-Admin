import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:turbo_admin/core/firebase/firebase_factory.dart';
import 'package:turbo_admin/core/widgets/system_diagnostics_widget.dart';
import 'package:turbo_admin/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:turbo_admin/features/places/cubit/places_cubit.dart';
import 'package:turbo_admin/features/events/cubit/events_cubit.dart';
import 'package:turbo_admin/features/reviews/cubit/reviews_cubit.dart';
import 'package:turbo_admin/features/categories/cubit/categories_cubit.dart';
import 'package:turbo_admin/features/users/cubit/users_cubit.dart';

/// Página de diagnóstico completo del sistema
class DiagnosticsPage extends StatefulWidget {
  const DiagnosticsPage({super.key});

  @override
  State<DiagnosticsPage> createState() => _DiagnosticsPageState();
}

class _DiagnosticsPageState extends State<DiagnosticsPage> {
  bool _isRunningTests = false;
  List<TestResult> _testResults = [];

  @override
  void initState() {
    super.initState();
    _runAllTests();
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isRunningTests = true;
      _testResults.clear();
    });

    final results = <TestResult>[];

    // Test 1: Firebase
    results.add(await _testFirebase());

    // Test 2: GetIt
    results.add(_testGetIt());

    // Test 3: Core Dependencies
    results.addAll(_testCoreDependencies());

    // Test 4: UI Cubits
    results.addAll(_testUICubits());

    // Test 5: Data Loading
    results.addAll(await _testDataLoading());

    setState(() {
      _testResults = results;
      _isRunningTests = false;
    });
  }

  Future<TestResult> _testFirebase() async {
    try {
      final isInitialized = FirebaseFactory.isInitialized;
      if (!isInitialized) {
        return TestResult.error('Firebase', 'No está inicializado');
      }

      final app = await FirebaseFactory.initializeApp();
      return TestResult.success(
          'Firebase', 'Inicializado correctamente (${app.name})');
    } catch (e) {
      return TestResult.error('Firebase', 'Error: $e');
    }
  }

  TestResult _testGetIt() {
    try {
      final instance = GetIt.instance;
      return TestResult.success('GetIt', 'Instancia disponible');
    } catch (e) {
      return TestResult.error('GetIt', 'Error: $e');
    }
  }

  List<TestResult> _testCoreDependencies() {
    final results = <TestResult>[];
    final dependencies = [
      ('PlaceRepository', PlaceRepository),
      ('EventRepository', EventRepository),
      ('ReviewRepository', ReviewRepository),
      ('CategoryRepository', CategoryRepository),
      ('AuthenticationRepository', AuthenticationRepository),
    ];

    for (final (name, type) in dependencies) {
      try {
        GetIt.instance.get(type: type);
        results.add(TestResult.success(name, 'Registrado y disponible'));
      } catch (e) {
        results.add(TestResult.error(
            name, 'No registrado: ${e.toString().substring(0, 100)}...'));
      }
    }

    return results;
  }

  List<TestResult> _testUICubits() {
    final results = <TestResult>[];
    final cubits = [
      'DashboardCubit',
      'PlacesCubit',
      'EventsCubit',
      'ReviewsCubit',
      'CategoriesCubit',
      'UsersCubit',
    ];

    for (final cubitName in cubits) {
      try {
        // Intentar obtener el cubit por tipo
        switch (cubitName) {
          case 'DashboardCubit':
            GetIt.instance.get<DashboardCubit>();
            break;
          case 'PlacesCubit':
            GetIt.instance.get<PlacesCubit>();
            break;
          case 'EventsCubit':
            GetIt.instance.get<EventsCubit>();
            break;
          case 'ReviewsCubit':
            GetIt.instance.get<ReviewsCubit>();
            break;
          case 'CategoriesCubit':
            GetIt.instance.get<CategoriesCubit>();
            break;
          case 'UsersCubit':
            GetIt.instance.get<UsersCubit>();
            break;
        }
        results.add(TestResult.success(cubitName, 'Registrado correctamente'));
      } catch (e) {
        results.add(TestResult.error(
            cubitName, 'No registrado: ${e.toString().substring(0, 100)}...'));
      }
    }

    return results;
  }

  Future<List<TestResult>> _testDataLoading() async {
    final results = <TestResult>[];

    // Test PlaceRepository
    try {
      final placeRepo = GetIt.instance<PlaceRepository>();
      final places = await placeRepo.getPlaces();
      results.add(TestResult.success(
          'PlaceRepository.getPlaces()', 'Retornó ${places.length} lugares'));
    } catch (e) {
      results.add(TestResult.error('PlaceRepository.getPlaces()', 'Error: $e'));
    }

    // Test EventRepository
    try {
      final eventRepo = GetIt.instance<EventRepository>();
      final events = await eventRepo.getEvents();
      results.add(TestResult.success(
          'EventRepository.getEvents()', 'Retornó ${events.length} eventos'));
    } catch (e) {
      results.add(TestResult.error('EventRepository.getEvents()', 'Error: $e'));
    }

    // Test ReviewRepository
    try {
      final reviewRepo = GetIt.instance<ReviewRepository>();
      final reviews = await reviewRepo.getReviews();
      results.add(TestResult.success('ReviewRepository.getReviews()',
          'Retornó ${reviews.length} reseñas'));
    } catch (e) {
      results
          .add(TestResult.error('ReviewRepository.getReviews()', 'Error: $e'));
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          'Diagnóstico del Sistema',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isRunningTests ? null : _runAllTests,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diagnóstico Completo del Sistema',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Verificación de todas las dependencias y funcionalidades',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            if (_isRunningTests)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Ejecutando pruebas de diagnóstico...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            else if (_testResults.isNotEmpty)
              _TestResultsList(results: _testResults)
            else
              const Center(
                child: Text(
                  'Presiona el botón de actualizar para ejecutar las pruebas',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            const SizedBox(height: 32),
            const SystemDiagnosticsWidget(),
          ],
        ),
      ),
    );
  }
}

class _TestResultsList extends StatelessWidget {
  final List<TestResult> results;

  const _TestResultsList({required this.results});

  @override
  Widget build(BuildContext context) {
    final successCount = results.where((r) => r.isSuccess).length;
    final errorCount = results.where((r) => !r.isSuccess).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resumen
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF16213E),
            border: Border.all(
              color: errorCount == 0
                  ? const Color(0xFF10B981).withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    errorCount == 0 ? Icons.check_circle : Icons.error,
                    color:
                        errorCount == 0 ? const Color(0xFF10B981) : Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Resumen de Pruebas',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '✅ $successCount pruebas exitosas\n❌ $errorCount pruebas fallidas',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Lista de resultados
        ...results.map((result) => _TestResultItem(result: result)),
      ],
    );
  }
}

class _TestResultItem extends StatelessWidget {
  final TestResult result;

  const _TestResultItem({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF16213E),
        border: Border.all(
          color: result.isSuccess
              ? const Color(0xFF10B981).withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            result.isSuccess ? Icons.check_circle : Icons.error,
            color: result.isSuccess ? const Color(0xFF10B981) : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
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

class TestResult {
  final String name;
  final String message;
  final bool isSuccess;

  TestResult._(this.name, this.message, this.isSuccess);

  factory TestResult.success(String name, String message) =>
      TestResult._(name, message, true);

  factory TestResult.error(String name, String message) =>
      TestResult._(name, message, false);
}
