import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';

export '../models/todo.dart';

/// Notifier untuk mengelola daftar Todo.
/// Menggunakan Riverpod `Notifier` modern yang menjaga immutability state.
class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => const [];

  /// Menambah item todo baru ke state secara immutable.
  void add(String title) {
    state = [...state, Todo(title)];
  }

  /// Mengubah status selesai/belum selesai dari item pada index tertentu.
  void toggle(int index) {
    final todos = [...state];
    todos[index] = todos[index].copyWith(done: !todos[index].done);
    state = todos;
  }

  /// Menghapus item todo pada index tertentu secara immutable.
  void remove(int index) {
    state = [...state]..removeAt(index);
  }
}

/// Provider global untuk daftar Todo
final todoListProvider =
    NotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);