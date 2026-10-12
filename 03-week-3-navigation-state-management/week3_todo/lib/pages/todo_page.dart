import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../providers/todo_filter_provider.dart';
import '../widgets/todo_tile.dart';

/// Halaman utama daftar ToDo (ConsumerStatefulWidget).
/// Mendukung parameter opsional loadDemo dan initialFilterName untuk memudahkan
/// pengujian dan dokumentasi aplikasi.
class TodoPage extends ConsumerStatefulWidget {
  final bool loadDemo;
  final String? initialFilterName;

  const TodoPage({
    super.key,
    this.loadDemo = false,
    this.initialFilterName,
  });

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.loadDemo && ref.read(todoListProvider).isEmpty) {
        final notifier = ref.read(todoListProvider.notifier);
        notifier.add('Mempelajari Konsep Navigasi GoRouter');
        notifier.add('Implementasi State Management Riverpod');
        notifier.add('Menangani AsyncValue (Loading, Error, Success)');
        notifier.add('Menyelesaikan AI Challenge & Testing');
        notifier.toggle(0);
        notifier.toggle(1);
      }
      if (widget.initialFilterName == 'active') {
        ref.read(todoFilterProvider.notifier).setFilter(TodoFilter.active);
      } else if (widget.initialFilterName == 'completed') {
        ref.read(todoFilterProvider.notifier).setFilter(TodoFilter.completed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(filteredTodoListProvider);
    final allTodos = ref.watch(todoListProvider);
    final activeFilter = ref.watch(todoFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${allTodos.where((t) => t.done).length}/${allTodos.length} Selesai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: TodoFilter.values.map((filter) {
                  final isSelected = activeFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter.label),
                      selected: isSelected,
                      onSelected: (_) {
                        ref.read(todoFilterProvider.notifier).setFilter(filter);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),
          // List of Todos
          Expanded(
            child: todos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          allTodos.isEmpty
                              ? 'Belum ada tugas'
                              : 'Tidak ada tugas pada filter "${activeFilter.label}"',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        if (allTodos.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Tekan tombol + di bawah untuk menambah tugas baru',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      final originalIndex = allTodos.indexOf(todo);
                      return TodoTile(
                        todo: todo,
                        onToggle: () {
                          if (originalIndex != -1) {
                            ref
                                .read(todoListProvider.notifier)
                                .toggle(originalIndex);
                          }
                        },
                        onDelete: () {
                          if (originalIndex != -1) {
                            ref
                                .read(todoListProvider.notifier)
                                .remove(originalIndex);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Tugas',
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tugas baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Contoh: Belajar State Management',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(todoListProvider.notifier).add(text);
              }
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
