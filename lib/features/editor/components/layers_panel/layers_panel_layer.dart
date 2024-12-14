import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/global_state/global_state_provider.dart';
import 'package:island_gen_flutter/features/editor/providers/layer_provider/layer_provider.dart';

class LayersPanelLayer extends ConsumerWidget {
  final String layerId;

  const LayersPanelLayer({
    super.key,
    required this.layerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layer = ref.watch(layerControllerProvider(layerId));
    final isSelected = ref.watch(globalStateProvider.select((value) => value.selectedLayer?.id == layerId));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: OutlinedButton(
        onPressed: () => ref.read(globalStateProvider.notifier).selectLayer(layerId),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.layers,
              size: 16,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              layer.name,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.visibility,
              size: 16,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
