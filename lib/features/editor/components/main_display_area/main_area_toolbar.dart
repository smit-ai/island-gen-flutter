// Toolbar overlay
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/terrain_settings_provider/terrain_settings_provider.dart';

enum ViewRenderMode {
  view2D,
  wireframe,
  solid,
  color,
}

class MainAreaToolbar extends ConsumerWidget {
  const MainAreaToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(globalSettingsProvider.select((value) => value.viewMode));
    final terrainSettings = ref.watch(terrainSettingsProvider);
    final globalController = ref.read(globalSettingsProvider.notifier);
    final terrainController = ref.read(terrainSettingsProvider.notifier);

    // Determine the current combined mode
    final currentMode = viewMode == ViewMode.view2D
        ? ViewRenderMode.view2D
        : switch (terrainSettings.renderMode) {
            RenderMode.wireframe => ViewRenderMode.wireframe,
            RenderMode.solid => ViewRenderMode.solid,
            RenderMode.color => ViewRenderMode.color,
          };

    return Positioned(
      top: 16,
      right: 16,
      child: Card(
        elevation: 4,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<ViewRenderMode>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment<ViewRenderMode>(
                    value: ViewRenderMode.view2D,
                    icon: Icon(Icons.grid_on),
                    label: Text('2D'),
                  ),
                  ButtonSegment<ViewRenderMode>(
                    value: ViewRenderMode.wireframe,
                    icon: Icon(Icons.grid_3x3),
                    label: Text('Wire'),
                  ),
                  ButtonSegment<ViewRenderMode>(
                    value: ViewRenderMode.solid,
                    icon: Icon(Icons.view_agenda),
                    label: Text('Solid'),
                  ),
                  ButtonSegment<ViewRenderMode>(
                    value: ViewRenderMode.color,
                    icon: Icon(Icons.palette),
                    label: Text('Color'),
                  ),
                ],
                selected: {currentMode},
                onSelectionChanged: (Set<ViewRenderMode> selected) {
                  final mode = selected.first;
                  if (mode == ViewRenderMode.view2D) {
                    globalController.updateViewMode(ViewMode.view2D);
                  } else {
                    globalController.updateViewMode(ViewMode.view3D);
                    terrainController.setRenderMode(switch (mode) {
                      ViewRenderMode.wireframe => RenderMode.wireframe,
                      ViewRenderMode.solid => RenderMode.solid,
                      ViewRenderMode.color => RenderMode.color,
                      _ => RenderMode.solid,
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.blue;
                      }
                      return Colors.grey[100];
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return Colors.grey[800];
                    },
                  ),
                  side: MaterialStateProperty.all(
                    BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              if (viewMode == ViewMode.view3D) ...[
                const SizedBox(width: 16),
                const VerticalDivider(width: 1),
                const SizedBox(width: 16),
                // Grid Resolution
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Grid Resolution', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 60,
                          child: TextFormField(
                            initialValue: terrainSettings.gridResolution.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            onChanged: (value) {
                              final resolution = int.tryParse(value);
                              if (resolution != null) {
                                terrainController.setGridResolution(resolution);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${terrainSettings.gridResolution}x${terrainSettings.gridResolution}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Height
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Height', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    SizedBox(
                      width: 60,
                      child: TextFormField(
                        initialValue: terrainSettings.height.toString(),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        onChanged: (value) {
                          final height = double.tryParse(value);
                          if (height != null) {
                            terrainController.setDimensions(height: height);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
