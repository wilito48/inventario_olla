import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/inventory_service.dart';


class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final InventoryService _inventoryService = InventoryService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

 
  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _inventoryService.products;
      setState(() {
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar productos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

 
  Future<void> _applyFilters() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Product> products;

 
      switch (_selectedFilter) {
        case 'Perecederos':
          products = await _inventoryService.getPerishableProducts();
          break;
        case 'No Perecederos':
          products = await _inventoryService.getNonPerishableProducts();
          break;
        case 'Vencidos':
          products = await _inventoryService.getExpiredProducts();
          break;
        default:
        
          products = await _inventoryService.products;
          break;
      }

     
      if (_searchQuery.isNotEmpty) {
        products = await _inventoryService.searchProducts(_searchQuery);
      }

      setState(() {
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al aplicar filtros: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Widget _buildProductCard(Product product) {
    final bool isExpired = product.isExpired();
    final bool isPerishableSoon = product.isPerishableSoon();
    
    Color cardColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    
    if (isExpired) {
      cardColor = Colors.red[50]!;
      borderColor = Colors.red[300]!;
    } else if (isPerishableSoon) {
      cardColor = Colors.orange[50]!;
      borderColor = Colors.orange[300]!;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getProductColor(product).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getProductIcon(product),
            color: _getProductColor(product),
            size: 24,
          ),
        ),
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isExpired ? Colors.red[700] : Colors.grey[800],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.inventory, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Cantidad: ${product.quantity}',
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Ingreso: ${product.formattedDateAdded}',
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (product.expirationDate != null) ...[
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    isExpired ? Icons.warning : Icons.schedule,
                    size: 16,
                    color: isExpired ? Colors.red : Colors.orange,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Vence: ${product.formattedExpirationDate}',
                      style: TextStyle(
                        color: isExpired ? Colors.red : Colors.orange[700],
                        fontWeight: isExpired || isPerishableSoon ? FontWeight.bold : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: _buildStatusIndicator(product),
        onTap: () {
          _showProductDetails(product);
        },
      ),
    );
  }


  Widget _buildStatusIndicator(Product product) {
    if (product.isExpired()) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'VENCIDO',
          style: TextStyle(
            color: Colors.red[700],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (product.isPerishableSoon()) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'PRONTO',
          style: TextStyle(
            color: Colors.orange[700],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'OK',
          style: TextStyle(
            color: Colors.green[700],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }


  Color _getProductColor(Product product) {
    if (product.name.toLowerCase().contains('arroz') || 
        product.name.toLowerCase().contains('papa') ||
        product.name.toLowerCase().contains('cebolla')) {
      return Colors.brown[600]!;
    } else if (product.name.toLowerCase().contains('tomate') ||
               product.name.toLowerCase().contains('lechuga')) {
      return Colors.green[600]!;
    } else if (product.name.toLowerCase().contains('aceite')) {
      return Colors.amber[600]!;
    } else {
      return Colors.blue[600]!;
    }
  }


  IconData _getProductIcon(Product product) {
    if (product.name.toLowerCase().contains('arroz')) {
      return Icons.grain;
    } else if (product.name.toLowerCase().contains('papa')) {
      return Icons.eco;
    } else if (product.name.toLowerCase().contains('tomate')) {
      return Icons.local_florist;
    } else if (product.name.toLowerCase().contains('aceite')) {
      return Icons.opacity;
    } else {
      return Icons.inventory_2;
    }
  }


  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(_getProductIcon(product), color: _getProductColor(product)),
              SizedBox(width: 8),
              Expanded(child: Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Cantidad', '${product.quantity} unidades'),
              _buildDetailRow('Fecha de ingreso', product.formattedDateAdded),
              if (product.expirationDate != null)
                _buildDetailRow('Fecha de vencimiento', product.formattedExpirationDate),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: product.isExpired() 
                      ? Colors.red[50] 
                      : product.isPerishableSoon() 
                          ? Colors.orange[50] 
                          : Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      product.isExpired() 
                          ? Icons.warning 
                          : product.isPerishableSoon() 
                              ? Icons.schedule 
                              : Icons.check_circle,
                      color: product.isExpired() 
                          ? Colors.red 
                          : product.isPerishableSoon() 
                              ? Colors.orange 
                              : Colors.green,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        product.isExpired() 
                            ? 'Producto vencido'
                            : product.isPerishableSoon() 
                                ? 'Vence pronto'
                                : 'En buen estado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: product.isExpired() 
                              ? Colors.red[700] 
                              : product.isPerishableSoon() 
                                  ? Colors.orange[700] 
                                  : Colors.green[700],
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


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(
          'Lista de Productos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedFilter = 'Todos';
                _searchController.clear();
              });
              _loadProducts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
    
          Container(
            padding: EdgeInsets.all(12),
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
    
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _applyFilters();
                  },
                ),
                
                SizedBox(height: 12),
                
        
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos'),
                      SizedBox(width: 8),
                      _buildFilterChip('Perecederos'),
                      SizedBox(width: 8),
                      _buildFilterChip('No Perecederos'),
                      SizedBox(width: 8),
                      _buildFilterChip('Vencidos'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          

          Expanded(
            child: _isLoading
                ? CircularProgressIndicator()
                : _filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No se encontraron productos',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Intenta cambiar los filtros o la búsqueda',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(_filteredProducts[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }


  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      label: Text(filter),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
        _applyFilters();
      },
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.blue[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[700] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
} 