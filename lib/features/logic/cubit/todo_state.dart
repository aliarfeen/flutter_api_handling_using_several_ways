part of 'todo_cubit.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoLoaded extends TodoState {
  final List<TodoItem> todos;
  final int? lastElementID;
  TodoLoaded({required this.todos, required this.lastElementID});
}

final class TodoError extends TodoState {
  final String error;
  TodoError({required this.error});
}

final class TodoCreated extends TodoState {
  final TodoItem todo;
  TodoCreated({required this.todo});
}

final class TodoDeleted extends TodoState {
  final int id;
  TodoDeleted({required this.id});
}

final class TodoUpdated extends TodoState {
  final TodoItem todo;
  TodoUpdated({required this.todo});
}

final class TodoRefreshed extends TodoState {
  final List<TodoItem> todos;
  final int? lastElementID;
  TodoRefreshed({required this.todos, required this.lastElementID});
}
