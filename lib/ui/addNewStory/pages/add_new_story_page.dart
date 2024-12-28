import 'package:flutter/material.dart';

class AddNewStoryPage extends StatefulWidget {
  const AddNewStoryPage({super.key});

  @override
  State<AddNewStoryPage> createState() => _AddNewStoryPageState();
}

class _AddNewStoryPageState extends State<AddNewStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Story'),
      ),
      body: const Center(
        child: Text('Add New Story Page'),
      ),
    );
  }
}
