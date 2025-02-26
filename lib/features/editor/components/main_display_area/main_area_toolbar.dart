// Toolbar overlay
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';

/*
class MainAreaToolbar extends ConsumerWidget {
  const MainAreaToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalController = ref.read(globalSettingsProvider.notifier);
    final currentMode = ref.watch(globalSettingsProvider).viewMode;

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
              SegmentedButton<ViewMode>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment<ViewMode>(
                    value: ViewMode.view2D,
                    icon: Icon(Icons.grid_on),
                    label: Text('2D'),
                  ),
                  ButtonSegment<ViewMode>(
                    value: ViewMode.wireframe3D,
                    icon: Icon(Icons.grid_3x3),
                    label: Text('Wire'),
                  ),
                  ButtonSegment<ViewMode>(
                    value: ViewMode.solid3D,
                    icon: Icon(Icons.view_agenda),
                    label: Text('Solid'),
                  ),
                  ButtonSegment<ViewMode>(
                    value: ViewMode.color3D,
                    icon: Icon(Icons.palette),
                    label: Text('Color'),
                  ),
                  ButtonSegment<ViewMode>(
                    value: ViewMode.raymarched3D,
                    icon: Icon(Icons.blur_on),
                    label: Text('Ray'),
                  ),
                ],
                selected: {currentMode},
                onSelectionChanged: (Set<ViewMode> selected) {
                  globalController.updateViewMode(selected.first);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

class MainAreaToolbar extends ConsumerWidget {
  const MainAreaToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalController = ref.read(globalSettingsProvider.notifier);
    final currentMode = ref.watch(globalSettingsProvider).viewMode;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Card(
          elevation: 4,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SegmentedButton<ViewMode>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment<ViewMode>(
                        value: ViewMode.view2D,
                        icon: Icon(Icons.grid_on),
                        label: Text('2D'),
                      ),
                      ButtonSegment<ViewMode>(
                        value: ViewMode.wireframe3D,
                        icon: Icon(Icons.grid_3x3),
                        label: Text('Wire'),
                      ),
                      ButtonSegment<ViewMode>(
                        value: ViewMode.solid3D,
                        icon: Icon(Icons.view_agenda),
                        label: Text('Solid'),
                      ),
                      ButtonSegment<ViewMode>(
                        value: ViewMode.color3D,
                        icon: Icon(Icons.palette),
                        label: Text('Color'),
                      ),
                      ButtonSegment<ViewMode>(
                        value: ViewMode.raymarched3D,
                        icon: Icon(Icons.blur_on),
                        label: Text('Ray'),
                      ),
                    ],
                    selected: {currentMode},
                    onSelectionChanged: (Set<ViewMode> selected) {
                      globalController.updateViewMode(selected.first);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
