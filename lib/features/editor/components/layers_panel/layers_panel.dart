import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/components/layers_panel/controller/layer_panel_controller.dart';
import 'package:island_gen_flutter/features/editor/components/layers_panel/layers_panel_layer.dart';
import 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';

class LayersPanel extends ConsumerWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final layers = ref.watch(layerPanelControllerProvider.select((value) => value.layers));
    final layerIds = ref.watch(layerPanelControllerProvider.select((value) => value.layerIds));
    final layers = layerIds.map((id) => ref.watch(layerControllerProvider(id)));
    final controller = ref.watch(layerPanelControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...layers.map((layer) => LayersPanelLayer(layerId: layer.id)),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => controller.addLayer(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 8),
                Text('Add Layer'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
