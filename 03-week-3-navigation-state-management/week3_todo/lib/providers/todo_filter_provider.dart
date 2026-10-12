import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_provider.dart';

/// Enum filter untuk memilih kategori todo yang ingin ditampilkan
enum TodoFilter {
  all('Semua'),
  active('Aktif'),
  completed('Selesai');

  final String label;
  const TodoFilter(this.label);
}

/// Notifier untuk mengelola state filter yang aktif
class TodoFilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) {
    state = filter;
  }
}

/// Provider untuk state filter
final todoFilterProvider =
    NotifierProvider<TodoFilterNotifier, TodoFilter>(TodoFilterNotifier.new);

/// Provider turunan (computed/derived provider) yang otomatis memfilter daftar todo
/// berdasarkan nilai [todoFilterProvider] dan [todoListProvider].
final filteredTodoListProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoFilterProvider);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case TodoFilter.all:
      return todos;
    case TodoFilter.active:
      return todos.where((todo) => !todo.done).toList();
    case TodoFilter.completed:
      return todos.where((todo) => todo.done).toList();
  }
});
