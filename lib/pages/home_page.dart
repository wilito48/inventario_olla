import 'package:flutter/material.dart';
import 'product_list_page.dart';
import 'perishable_page.dart';
import 'add_product_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(
          'Inventario Olla Común',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
        centerTitle: true,
        actions: [
          
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 50,
                      color: Colors.green[600],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '¡Bienvenido al Control de Inventario!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gestiona los insumos de tu olla común',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
             
              Expanded(
                child: Column(
                  children: [
                    
                    _buildMainButton(
                      context: context,
                      title: '📦 Lista de Productos',
                      subtitle: 'Ver todos los insumos registrados',
                      icon: Icons.inventory_2,
                      color: Colors.blue[600]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListPage(),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 20),
                    
                   
                    _buildMainButton(
                      context: context,
                      title: '🍅 Insumos Perecederos',
                      subtitle: 'Productos que vencen pronto',
                      icon: Icons.warning_amber,
                      color: Colors.orange[600]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PerishablePage(),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 20),
                    
                   
                    _buildMainButton(
                      context: context,
                      title: '➕ Agregar Productos',
                      subtitle: 'Registrar nuevos insumos',
                      icon: Icons.add_circle_outline,
                      color: Colors.green[600]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProductPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
             
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFooterItem(
                      icon: Icons.people,
                      label: 'Comunidad',
                      value: 'Olla Común',
                    ),
                    _buildFooterItem(
                      icon: Icons.inventory,
                      label: 'Productos',
                      value: 'Control Total',
                    ),
                    _buildFooterItem(
                      icon: Icons.security,
                      label: 'Seguro',
                      value: 'Datos Locales',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildMainButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 85,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 25,
                    color: color,
                  ),
                ),
                
                SizedBox(width: 12),
                
               
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                
                
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
  Widget _buildFooterItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.green[600],
          ),
          SizedBox(height: 2),
                      Text(
              label,
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
        ],
      ),
    );
  }

 
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.green[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Acerca de la App',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventario Olla Común',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Aplicación móvil para el control de inventario de ollas comunes que reciben insumos donados por el Estado.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                'Funcionalidades:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• Registro de productos'),
              Text('• Control de perecederos'),
              Text('• Inventario organizado'),
              Text('• Interfaz responsiva'),
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
} 