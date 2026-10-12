import 'package:flutter/material.dart';
import '../models/todo.dart';

/// Widget TodoTile mandiri (Refactoring Challenge #1).
/// Memisahkan tampilan satu item ToDo dari TodoPage agar:
/// - Method build() pada TodoPage tetap ringkas dan bersih.
/// - Widget TodoTile mudah diuji secara terisolasi (Widget Testing).
/// - Mendukung UI yang responsif dan konsisten dengan Material 3.
class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      elevation: todo.done ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: todo.done
              ? theme.colorScheme.outlineVariant.withValues(alpha: 0.5)
              : theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      color: todo.done
          ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
          : theme.colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: todo.done,
          activeColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: todo.done ? FontWeight.normal : FontWeight.w500,
            decoration: todo.done ? TextDecoration.lineThrough : null,
            color: todo.done
                ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                : theme.colorScheme.onSurface,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: theme.colorScheme.error,
          ),
          tooltip: 'Hapus Tugas',
          onPressed: onDelete,
        ),
      ),
    );
  }
}
