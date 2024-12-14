.
├── features
│   ├── editor
│   │   ├── components
│   │   │   ├── global_settings_panel
│   │   │   │   └── global_settings_panel.dart
│   │   │   ├── layer_settings_panel
│   │   │   │   └── layer_settings_panel.dart
│   │   │   ├── layers_panel
│   │   │   │   ├── controller
│   │   │   │   │   └── layer_panel_controller.dart
│   │   │   │   ├── layers_panel.dart
│   │   │   │   └── layers_panel_layer.dart
│   │   │   └── main_display_area
│   │   │       ├── heightmap_renderer.dart
│   │   │       ├── main_area_toolbar.dart
│   │   │       └── main_display_area.dart
│   │   ├── editor_main_page.dart
│   │   └── providers
│   │       ├── global_settings_provider
│   │       │   └── global_settings_state_provider.dart
│   │       └── layer_provider
│   │           └── layer_provider.dart
│   ├── heightmap_generator
│   │   └── heightmap_generator.dart
│   ├── heightmap_viewer
│   │   ├── heightmap_painter.dart
│   │   └── heightmap_viewer.dart
│   └── terrain_viewer
│       ├── orbit_camera.dart
│       ├── terrain_mesh.dart
│       ├── terrain_painter.dart
│       └── terrain_viewer.dart
├── generated
│   ├── features
│   │   └── editor
│   │       ├── components
│   │       │   └── layers_panel
│   │       │       └── controller
│   │       │           ├── layer_panel_controller.freezed.dart
│   │       │           └── layer_panel_controller.g.dart
│   │       └── providers
│   │           ├── global_settings_provider
│   │           │   ├── global_settings_state_provider.freezed.dart
│   │           │   └── global_settings_state_provider.g.dart
│   │           └── layer_provider
│   │               └── layer_provider.g.dart
│   └── models
│       └── layer.freezed.dart
├── main.dart
├── models
│   └── layer.dart
├── shaders.dart
└── widgets