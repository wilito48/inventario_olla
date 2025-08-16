import '../models/product.dart';
import 'database_service.dart';

/// Servicio que maneja toda la lógica del inventario de la olla común
/// Gestiona productos, filtros y operaciones del inventario usando SQLite
class InventoryService {
  final DatabaseService _databaseService = DatabaseService();

  /// Obtiene todos los productos del inventario desde la base de datos
  Future<List<Product>> get products async {
    return await _databaseService.getAllProducts();
  }

  /// Agrega un nuevo producto al inventario
  /// [product]: El producto a agregar
  Future<void> addProduct(Product product) async {
    await _databaseService.addProduct(product);
  }

  /// Obtiene solo los productos perecederos que vencen en los próximos 7 días
  /// Útil para la pantalla de alertas de vencimiento
  Future<List<Product>> getPerishableProducts() async {
    return await _databaseService.getPerishableProducts();
  }

  /// Obtiene productos que ya vencieron
  /// Útil para limpiar el inventario
  Future<List<Product>> getExpiredProducts() async {
    return await _databaseService.getExpiredProducts();
  }

  /// Obtiene productos que no tienen fecha de vencimiento
  /// Útil para productos no perecederos
  Future<List<Product>> getNonPerishableProducts() async {
    return await _databaseService.getNonPerishableProducts();
  }

  /// Busca productos por nombre
  /// [query]: Texto a buscar en el nombre del producto
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return await _databaseService.getAllProducts();
    return await _databaseService.searchProducts(query);
  }

  /// Elimina un producto del inventario
  /// [product]: El producto a eliminar
  Future<void> removeProduct(Product product) async {
    await _databaseService.deleteProduct(product.name);
  }

  /// Actualiza la cantidad de un producto
  /// [product]: El producto a actualizar
  /// [newQuantity]: Nueva cantidad
  Future<void> updateProductQuantity(Product product, int newQuantity) async {
    await _databaseService.updateProductQuantity(product.name, newQuantity);
  }

  /// Obtiene estadísticas del inventario
  /// Retorna un mapa con información útil para reportes
  Future<Map<String, dynamic>> getInventoryStats() async {
    final allProducts = await _databaseService.getAllProducts();
    final perishableProducts = await _databaseService.getPerishableProducts();
    final expiredProducts = await _databaseService.getExpiredProducts();
    
    final totalProducts = allProducts.length;
    final perishableCount = perishableProducts.length;
    final expiredCount = expiredProducts.length;
    final totalQuantity = allProducts.fold(0, (sum, product) => sum + product.quantity);

    return {
      'totalProducts': totalProducts,
      'perishableCount': perishableCount,
      'expiredCount': expiredCount,
      'totalQuantity': totalQuantity,
    };
  }

  /// Cierra la conexión a la base de datos
  Future<void> close() async {
    await _databaseService.close();
  }
} 