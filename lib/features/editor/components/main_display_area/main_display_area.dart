import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/components/layers_panel/controller/layer_panel_controller.dart';
import 'package:island_gen_flutter/features/editor/components/main_display_area/heightmap_renderer.dart';
import 'package:island_gen_flutter/features/editor/components/main_display_area/main_area_toolbar.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';

class MainDisplayArea extends ConsumerWidget {
  const MainDisplayArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLayerId = ref.watch(layerPanelControllerProvider.select((value) => value.selectedLayerId));
    final resolution = ref.watch(globalSettingsProvider.select((value) => value.resolution));

    return Expanded(
      child: Container(
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
                  child: selectedLayerId != null
                      ? Consumer(
                          builder: (context, ref, child) {
                            final layer = ref.watch(layerControllerProvider(selectedLayerId));
                            return HeightmapRenderer(
                              heightmap: layer.cachedData,
                              resolution: resolution,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'Select a layer to preview',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),
            ),
            const MainAreaToolbar(),
          ],
        ),
      ),
    );
  }
}
