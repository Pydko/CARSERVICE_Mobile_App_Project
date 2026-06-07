import 'database.dart';
import 'model.dart';

class AppDao {
  Future<int> insertUser(User user) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('users', {'name': user.name});
  }

  Future<List<User>> getUsers() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('users');
    return result.map((e) => User.fromMap(e)).toList();
  }

  Future<int> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCar(Car car) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('cars', {
      'userId': car.userId,
      'brand': car.brand,
      'model': car.model,
    });
  }

  Future<List<Car>> getCars() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('cars');
    return result.map((e) => Car.fromMap(e)).toList();
  }

  Future<int> updateCar(Car car) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'cars',
      {'userId': car.userId, 'brand': car.brand, 'model': car.model},
      where: 'id = ?',
      whereArgs: [car.id],
    );
  }

  Future<int> deleteCar(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('cars', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ServiceRecord>> getServicesByCarId(int carId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'services',
      where: 'carId = ?',
      whereArgs: [carId],
      orderBy: 'date DESC',
    );
    return result.map((e) => ServiceRecord.fromMap(e)).toList();
  }

  Future<int> insertService(ServiceRecord service) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('services', {
      'carId': service.carId,
      'description': service.description,
      'date': service.date,
      'cost': service.cost,
      'oilUsed': service.oilUsed,
      'mileage': service.mileage,
    });
  }

  Future<int> updateService(ServiceRecord service) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'services',
      {
        'description': service.description,
        'date': service.date,
        'cost': service.cost,
        'oilUsed': service.oilUsed,
        'mileage': service.mileage,
      },
      where: 'id = ?',
      whereArgs: [service.id],
    );
  }

  Future<int> deleteService(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('services', where: 'id = ?', whereArgs: [id]);
  }
}