lib
├── features/
│   ├── editor/
│   │   ├── components/
│   │   │   ├── global_settings_panel/
│   │   │   │   └── global_settings_panel.dart                    # Manages global editor settings like resolution, output format, and default parameters
│   │   │   ├── layer_settings_panel/
│   │   │   │   └── layer_settings_panel.dart                     # [UI] Controls for modifying the selected layer's properties, noise parameters, and transformations
│   │   │   ├── layers_panel/
│   │   │   │   ├── controller/
│   │   │   │   │   └── layer_panel_controller.dart              # [State] Manages layer selection, ordering, and synchronization with the layer provider
│   │   │   │   ├── layers_panel.dart                           # [UI] Main panel showing layer hierarchy with drag-and-drop support and layer operations
│   │   │   │   └── layers_panel_layer.dart                     # [Widget] Individual layer item in the panel with preview and basic controls
│   │   │   └── main_display_area/
���   │   │       ├── heightmap_renderer.dart                     # [Core] Renders the current heightmap state using GPU acceleration and custom shaders
│   │   │       ├── main_area_toolbar.dart                      # [UI] Tools and actions for interacting with the heightmap display
│   │   │       └── main_display_area.dart                      # [Layout] Main workspace area containing the renderer and toolbar
│   │   ├── editor_main_page.dart                              # [Page] Main editor layout combining all panels and components
│   │   ├── global_state/                                      # [State] Global application state management
│   │   │   ├── global_state.dart                             # [Model] Global state data model with Freezed
│   │   │   └── global_state_provider.dart                    # [State] Riverpod provider for global state management
│   │   └── providers/
│   │       ├── global_settings_provider/
│   │       │   └── global_settings_state_provider.dart         # [State] Riverpod provider for managing global editor settings
│   │       ├── heightmap_provider/
│   │       │   └── heightmap_provider.dart                     # [State] Manages the current heightmap data and caching
│   │       └── layer_provider/
│   │           └── layer_provider.dart                         # [State] Core provider managing layer stack and operations
│   ├── heightmap_generator/
│   │   └── heightmap_generator.dart                           # [Core] GPU-based noise generation using GLSL shaders for creating heightmap data
│   ├── heightmap_viewer/
│   │   ├── heightmap_painter.dart                             # [Render] CustomPainter for efficient 2D heightmap visualization
│   │   └── heightmap_viewer.dart                              # [Widget] Display component for viewing heightmaps with Riverpod integration
│   └── terrain_viewer/
│       ├── orbit_camera.dart                                  # [3D] Camera controls for orbiting and zooming the 3D terrain view
│       ├── terrain_mesh.dart                                  # [3D] Generates and manages 3D mesh data from heightmaps
│       ├── terrain_painter.dart                               # [3D] GPU-accelerated terrain rendering with lighting and materials
│       └── terrain_viewer.dart                                # [3D] Interactive 3D terrain visualization component
├── main.dart                                                  # Application entry point and setup
├── models/
│   └── layer.dart                                            # [Model] Data structure for heightmap layers with serialization
├── shaders.dart                                              # [Core] Central shader management and registration
└── widgets/                                                  # Directory for shared, reusable UI components