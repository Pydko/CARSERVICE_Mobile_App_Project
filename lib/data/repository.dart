import 'dao.dart';
import 'model.dart';

class AppRepository {
  final AppDao _dao = AppDao();

  Future<void> addUser(User user) => _dao.insertUser(user);
  Future<List<User>> fetchUsers() => _dao.getUsers();
  Future<void> removeUser(int id) => _dao.deleteUser(id);

  Future<void> addCar(Car car) => _dao.insertCar(car);
  Future<List<Car>> fetchCars() => _dao.getCars();
  Future<void> editCar(Car car) => _dao.updateCar(car);
  Future<void> removeCar(int id) => _dao.deleteCar(id);

  Future<void> addService(ServiceRecord service) => _dao.insertService(service);
  Future<List<ServiceRecord>> fetchServices(int carId) => _dao.getServicesByCarId(carId);
  Future<void> editService(ServiceRecord service) => _dao.updateService(service);
  Future<void> removeService(int id) => _dao.deleteService(id);
}