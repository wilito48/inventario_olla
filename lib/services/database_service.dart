import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

/// Servicio para manejar la base de datos SQLite
/// Permite guardar y recuperar productos de forma permanente
class DatabaseService {
  static Database? _database;
  
  /// Obtiene la instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'inventario_olla_comun.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Crea las tablas de la base de datos
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        dateAdded TEXT NOT NULL,
        expirationDate TEXT
      )
    ''');
    
    // Insertar datos de ejemplo
    await _insertSampleData(db);
  }

  /// Inserta datos de ejemplo en la base de datos
  Future<void> _insertSampleData(Database db) async {
    final now = DateTime.now();
    
    final sampleProducts = [
      {
        'name': 'Tomates',
        'quantity': 15,
        'dateAdded': now.subtract(Duration(days: 2)).toIso8601String(),
        'expirationDate': now.add(Duration(days: 3)).toIso8601String(),
      },
      {
        'name': 'Lechugas',
        'quantity': 8,
        'dateAdded': now.subtract(Duration(days: 1)).toIso8601String(),
        'expirationDate': now.add(Duration(days: 5)).toIso8601String(),
      },
      {
        'name': 'Arroz',
        'quantity': 50,
        'dateAdded': now.subtract(Duration(days: 5)).toIso8601String(),
        'expirationDate': null,
      },
      {
        'name': 'Aceite de cocina',
        'quantity': 20,
        'dateAdded': now.subtract(Duration(days: 3)).toIso8601String(),
        'expirationDate': null,
      },
      {
        'name': 'Papa',
        'quantity': 30,
        'dateAdded': now.subtract(Duration(days: 4)).toIso8601String(),
        'expirationDate': now.add(Duration(days: 10)).toIso8601String(),
      },
      {
        'name': 'Cebolla',
        'quantity': 12,
        'dateAdded': now.subtract(Duration(days: 1)).toIso8601String(),
        'expirationDate': now.add(Duration(days: 2)).toIso8601String(),
      },
    ];

    for (var product in sampleProducts) {
      await db.insert('products', product);
    }
  }

  /// Obtiene todos los productos de la base de datos
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    
    return List.generate(maps.length, (i) {
      return Product(
        name: maps[i]['name'],
        quantity: maps[i]['quantity'],
        dateAdded: DateTime.parse(maps[i]['dateAdded']),
        expirationDate: maps[i]['expirationDate'] != null 
            ? DateTime.parse(maps[i]['expirationDate'])
            : null,
      );
    });
  }

  /// Agrega un nuevo producto a la base de datos
  Future<void> addProduct(Product product) async {
    final db = await database;
    await db.insert('products', {
      'name': product.name,
      'quantity': product.quantity,
      'dateAdded': product.dateAdded.toIso8601String(),
      'expirationDate': product.expirationDate?.toIso8601String(),
    });
  }

  /// Actualiza la cantidad de un producto
  Future<void> updateProductQuantity(String productName, int newQuantity) async {
    final db = await database;
    await db.update(
      'products',
      {'quantity': newQuantity},
      where: 'name = ?',
      whereArgs: [productName],
    );
  }

  /// Elimina un producto de la base de datos
  Future<void> deleteProduct(String productName) async {
    final db = await database;
    await db.delete(
      'products',
      where: 'name = ?',
      whereArgs: [productName],
    );
  }

  /// Busca productos por nombre
  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    
    return List.generate(maps.length, (i) {
      return Product(
        name: maps[i]['name'],
        quantity: maps[i]['quantity'],
        dateAdded: DateTime.parse(maps[i]['dateAdded']),
        expirationDate: maps[i]['expirationDate'] != null 
            ? DateTime.parse(maps[i]['expirationDate'])
            : null,
      );
    });
  }

  /// Obtiene productos perecederos (que vencen en 7 días)
  Future<List<Product>> getPerishableProducts() async {
    final db = await database;
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(Duration(days: 7));
    
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'expirationDate IS NOT NULL AND expirationDate <= ? AND expirationDate > ?',
      whereArgs: [sevenDaysFromNow.toIso8601String(), now.toIso8601String()],
    );
    
    return List.generate(maps.length, (i) {
      return Product(
        name: maps[i]['name'],
        quantity: maps[i]['quantity'],
        dateAdded: DateTime.parse(maps[i]['dateAdded']),
        expirationDate: DateTime.parse(maps[i]['expirationDate']),
      );
    });
  }

  /// Obtiene productos vencidos
  Future<List<Product>> getExpiredProducts() async {
    final db = await database;
    final now = DateTime.now();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'expirationDate IS NOT NULL AND expirationDate < ?',
      whereArgs: [now.toIso8601String()],
    );
    
    return List.generate(maps.length, (i) {
      return Product(
        name: maps[i]['name'],
        quantity: maps[i]['quantity'],
        dateAdded: DateTime.parse(maps[i]['dateAdded']),
        expirationDate: DateTime.parse(maps[i]['expirationDate']),
      );
    });
  }

  /// Obtiene productos no perecederos
  Future<List<Product>> getNonPerishableProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'expirationDate IS NULL',
    );
    
    return List.generate(maps.length, (i) {
      return Product(
        name: maps[i]['name'],
        quantity: maps[i]['quantity'],
        dateAdded: DateTime.parse(maps[i]['dateAdded']),
        expirationDate: null,
      );
    });
  }

  /// Cierra la conexión a la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 