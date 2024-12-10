// Toolbar overlay
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:island_gen_flutter/features/editor/providers/global_settings_provider/global_settings_state_provider.dart';

class MainAreaToolbar extends ConsumerWidget {
  const MainAreaToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(globalSettingsProvider.select((value) => value.viewMode));
    final controller = ref.read(globalSettingsProvider.notifier);

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
                    value: ViewMode.view3D,
                    icon: Icon(Icons.view_in_ar),
                    label: Text('3D'),
                  ),
                ],
                selected: {viewMode},
                onSelectionChanged: (Set<ViewMode> selected) {
                  controller.updateViewMode(selected.first);
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
              const SizedBox(width: 8),
              VerticalDivider(color: Colors.grey[300], thickness: 1),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.zoom_in, color: Colors.grey[800]),
                onPressed: () {},
                tooltip: 'Zoom In',
                style: IconButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                  hoverColor: Colors.blue.withOpacity(0.1),
                ),
              ),
              IconButton(
                icon: Icon(Icons.zoom_out, color: Colors.grey[800]),
                onPressed: () {},
                tooltip: 'Zoom Out',
                style: IconButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                  hoverColor: Colors.blue.withOpacity(0.1),
                ),
              ),
              IconButton(
                icon: Icon(Icons.fit_screen, color: Colors.grey[800]),
                onPressed: () {},
                tooltip: 'Fit to Screen',
                style: IconButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                  hoverColor: Colors.blue.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 8),
              VerticalDivider(color: Colors.grey[300], thickness: 1),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.save, color: Colors.grey[800]),
                onPressed: () {},
                tooltip: 'Export',
                style: IconButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                  hoverColor: Colors.blue.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
