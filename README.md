# 📱 Aplicación de Inventario

Una aplicación móvil desarrollada en Flutter para la gestión de inventarios de manera eficiente y fácil de usar.

## 🚀 Características

- ✅ Gestión de productos
- ✅ Control de stock
- ✅ Productos perecederos
- ✅ Base de datos local (SQLite)
- ✅ Interfaz intuitiva y responsive

## 📋 Requisitos Previos

Para ejecutar este proyecto necesitas:

- **Flutter SDK** (versión 3.0 o superior)
- **Android Studio** o **VS Code**
- **Android SDK** (para desarrollo Android)
- **Xcode** (para desarrollo iOS - solo macOS)

## 🛠️ Instalación

### 1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/inventario.git
cd inventario
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Ejecutar la aplicación
```bash
flutter run
```

## 📱 Compilar para producción

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (para Google Play)
```bash
flutter build appbundle --release
```

### iOS (solo en macOS)
```bash
flutter build ios --release
```

## 🗂️ Estructura del Proyecto

```
lib/
├── main.dart              # Punto de entrada de la aplicación
├── models/
│   └── product.dart       # Modelo de datos para productos
├── pages/
│   ├── home_page.dart     # Página principal
│   ├── login_page.dart    # Página de login
│   ├── add_product_page.dart  # Agregar productos
│   ├── product_list_page.dart # Lista de productos
│   └── perishable_page.dart   # Productos perecederos
└── services/
    ├── database_service.dart   # Servicio de base de datos
    └── inventory_service.dart  # Lógica de negocio
```

## 🔧 Configuración

### Base de Datos
La aplicación utiliza SQLite para almacenamiento local. No se requiere configuración adicional.

### Permisos
- **Almacenamiento**: Para guardar datos localmente
- **Cámara**: Para escanear códigos de barras (futuro)

## 📸 Capturas de Pantalla

[Agregar capturas de pantalla de la aplicación aquí]

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE.md](LICENSE.md) para detalles.

## 👨‍💻 Autor

**Tu Nombre**
- GitHub: [@tu-usuario](https://github.com/tu-usuario)

## 🙏 Agradecimientos

- Flutter team por el framework
- Comunidad de desarrolladores Flutter
- Todos los contribuidores del proyecto

---

⭐ Si te gusta este proyecto, ¡dale una estrella en GitHub!
