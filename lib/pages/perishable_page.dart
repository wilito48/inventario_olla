import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/inventory_service.dart';


class PerishablePage extends StatefulWidget {
  @override
  _PerishablePageState createState() => _PerishablePageState();
}

class _PerishablePageState extends State<PerishablePage> {
  final InventoryService _inventoryService = InventoryService();
  List<Product> _perishableProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPerishableProducts();
  }

  
  Future<void> _loadPerishableProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _inventoryService.getPerishableProducts();
      setState(() {
        _perishableProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar productos perecederos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  int _getDaysUntilExpiration(Product product) {
    if (product.expirationDate == null) return 0;
    
    final now = DateTime.now();
    final expiration = product.expirationDate!;
    return expiration.difference(now).inDays;
  }

 
  Color _getAlertColor(int daysLeft) {
    if (daysLeft <= 1) return Colors.red;
    if (daysLeft <= 3) return Colors.orange;
    return Colors.yellow[700]!;
  }


  IconData _getAlertIcon(int daysLeft) {
    if (daysLeft <= 1) return Icons.warning;
    if (daysLeft <= 3) return Icons.schedule;
    return Icons.info;
  }


  Widget _buildPerishableCard(Product product) {
    final daysLeft = _getDaysUntilExpiration(product);
    final alertColor = _getAlertColor(daysLeft);
    final alertIcon = _getAlertIcon(daysLeft);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: alertColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: alertColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: alertColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
        
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: alertColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: alertColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    alertIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: alertColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 4),
                      Text(
                        daysLeft == 0 
                            ? '¡VENCE HOY!'
                            : daysLeft == 1
                                ? '¡VENCE MAÑANA!'
                                : 'Vence en $daysLeft días',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: alertColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: alertColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${daysLeft}d',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
    
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
          
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.inventory,
                        label: 'Cantidad',
                        value: '${product.quantity} unidades',
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.calendar_today,
                        label: 'Ingreso',
                        value: product.formattedDateAdded,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
          
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: alertColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: alertColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event,
                        color: alertColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha de vencimiento',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              product.formattedExpirationDate,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: alertColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 12),
                
        
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showProductDetails(product);
                        },
                        icon: Icon(Icons.info_outline, size: 14),
                        label: Text(
                          'Detalles',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: alertColor,
                          side: BorderSide(color: alertColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showConsumeDialog(product);
                        },
                        icon: Icon(Icons.remove_shopping_cart, size: 14),
                        label: Text(
                          'Consumir',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: alertColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

 
  void _showProductDetails(Product product) {
    final daysLeft = _getDaysUntilExpiration(product);
    final alertColor = _getAlertColor(daysLeft);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: alertColor),
              SizedBox(width: 8),
              Expanded(child: Text(
                'Detalles del Producto',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: alertColor,
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Cantidad disponible', '${product.quantity} unidades'),
              _buildDetailRow('Fecha de ingreso', product.formattedDateAdded),
              _buildDetailRow('Fecha de vencimiento', product.formattedExpirationDate),
              _buildDetailRow('Días restantes', '$daysLeft días'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: alertColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: alertColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: alertColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        daysLeft <= 1 
                            ? '¡Prioridad máxima! Usar inmediatamente.'
                            : daysLeft <= 3
                                ? 'Usar en los próximos días.'
                                : 'Planificar uso antes del vencimiento.',
                        style: TextStyle(
                          color: alertColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

 
  void _showConsumeDialog(Product product) {
    final TextEditingController quantityController = TextEditingController();
    quantityController.text = '1';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.remove_shopping_cart, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Registrar Consumo',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Cuántas unidades de "${product.name}" se consumieron?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cantidad consumida',
                  border: OutlineInputBorder(),
                  helperText: 'Disponible: ${product.quantity} unidades',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final consumedQuantity = int.tryParse(quantityController.text) ?? 0;
                if (consumedQuantity > 0 && consumedQuantity <= product.quantity) {
                  try {
                    await _inventoryService.updateProductQuantity(product, product.quantity - consumedQuantity);
                    Navigator.of(context).pop();
                    _loadPerishableProducts(); // Recargar lista
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Consumo registrado: $consumedQuantity unidades'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al registrar consumo: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cantidad inválida'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(
          'Insumos Perecederos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadPerishableProducts,
          ),
        ],
      ),
      body: Column(
        children: [
         
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.orange[600],
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Productos que vencen pronto',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                          Text(
                            'Control de vencimientos próximos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total',
                        '${_perishableProducts.length}',
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Críticos',
                        '${_perishableProducts.where((p) => _getDaysUntilExpiration(p) <= 1).length}',
                        Colors.red,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Urgentes',
                        '${_perishableProducts.where((p) => _getDaysUntilExpiration(p) <= 3).length}',
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          
          Expanded(
            child: _isLoading
                ? CircularProgressIndicator()
                : _perishableProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 64,
                              color: Colors.green[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              '¡Excelente!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No hay productos que vencen pronto',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Todos los productos están bajo control',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _perishableProducts.length,
                        itemBuilder: (context, index) {
                          return _buildPerishableCard(_perishableProducts[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 