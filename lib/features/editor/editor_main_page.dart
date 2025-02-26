import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/components/global_settings_panel/global_settings_panel.dart';
import 'package:island_gen_flutter/features/editor/components/layers_panel/layers_panel.dart';
import 'package:island_gen_flutter/features/editor/components/layer_settings_panel/layer_settings_panel.dart';
import 'package:island_gen_flutter/features/editor/components/main_display_area/main_area_toolbar.dart' show MainAreaToolbar;
import 'package:island_gen_flutter/features/editor/components/main_display_area/main_display_area.dart';

/*
class EditorMainPage extends ConsumerWidget {
  const EditorMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: /*const SingleChildScrollView(*/
                /*const SizedBox(*/
                const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlobalSettingsPanel(),
                LayersPanel(),
                Expanded(child: LayerSettingsPanel()),
              ],
            ),
            /*),*/
            /*),*/
          ),

          // Main content area
          const MainDisplayArea(),
        ],
      ),
    );
  }
}
*/

class EditorMainPage extends ConsumerStatefulWidget {
  const EditorMainPage({super.key});

  @override
  ConsumerState<EditorMainPage> createState() => _EditorMainPageState();
}

class _EditorMainPageState extends ConsumerState<EditorMainPage> {
  double settingsWidth = 250;
  double toolbarHeight = 48;
  bool isDraggingSettings = false;
  bool isDraggingToolbar = false;

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Scaffold(
      body: isLandscape 
        ? _buildLandscapeLayout()
        : _buildPortraitLayout(),
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        SizedBox(
          width: settingsWidth,
          child: Stack(
            children: [
              CustomScrollView(
                slivers: const [
                  SliverToBoxAdapter(child: GlobalSettingsPanel()),
                  SliverToBoxAdapter(child: LayersPanel()),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: LayerSettingsPanel(),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragStart: (_) => setState(() => isDraggingSettings = true),
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      settingsWidth = (settingsWidth + details.delta.dx)
                          .clamp(200.0, MediaQuery.of(context).size.width / 2);
                    });
                  },
                  onHorizontalDragEnd: (_) => setState(() => isDraggingSettings = false),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    child: Container(
                      width: 8,
                      color: isDraggingSettings 
                          ? Theme.of(context).colorScheme.primary 
                          : Colors.grey.withAlpha(76),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: toolbarHeight,
                child: Stack(
                  children: [
                    const MainAreaToolbar(),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onVerticalDragStart: (_) => setState(() => isDraggingToolbar = true),
                        onVerticalDragUpdate: (details) {
                          setState(() {
                            toolbarHeight = (toolbarHeight + details.delta.dy)
                                .clamp(48.0, 120.0);
                          });
                        },
                        onVerticalDragEnd: (_) => setState(() => isDraggingToolbar = false),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.resizeRow,
                          child: Container(
                            height: 8,
                            color: isDraggingToolbar 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey.withAlpha(76),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: MainDisplayArea()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        SizedBox(
          height: toolbarHeight,
          child: Stack(
            children: [
              const MainAreaToolbar(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onVerticalDragStart: (_) => setState(() => isDraggingToolbar = true),
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      toolbarHeight = (toolbarHeight + details.delta.dy)
                          .clamp(48.0, 120.0);
                    });
                  },
                  onVerticalDragEnd: (_) => setState(() => isDraggingToolbar = false),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeRow,
                    child: Container(
                      height: 8,
                      color: isDraggingToolbar 
                          ? Theme.of(context).colorScheme.primary 
                          : Colors.grey.withAlpha(76),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: MainDisplayArea()),
        SizedBox(
          height: settingsWidth,
          child: Stack(
            children: [
              CustomScrollView(
                slivers: const [
                  SliverToBoxAdapter(child: GlobalSettingsPanel()),
                  SliverToBoxAdapter(child: LayersPanel()),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: LayerSettingsPanel(),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: GestureDetector(
                  onVerticalDragStart: (_) => setState(() => isDraggingSettings = true),
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      settingsWidth = (settingsWidth - details.delta.dy)
                          .clamp(200.0, MediaQuery.of(context).size.height / 2);
                    });
                  },
                  onVerticalDragEnd: (_) => setState(() => isDraggingSettings = false),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeRow,
                    child: Container(
                      height: 8,
                      color: isDraggingSettings 
                          ? Theme.of(context).colorScheme.primary 
                          : Colors.grey.withAlpha(76),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


