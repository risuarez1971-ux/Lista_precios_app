# Lista de Precios - El Torreón

Aplicación móvil Flutter para gestión de inventario y lista de precios con escaneo de códigos de barras/QR, búsqueda por voz y control de stock.

## 🚀 Características

### ✅ Implementadas
- ✨ **Escaneo de códigos de barras y QR** con `mobile_scanner`
- 🗣️ **Búsqueda por voz** en español
- 📊 **Importación desde Excel** (.xlsx, .xls)
- 💾 **Base de datos local** SQLite para almacenamiento
- 📦 **Control de inventario** con alertas de bajo stock
- 🔍 **Búsqueda en tiempo real** (por texto o voz)
- 📈 **Estadísticas** de inventario y ventas
- 💰 **Cálculo automático** de margen de ganancia
- 🏷️ **Categorías** de productos
- 📱 **Diseño moderno** con Material Design 3

## 📋 Requisitos

- Flutter 3.0 o superior
- Dart 3.0 o superior
- Android Studio / VS Code
- Para Android: API 21+ (Android 5.0+)
- Para iOS: iOS 12.0+

## 🛠️ Instalación

### 1. Clonar el repositorio o crear nuevo proyecto

```bash
flutter create lista_precios_app
cd lista_precios_app
```

### 2. Copiar los archivos

Copiar todos los archivos proporcionados a las siguientes ubicaciones:

```
lista_precios_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── producto.dart
│   ├── providers/
│   │   └── producto_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── scanner_screen.dart
│   │   ├── producto_form_screen.dart
│   │   ├── import_screen.dart
│   │   └── estadisticas_screen.dart
│   ├── services/
│   │   ├── database_service.dart
│   │   └── excel_service.dart
│   └── widgets/
│       ├── producto_card.dart
│       └── search_bar_widget.dart
├── android/app/src/main/AndroidManifest.xml
├── ios/Runner/Info.plist
└── pubspec.yaml
```

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. Configurar permisos

#### Android
Reemplazar `android/app/src/main/AndroidManifest.xml` con el archivo proporcionado.

#### iOS
Agregar las claves del archivo `Info.plist` al archivo `ios/Runner/Info.plist`.

### 5. Ejecutar la aplicación

```bash
# En emulador/dispositivo Android
flutter run

# En simulador/dispositivo iOS
flutter run
```

## 📖 Uso

### Agregar productos

#### Opción 1: Escaneo de código de barras
1. Toca el botón **morado flotante** (ícono de escáner)
2. Apunta la cámara al código de barras o QR
3. Si el producto existe, muestra opciones para ajustar stock
4. Si es nuevo, abre formulario para completar datos

#### Opción 2: Manual
1. Toca el botón **verde flotante** (ícono +)
2. Completa el formulario:
   - Nombre (requerido)
   - Precio (requerido)
   - Código de barras (opcional)
   - Cantidad en stock
   - Categoría
   - Precio de compra (para calcular margen)
   - Proveedor
   - Descripción

### Buscar productos

#### Búsqueda por texto
- Escribe en la barra de búsqueda
- Busca por nombre, código de barras o descripción

#### Búsqueda por voz
1. Toca el ícono del **micrófono** en la barra de búsqueda
2. Di el nombre del producto
3. Los resultados se filtran automáticamente

### Importar datos desde Excel

1. Toca el botón de **importar** (ícono de archivo)
2. Selecciona un archivo `.xlsx` o `.xls`
3. El archivo debe tener estos encabezados en la primera fila:
   - **Nombre** (requerido)
   - **Precio** (requerido)
   - Código de Barras
   - Cantidad
   - Categoría
   - Descripción
   - Precio de Compra
   - Proveedor

### Ver estadísticas

1. Toca el botón de **estadísticas** en la barra superior
2. Visualiza:
   - Total de productos
   - Productos con bajo stock
   - Valor total del inventario
   - Lista de productos con stock crítico

### Editar producto

1. Toca cualquier tarjeta de producto
2. Modifica los campos necesarios
3. Presiona "Guardar Cambios"

### Eliminar producto

1. Toca el producto para editarlo
2. Presiona el ícono de **papelera** en la barra superior
3. Confirma la eliminación

## 🗂️ Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── models/
│   └── producto.dart           # Modelo de datos
├── providers/
│   └── producto_provider.dart  # Gestión de estado
├── screens/
│   ├── home_screen.dart        # Pantalla principal
│   ├── scanner_screen.dart     # Escaneo de códigos
│   ├── producto_form_screen.dart # Formulario CRUD
│   ├── import_screen.dart      # Importación Excel
│   └── estadisticas_screen.dart # Estadísticas
├── services/
│   ├── database_service.dart   # SQLite
│   └── excel_service.dart      # Importación Excel
└── widgets/
    ├── producto_card.dart      # Tarjeta de producto
    └── search_bar_widget.dart  # Búsqueda con voz
```

## 📦 Dependencias Principales

```yaml
dependencies:
  mobile_scanner: ^3.5.5      # Escaneo de códigos
  excel: ^4.0.2               # Manejo de Excel
  file_picker: ^6.1.1         # Selector de archivos
  sqflite: ^2.3.0             # Base de datos SQLite
  speech_to_text: ^6.5.1      # Reconocimiento de voz
  provider: ^6.1.1            # Gestión de estado
  google_fonts: ^6.1.0        # Tipografías
```

## 🔧 Configuración Adicional

### Cambiar el nombre de la app

En `pubspec.yaml`:
```yaml
name: lista_precios_app
description: Tu descripción
```

En `AndroidManifest.xml`:
```xml
android:label="Tu Nombre"
```

### Cambiar el ícono

1. Agrega tu ícono en `assets/icon.png`
2. Usa `flutter_launcher_icons`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.0

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon.png"
```

```bash
flutter pub run flutter_launcher_icons
```

## 🐛 Solución de Problemas

### Error de permisos de cámara
- Verifica que los permisos estén en `AndroidManifest.xml` e `Info.plist`
- En Android 6+, los permisos se solicitan en tiempo de ejecución

### Error al importar Excel
- Asegúrate de que la primera fila tenga encabezados
- Verifica que las columnas "Nombre" y "Precio" existan
- Los números deben usar punto (.) como separador decimal

### Error de reconocimiento de voz
- Verifica permisos de micrófono
- En Android, habilita "Reconocimiento de voz offline" en configuración
- Requiere conexión a internet la primera vez

### Base de datos no se actualiza
- La app guarda automáticamente cada 60 segundos
- Para forzar guardado, realiza una acción (crear/editar/eliminar)

## 📱 Capturas de Pantalla

(Agrega capturas de pantalla de tu app aquí)

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu función (`git checkout -b feature/nuevaCaracteristica`)
3. Commit tus cambios (`git commit -m 'Agrega nueva característica'`)
4. Push a la rama (`git push origin feature/nuevaCaracteristica`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## ✨ Características Futuras (Roadmap)

- [ ] Exportación a PDF
- [ ] Sincronización en la nube (Firebase)
- [ ] Modo offline completo
- [ ] Reportes de ventas
- [ ] Múltiples usuarios
- [ ] Dashboard web
- [ ] Integración con impresoras térmicas
- [ ] Etiquetas con códigos de barras

## 📞 Soporte

Para soporte, crea un issue en GitHub o contacta a [tu email].

---

**Desarrollado con ❤️ usando Flutter**
