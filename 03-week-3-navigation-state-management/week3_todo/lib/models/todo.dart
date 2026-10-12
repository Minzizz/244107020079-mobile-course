import 'package:flutter/foundation.dart';

/// Model Todo merepresentasikan satu entitas tugas ToDo.
/// Didesain bersifat immutable dengan method `copyWith` untuk mendukung
/// prinsip unidirectional data flow pada Riverpod.
@immutable
class Todo {
  const Todo(this.title, {this.done = false});

  final String title;
  final bool done;

  /// Menghasilkan salinan Todo baru dengan properti yang diperbarui.
  Todo copyWith({String? title, bool? done}) {
    return Todo(
      title ?? this.title,
      done: done ?? this.done,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          done == other.done;

  @override
  int get hashCode => title.hashCode ^ done.hashCode;

  @override
  String toString() => 'Todo(title: $title, done: $done)';
}
