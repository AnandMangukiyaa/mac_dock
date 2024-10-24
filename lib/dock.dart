import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mac_dock/main.dart';
import 'package:mac_dock/my_reorderable_list_view.dart';

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();
  late final List<ItemData> _items2 = []; // List for given items with key

  @override
  void initState() {
    for (int i = 0; i < _items.length; i++) {
      _items2.add(ItemData(_items[i] as IconData, ValueKey(i)));
    }
    super.initState();
  }

  int _indexOfKey(Key key) {
    return _items2.indexWhere((ItemData d) => d.key == key);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black12,
        ),
        padding: const EdgeInsets.all(4),
        child: MyReorderableListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: _items2.map((e) {
              return Container(
                key: e.key,
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.icon.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e.icon, color: Colors.white)),
              );
            }).toList(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final ItemData item = _items2.removeAt(oldIndex);
                _items2.insert(newIndex, item);
              });
            }));
  }
}
// Row(
// mainAxisSize: MainAxisSize.min,
// children: _items.map(widget.builder).toList(),
// )
