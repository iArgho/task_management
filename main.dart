import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Task Management',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Task {
  String title, description;
  int deadline;
  Task(this.title, this.description, this.deadline);
}

class CenterRightFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width - 50.0;
    final double fabY = scaffoldGeometry.contentTop + 325.0;
    return Offset(fabX, fabY);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleControl = TextEditingController();
  final TextEditingController _desControl = TextEditingController();
  final TextEditingController _daysControl = TextEditingController();

  List<Task> todos = [];
  GlobalKey<FormState> todoForm = GlobalKey<FormState>();
  bool _sheetOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Task Management'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: _sheetOpen
          ? CenterRightFabLocation()
          : FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return ListTile(
              onLongPress: () {
                setState(() {
                  _sheetOpen = true;
                });
                showBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Task Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text('Title: ${todos[index].title.toString()}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Description: ${todos[index].description.toString()}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Days required: ${todos[index].deadline.toString()}'),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  todos.removeAt(index);
                                  setState(() {
                                    Navigator.pop(context);
                                    _sheetOpen = false;
                                  });
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              title: Text(todos[index].title),
              subtitle: Text(todos[index].description),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 0,
            );
          },
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Form(
            key: todoForm,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleControl,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 4,
                    controller: _desControl,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _daysControl,
                    decoration: const InputDecoration(
                      labelText: 'Days Required',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a deadline';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (todoForm.currentState!.validate()) {
                  todos.add(Task(
                      _titleControl.text,
                      _desControl.text,
                      int.parse(
                        _daysControl.text,
                      )));
                  setState(() {});
                  _titleControl.clear();
                  _desControl.clear();
                  _daysControl.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
