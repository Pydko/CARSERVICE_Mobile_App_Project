import 'package:flutter/material.dart';
import '../data/model.dart';
import '../data/repository.dart';
import '../data/auth_model.dart';
import '../data/auth_repository.dart';

class AppProvider extends ChangeNotifier {
  final AppRepository _repository = AppRepository();
  final AuthRepository _authRepository = AuthRepository();

  AuthUser? _currentUser;
  List<User> _users = [];
  List<Car> _cars = [];
  List<ServiceRecord> _currentServices = [];
  int? _currentCarId;

  AuthUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';
  List<User> get users => _users;
  List<Car> get cars => _cars;
  List<ServiceRecord> get currentServices => _currentServices;

  // ---------- Auth ----------

  Future<String?> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return 'Username and password cannot be empty.';
    }
    final user = await _authRepository.login(username, password);
    if (user == null) return 'Invalid username or password.';
    _currentUser = user;
    await loadInitialData();
    return null;
  }

  Future<String?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      return 'All fields are required.';
    }
    if (!email.contains('@')) return 'Please enter a valid email address.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    return await _authRepository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      password: password,
    );
  }

  Future<String?> updateProfile({
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    if (_currentUser == null) return 'Session not found.';
    final error = await _authRepository.updateProfile(
      id: _currentUser!.id!,
      firstName: firstName,
      lastName: lastName,
      password: password,
    );
    if (error != null) return error;
    _currentUser = AuthUser(
      id: _currentUser!.id,
      firstName: firstName,
      lastName: lastName,
      email: _currentUser!.email,
      username: _currentUser!.username,
      password: password,
      role: _currentUser!.role,
      linkedUserId: _currentUser!.linkedUserId,
    );
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    _users = [];
    _cars = [];
    _currentServices = [];
    _currentCarId = null;
    notifyListeners();
  }

  // ---------- Users ----------

  Future<void> loadInitialData() async {
    _users = await _repository.fetchUsers();
    _cars = await _repository.fetchCars();
    notifyListeners();
  }

  Future<void> addUser(String name) async {
    await _repository.addUser(User(name: name));
    await loadInitialData();
  }

  Future<void> deleteUser(int id) async {
    await _repository.removeUser(id);
    await loadInitialData();
  }

  // ---------- Cars ----------

  Future<void> addCar(int userId, String brand, String model) async {
    await _repository.addCar(Car(userId: userId, brand: brand, model: model));
    await loadInitialData();
  }

  Future<void> updateCar(Car car) async {
    await _repository.editCar(car);
    await loadInitialData();
  }

  Future<void> deleteCar(int id) async {
    await _repository.removeCar(id);
    await loadInitialData();
  }

  // ---------- Services ----------

  Future<void> loadServices(int carId) async {
    _currentCarId = carId;
    _currentServices = await _repository.fetchServices(carId);
    notifyListeners();
  }

  Future<void> addService({
    required int carId,
    required String description,
    required String date,
    required double cost,
    required String oilUsed,
    required int mileage,
  }) async {
    await _repository.addService(
      ServiceRecord(
        carId: carId,
        description: description,
        date: date,
        cost: cost,
        oilUsed: oilUsed,
        mileage: mileage,
      ),
    );
    await loadServices(carId);
  }

  Future<void> updateService(ServiceRecord service) async {
    await _repository.editService(service);
    if (_currentCarId != null) await loadServices(_currentCarId!);
  }

  Future<void> deleteService(int id) async {
    await _repository.removeService(id);
    if (_currentCarId != null) await loadServices(_currentCarId!);
  }
}
