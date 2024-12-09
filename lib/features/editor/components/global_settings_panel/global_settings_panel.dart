import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/global_settings_provider/global_settings_state_provider.dart';

class GlobalSettingsPanel extends ConsumerWidget {
  const GlobalSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(globalSettingsProvider);
    final controller = ref.read(globalSettingsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Global Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Resolution input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Resolution'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton<Size>(
                        value: state.presets.contains(state.resolution) ? state.resolution : null,
                        hint: const Text('Select Resolution'),
                        isExpanded: true,
                        underline: Container(), // Remove the default underline
                        items: state.presets.map((preset) {
                          return DropdownMenuItem(
                            value: preset,
                            child: Text(
                              '${preset.width.toInt()}x${preset.height.toInt()}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (Size? newValue) {
                          if (newValue != null) {
                            controller.updateResolution(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
