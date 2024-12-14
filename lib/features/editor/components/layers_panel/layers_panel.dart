import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/components/layers_panel/layers_panel_layer.dart';
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';

class LayersPanel extends ConsumerWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layerIds = ref.watch(globalStateProvider.select((value) => value.layerStack.map((layer) => layer.id)));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...layerIds.map((id) => LayersPanelLayer(layerId: id)),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => ref.read(globalStateProvider.notifier).addLayer(),
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
