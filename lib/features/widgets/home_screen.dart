import 'package:api_handling/core/data/models/todo_item_model.dart';
import 'package:api_handling/core/networking/api_services.dart';
import 'package:api_handling/features/widgets/todo_item.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Todo>> _todosFuture;
  late List<Todo> _todos = ApiService().getlenght() as List<Todo>;
  late int? lastElementID = _todos.last.id as int?;

  final TextEditingController _controller = TextEditingController();

  void _onsubmit(String value) async {
    if (value.isNotEmpty) {
      Todo todo =
          Todo(id: "${lastElementID! + 1}", title: value, completed: false);
      await ApiService().createTodo(todo);
      _controller.clear();
      _refreshTodos();
    }
  }

  @override
  void initState() {
    super.initState();
    _todosFuture = ApiService().getTodos();
  }

  void _refreshTodos() {
    setState(() {
      _todosFuture = ApiService().getTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    ApiService apiService = ApiService();
    return Scaffold(
      body: FutureBuilder(
          future: _todosFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: _controller,
                          onSubmitted: _onsubmit,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'add item',
                            prefixIcon: IconButton(
                                onPressed: () {}, icon: Icon(Icons.add)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Todo List',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        // Replace with your actual item count
                        itemBuilder: (context, index) {
                          final todo = snapshot.data![index];
                          return TodoItem(
                            onDelete: () async {
                              await apiService.deleteTodo(int.parse(todo.id));
                              _refreshTodos();
                              print('deleted item ${todo.id}');
                            },
                            todo: todo,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
