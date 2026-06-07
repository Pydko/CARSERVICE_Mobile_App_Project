import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provider.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  int? _selectedUserId;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isAdmin = provider.isAdmin;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Car')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isAdmin) ...[
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Select Owner',
                  border: OutlineInputBorder(),
                ),
                items: provider.users
                    .map((u) => DropdownMenuItem(
                        value: u.id, child: Text(u.name)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedUserId = val),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final ownerId = isAdmin
                    ? _selectedUserId
                    : provider.currentUser?.linkedUserId;

                if (ownerId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select an owner.')),
                  );
                  return;
                }
                if (_brandController.text.isEmpty ||
                    _modelController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill in all fields.')),
                  );
                  return;
                }
                provider.addCar(ownerId, _brandController.text,
                    _modelController.text);
                Navigator.pop(context);
              },
              child: const Text('Save Car'),
            ),
          ],
        ),
      ),
    );
  }
}