import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model.dart';
import '../../controllers/provider.dart';

class EditCarScreen extends StatefulWidget {
  final Car car;
  const EditCarScreen({Key? key, required this.car}) : super(key: key);

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  int? _selectedUserId;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.car.brand);
    _modelController = TextEditingController(text: widget.car.model);
    _selectedUserId = widget.car.userId;
  }

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
      appBar: AppBar(title: const Text('Edit Car')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (isAdmin) ...[
              DropdownButtonFormField<int>(
                value: _selectedUserId,
                decoration: const InputDecoration(
                  labelText: 'Owner',
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

                if (ownerId == null ||
                    _brandController.text.isEmpty ||
                    _modelController.text.isEmpty) return;

                provider.updateCar(Car(
                  id: widget.car.id,
                  userId: ownerId,
                  brand: _brandController.text,
                  model: _modelController.text,
                ));
                Navigator.pop(context);
              },
              child: const Text('Update Car'),
            ),
          ],
        ),
      ),
    );
  }
}