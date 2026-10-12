import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week3_todo/providers/todo_provider.dart';
import 'package:week3_todo/providers/todo_filter_provider.dart';

void main() {
  group('TodoListNotifier Unit Tests', () {
    test('State awal ToDo adalah list kosong', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final todos = container.read(todoListProvider);
      expect(todos, isEmpty);
    });

    test('Menambah todo baru menambahkan item ke state secara immutable', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoListProvider.notifier).add('Belajar Riverpod');

      final todos = container.read(todoListProvider);
      expect(todos.length, 1);
      expect(todos.first.title, 'Belajar Riverpod');
      expect(todos.first.done, isFalse);
    });

    test('Toggle mengubah status done item', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(todoListProvider.notifier);
      notifier.add('Tugas 1');
      expect(container.read(todoListProvider)[0].done, isFalse);

      notifier.toggle(0);
      expect(container.read(todoListProvider)[0].done, isTrue);

      notifier.toggle(0);
      expect(container.read(todoListProvider)[0].done, isFalse);
    });

    test('Remove menghapus item dari state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(todoListProvider.notifier);
      notifier.add('Tugas 1');
      notifier.add('Tugas 2');
      expect(container.read(todoListProvider).length, 2);

      notifier.remove(0);
      final remaining = container.read(todoListProvider);
      expect(remaining.length, 1);
      expect(remaining.first.title, 'Tugas 2');
    });
  });

  group('TodoFilter and filteredTodoListProvider Tests', () {
    test('Filter All mengembalikan semua tugas', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(todoListProvider.notifier);
      notifier.add('Tugas Aktif');
      notifier.add('Tugas Selesai');
      notifier.toggle(1);

      container.read(todoFilterProvider.notifier).setFilter(TodoFilter.all);
      final filtered = container.read(filteredTodoListProvider);
      expect(filtered.length, 2);
    });

    test('Filter Active hanya mengembalikan tugas yang belum selesai', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(todoListProvider.notifier);
      notifier.add('Tugas Aktif');
      notifier.add('Tugas Selesai');
      notifier.toggle(1);

      container.read(todoFilterProvider.notifier).setFilter(TodoFilter.active);
      final filtered = container.read(filteredTodoListProvider);
      expect(filtered.length, 1);
      expect(filtered.first.title, 'Tugas Aktif');
    });

    test('Filter Completed hanya mengembalikan tugas yang sudah selesai', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(todoListProvider.notifier);
      notifier.add('Tugas Aktif');
      notifier.add('Tugas Selesai');
      notifier.toggle(1);

      container.read(todoFilterProvider.notifier).setFilter(TodoFilter.completed);
      final filtered = container.read(filteredTodoListProvider);
      expect(filtered.length, 1);
      expect(filtered.first.title, 'Tugas Selesai');
    });
  });
}
