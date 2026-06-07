import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provider.dart';
import '../../main.dart';
import 'carList.dart';
import 'loginScreen.dart';
import 'profileScreen.dart';
import 'registerUser.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'My Profile',
            onPressed: () => Navigator.push(
              context,
              SmoothPageRoute(page: const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              provider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                SmoothPageRoute(page: const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard, size: 80, color: Colors.grey[700]),
              const SizedBox(height: 16),
              Text(
                'Welcome, ${provider.currentUser?.firstName ?? ''}!',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                provider.isAdmin ? '👑 Admin Account' : '👤 User Account',
                style:
                    TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 28),
              _statCard(
                icon: Icons.people,
                label: 'Registered Users',
                value: provider.users.length.toString(),
              ),
              const SizedBox(height: 10),
              _statCard(
                icon: Icons.directions_car,
                label: 'Registered Cars',
                value: provider.cars.length.toString(),
              ),
              const SizedBox(height: 36),
              if (provider.isAdmin) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.manage_accounts),
                  label: const Text('Manage Users'),
                  onPressed: () => Navigator.push(
                    context,
                    SmoothPageRoute(page: const RegisterUserScreen()),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              ElevatedButton.icon(
                icon: const Icon(Icons.directions_car),
                label: const Text('Cars & Services'),
                onPressed: () => Navigator.push(
                  context,
                  SmoothPageRoute(page: const CarListScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}