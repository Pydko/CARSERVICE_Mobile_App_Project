class User {
  final int? id;
  final String name;

  User({this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as int?,
        name: map['name'] as String,
      );
}

class Car {
  final int? id;
  final int userId;
  final String brand;
  final String model;

  Car({this.id, required this.userId, required this.brand, required this.model});

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'brand': brand,
        'model': model,
      };

  factory Car.fromMap(Map<String, dynamic> map) => Car(
        id: map['id'] as int?,
        userId: map['userId'] as int,
        brand: map['brand'] as String,
        model: map['model'] as String,
      );
}

class ServiceRecord {
  final int? id;
  final int carId;
  final String description;
  final String date;
  final double cost; // Ücret
  final String oilUsed; // Kullanılan Yağ
  final int mileage; // Kilometre bilgisi

  ServiceRecord({
    this.id,
    required this.carId,
    required this.description,
    required this.date,
    required this.cost,
    required this.oilUsed,
    required this.mileage,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'carId': carId,
        'description': description,
        'date': date,
        'cost': cost,
        'oilUsed': oilUsed,
        'mileage': mileage,
      };

  factory ServiceRecord.fromMap(Map<String, dynamic> map) => ServiceRecord(
        id: map['id'] as int?,
        carId: map['carId'] as int,
        description: map['description'] as String,
        date: map['date'] as String,
        // Eğer veritabanı silinmemişse ve eski kayıtlar gelirse hata vermemesi için
        // null kontrolü (??) ve varsayılan değerler eklendi:
        cost: (map['cost'] as num?)?.toDouble() ?? 0.0,
        oilUsed: map['oilUsed'] as String? ?? 'Belirtilmedi',
        mileage: map['mileage'] as int? ?? 0,
      );
}