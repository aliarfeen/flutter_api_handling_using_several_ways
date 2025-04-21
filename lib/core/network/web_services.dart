import 'package:api_handling/core/data/models/todo_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  // Improved error handling function
  void _handleResponseError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    debugPrint('Error ${response.statusCode}: ${response.body}');
    throw Exception(
        'Failed to perform operation: ${response.statusCode}, ${response.body}');
  }

  // GET all todos
  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(_baseUrl));
    _handleResponseError(response);

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((json) => Todo.fromJson(json)).toList();
  }

  // GET a single todo by ID
  Future<Todo> getTodo(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    _handleResponseError(response);

    final Map<String, dynamic> body = jsonDecode(response.body);
    return Todo.fromJson(body);
  }

  // POST a new todo
  Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );
    _handleResponseError(response);

    final Map<String, dynamic> body = jsonDecode(response.body);
    return Todo.fromJson(body);
  }

  // PUT (update) an existing todo
  Future<Todo> updateTodo(int id, Todo updatedTodo) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedTodo.toJson()),
    );
    _handleResponseError(response);

    final Map<String, dynamic> body = jsonDecode(response.body);
    return Todo.fromJson(body);
  }

  // DELETE a todo
  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    _handleResponseError(response);
  }
}
