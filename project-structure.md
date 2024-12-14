lib
├── features/
│   ├── editor/
│   │   ├── components/
│   │   │   ├── global_settings_panel/
│   │   │   │   └── global_settings_panel.dart                    # [UI] Settings panel for project-wide configuration
│   │   │   ├── layer_settings_panel/
│   │   │   │   └── layer_settings_panel.dart                     # [UI] Editor for individual layer properties and noise parameters
│   │   │   ├── layers_panel/
│   │   │   │   ├── layers_panel.dart                           # [UI] Panel displaying layer stack with drag-drop reordering
│   │   │   │   └── layers_panel_layer.dart                     # [UI] Individual layer item with preview and controls
│   │   │   └── main_display_area/
│   │   │       ├── heightmap_renderer.dart                     # [Core] Real-time heightmap visualization using GPU shaders
│   │   │   │   ├── main_area_toolbar.dart                      # [UI] Main editor toolbar with common actions
│   │   │   │   └── main_display_area.dart                      # [Layout] Main editor workspace container
│   │   ├── editor_main_page.dart                              # [Page] Root editor page organizing all panels and state
│   │   ├── global_state/                                      # [State] Centralized application state management
│   │   │   └── global_state_provider.dart                     # [State] Root state provider managing layer stack and selection
│   │   └── providers/                                         # [State] Feature-specific state providers
│   │       ├── global_settings_provider/
│   │       │   └── global_settings_state_provider.dart         # [State] Project-wide settings state (resolution, format, etc.)
│   │       ├── heightmap_provider/
│   │       │   └── heightmap_provider.dart                     # [State] Heightmap generation and caching logic
│   │       └── layer_provider/
│   │           └── layer_provider.dart                         # [State] Individual layer state management and operations
│   ├── heightmap_generator/
│   │   └── heightmap_generator.dart                           # [Core] GPU-accelerated noise generation using GLSL shaders
│   ├── heightmap_viewer/
│   │   ├── heightmap_painter.dart                             # [Render] CustomPainter for efficient heightmap visualization
│   │   └── heightmap_viewer.dart                              # [Widget] Heightmap display with Riverpod state integration
│   └── terrain_viewer/
│       ├── orbit_camera.dart                                  # [3D] Orbital camera controls for 3D view
│       ├── terrain_mesh.dart                                  # [3D] Terrain mesh generation from heightmap data
│       ├── terrain_painter.dart                               # [3D] GPU-based terrain rendering with lighting
│       └── terrain_viewer.dart                                # [3D] Interactive 3D terrain preview component
├── main.dart                                                  # Application entry point and providers setup
├── models/
│   └── layer.dart                                            # [Model] Core layer data structure with Freezed
├── shaders.dart                                              # [Core] Shader management and registration
└── widgets/                                                  # Shared widget components