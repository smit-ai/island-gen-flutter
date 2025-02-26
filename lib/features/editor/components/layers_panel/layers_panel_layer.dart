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
    final isIsolated = ref.watch(globalStateProvider.select((value) => value.isolatedLayerIds.contains(layerId)));
    final hasIsolatedLayers = ref.watch(globalStateProvider.select((value) => value.isolatedLayerIds.isNotEmpty));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isSelected ? Colors.blue.withAlpha(25) : Colors.transparent,
        child: InkWell(
          onTap: () => ref.read(globalStateProvider.notifier).selectLayer(layerId),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Visibility toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _SmallIconButton(
                    icon: layer.visible ? Icons.visibility : Icons.visibility_off,
                    color: layer.visible ? Colors.grey.shade700 : Colors.red.shade300,
                    onPressed: () => ref.read(layerControllerProvider(layerId).notifier).toggleVisibility(),
                  ),
                ),
                const SizedBox(width: 4),
                // Isolate button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _SmallIconButton(
                    icon: isIsolated ? Icons.filter_alt : (hasIsolatedLayers ? Icons.filter_alt_off : Icons.filter_alt_outlined),
                    color: isIsolated ? Colors.blue : Colors.grey.shade700,
                    onPressed: () => ref.read(globalStateProvider.notifier).toggleIsolateLayer(layerId),
                  ),
                ),
                const SizedBox(width: 8),
                // Layer name
                Expanded(
                  child: Text(
                    layer.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.blue : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Delete button
                _SmallIconButton(
                  icon: Icons.close,
                  color: Colors.grey.shade700,
                  onPressed: () => ref.read(globalStateProvider.notifier).removeLayer(layerId),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SmallIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        color: color,
        padding: EdgeInsets.zero,
        splashRadius: 14,
      ),
    );
  }
}
