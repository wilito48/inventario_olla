class Product {
  final String name;          
  final int quantity;         
  final DateTime dateAdded;   
  final DateTime? expirationDate; 

  /// Constructor del producto
  /// [name]: Nombre del producto (ej: "Arroz", "Papa", "Aceite")
  /// [quantity]: Cantidad disponible en inventario
  /// [dateAdded]: Fecha cuando se agregó al inventario
  /// [expirationDate]: Fecha de vencimiento (null si no aplica)
  Product({
    required this.name,
    required this.quantity,
    required this.dateAdded,
    this.expirationDate,
  });


  bool isPerishableSoon() {
    if (expirationDate == null) return false;
    
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(Duration(days: 7));
    
    return expirationDate!.isBefore(sevenDaysFromNow) && 
           expirationDate!.isAfter(now);
  }


  bool isExpired() {
    if (expirationDate == null) return false;
    return expirationDate!.isBefore(DateTime.now());
  }


  String get formattedDateAdded {
    return "${dateAdded.day.toString().padLeft(2, '0')}/"
           "${dateAdded.month.toString().padLeft(2, '0')}/"
           "${dateAdded.year}";
  }


  String get formattedExpirationDate {
    if (expirationDate == null) return "Sin fecha";
    return "${expirationDate!.day.toString().padLeft(2, '0')}/"
           "${expirationDate!.month.toString().padLeft(2, '0')}/"
           "${expirationDate!.year}";
  }
} 
