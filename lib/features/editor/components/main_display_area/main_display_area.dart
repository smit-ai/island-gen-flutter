import 'dart:math' show/*max,*/min;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/*import 'package:island_gen_flutter/features/editor/components/main_display_area/main_area_toolbar.dart';*/
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/features/heightmap_viewer/heightmap_viewer.dart';
import 'package:island_gen_flutter/features/raymarched_terrain_viewer/raymarched_terrain_viewer.dart';
import 'package:island_gen_flutter/features/terrain_viewer/terrain_viewer.dart';

/*
class MainDisplayArea extends ConsumerWidget {
  const MainDisplayArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(globalSettingsProvider.select((value) => value.viewMode));
    final noActiveLayers = ref.watch(globalStateProvider).activeLayerStack.isEmpty;

    Widget viewSelector(ViewMode viewMode) {
      switch (viewMode) {
        case ViewMode.view2D:
          return HeightmapViewer();
        case ViewMode.solid3D:
        case ViewMode.wireframe3D:
        case ViewMode.color3D:
          return TerrainViewer();
        case ViewMode.raymarched3D:
          return RaymarchedTerrainViewer();
      }
    }

    return /*Expanded(
      child:*/ Container(
        color: Colors.black87,
        child: Stack(
          children: [
            // Preview area
            Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: noActiveLayers
                      ? const Center(
                          child: Text(
                            'No active layers',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : viewSelector(viewMode),
                ),
              ),
            ),
            const MainAreaToolbar(),
          ],
        ),
      /*),*/
    );
  }
}
*/

class MainDisplayArea extends ConsumerWidget {
  const MainDisplayArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(globalSettingsProvider.select((value) => value.viewMode));
    final noActiveLayers = ref.watch(globalStateProvider).activeLayerStack.isEmpty;
    final size = MediaQuery.of(context).size;
    final maxRenderSize = _calculateOptimalRenderSize(size);

    return Container(
      color: Colors.black87,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: maxRenderSize,
                height: maxRenderSize,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: noActiveLayers
                      ? const Center(
                          child: Text(
                            'No active layers',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : viewSelector(viewMode),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateOptimalRenderSize(Size availableSize) {
    const toolbarHeight = 0;
    const margin = 0;
    
    final availableHeight = availableSize.height - toolbarHeight - (margin * 2);
    final availableWidth = availableSize.width - (margin * 2);
    
    return min(availableHeight, availableWidth);
  }

  Widget viewSelector(ViewMode viewMode) {
    switch (viewMode) {
      case ViewMode.view2D:
        return HeightmapViewer();
      case ViewMode.solid3D:
      case ViewMode.wireframe3D:
      case ViewMode.color3D:
        return TerrainViewer();
      case ViewMode.raymarched3D:
        return RaymarchedTerrainViewer();
    }
  }
}
