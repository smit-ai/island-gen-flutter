import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/editor_main_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: IslandGeneratorApp(),
    ),
  );
}

class IslandGeneratorApp extends StatelessWidget {
  const IslandGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Island Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EditorMainPage(),
    );
  }
}

Future<ui.Image> generateVolcano({
  required int width,
  required int height,
  double outerRadius = 0.8,
  double innerRadius = 0.3,
  double craterDepth = 0.4,
  double rimHeight = 0.2,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final center = Offset(width / 2, height / 2);
  final maxRadius = math.min(width, height) / 2;
  final outerRadiusPixels = maxRadius * outerRadius;
  final innerRadiusPixels = maxRadius * innerRadius;

  final paint = Paint()..color = Colors.black;
  canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final dx = x - center.dx;
      final dy = y - center.dy;
      final distanceFromCenter = math.sqrt(dx * dx + dy * dy);

      // Calculate height based on distance
      double height;
      if (distanceFromCenter > outerRadiusPixels) {
        // Outside the volcano
        height = 0.0;
      } else if (distanceFromCenter < innerRadiusPixels) {
        // Inside the crater
        final craterT = distanceFromCenter / innerRadiusPixels;
        height = 1.0 - craterDepth + (craterT * craterDepth);
      } else {
        // On the volcano slope
        final t = (distanceFromCenter - innerRadiusPixels) / (outerRadiusPixels - innerRadiusPixels);
        final rimT = 1.0 - math.pow((t - 0.2).abs() * 1.25, 2).clamp(0.0, 1.0);
        height = (1.0 - t) + (rimHeight * rimT);
      }

      paint.color = Color.fromRGBO(
        255,
        255,
        255,
        height.clamp(0.0, 1.0),
      );

      canvas.drawRect(
        Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1),
        paint,
      );
    }
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);

  return image;
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/editor_main_page.dart';
import 'package:island_gen_flutter/shaders.dart';
import 'package:island_gen_flutter/features/physics/physics_system.dart';
import 'dart:async';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-load shader library to avoid stutter
  await _preloadShaders();
  
  // Initialize physics system
  await PhysicsSystem.initialize();
  
  runApp(
    const ProviderScope(
      child: PhysicsSandboxApp(),
    ),
  );
}

Future<void> _preloadShaders() async {
  try {
    final library = shaderLibrary;
    debugPrint('Shader library preloaded: ${library.shaders_.length} shaders');
  } catch (e) {
    debugPrint('Error preloading shaders: $e');
  }
}

class PhysicsSandboxApp extends StatefulWidget {
  const PhysicsSandboxApp({super.key});

  @override
  State<PhysicsSandboxApp> createState() => _PhysicsSandboxAppState();
}

class _PhysicsSandboxAppState extends State<PhysicsSandboxApp> {
  @override
  void initState() {
    super.initState();
    PhysicsSystem.instance.startSimulation();
  }

  @override
  void dispose() {
    PhysicsSystem.instance.stopSimulation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Physics Sandbox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
          background: const Color(0xFF121212),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: const SafeArea(
        child: EditorMainPage(),
      ),
    );
  }
}
*/