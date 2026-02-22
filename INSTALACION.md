# 🚀 Guía de Instalación Paso a Paso

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

1. **Flutter SDK** (versión 3.0+)
   - Descarga desde: https://flutter.dev/docs/get-started/install
   - Verifica con: `flutter doctor`

2. **Android Studio** (para Android)
   - Descarga desde: https://developer.android.com/studio
   - O **Xcode** (para iOS, solo en Mac)

3. **Git** (opcional, para clonar)
   - Descarga desde: https://git-scm.com/

---

## Paso 1: Crear el Proyecto Flutter

Abre una terminal y ejecuta:

```bash
flutter create lista_precios_app
cd lista_precios_app
```

---

## Paso 2: Copiar los Archivos

### Estructura de carpetas a crear:

```
lista_precios_app/
├── lib/
│   ├── models/
│   ├── providers/
│   ├── screens/
│   ├── services/
│   └── widgets/
```

### Crear las carpetas:

```bash
cd lib
mkdir models providers screens services widgets
cd ..
```

### Copiar archivos uno por uno:

1. **pubspec.yaml** → Raíz del proyecto (reemplazar el existente)
2. **lib/main.dart** → Reemplazar el existente
3. **lib/models/producto.dart** → Crear nuevo
4. **lib/providers/producto_provider.dart** → Crear nuevo
5. **lib/services/database_service.dart** → Crear nuevo
6. **lib/services/excel_service.dart** → Crear nuevo
7. **lib/screens/home_screen.dart** → Crear nuevo
8. **lib/screens/scanner_screen.dart** → Crear nuevo
9. **lib/screens/producto_form_screen.dart** → Crear nuevo
10. **lib/screens/import_screen.dart** → Crear nuevo
11. **lib/screens/estadisticas_screen.dart** → Crear nuevo
12. **lib/widgets/producto_card.dart** → Crear nuevo
13. **lib/widgets/search_bar_widget.dart** → Crear nuevo

---

## Paso 3: Instalar Dependencias

En la raíz del proyecto, ejecuta:

```bash
flutter pub get
```

Esto descargará todas las dependencias necesarias.

---

## Paso 4: Configurar Permisos para Android

### 4.1 Ubicar el archivo AndroidManifest.xml

```bash
android/app/src/main/AndroidManifest.xml
```

### 4.2 Reemplazar con el contenido proporcionado

O agregar manualmente estos permisos dentro de la etiqueta `<manifest>`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
                 android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />

<uses-feature android:name="android.hardware.camera" android:required="false" />
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
```

### 4.3 Configurar minSdkVersion

En `android/app/build.gradle`, buscar y modificar:

```gradle
defaultConfig {
    minSdkVersion 21  // Cambiar de 16 a 21
    targetSdkVersion flutter.targetSdkVersion
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}
```

---

## Paso 5: Configurar Permisos para iOS (Solo Mac)

### 5.1 Ubicar el archivo Info.plist

```bash
ios/Runner/Info.plist
```

### 5.2 Agregar las siguientes claves antes de `</dict></plist>`:

```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para escanear códigos de barras y QR</string>

<key>NSMicrophoneUsageDescription</key>
<string>Necesitamos acceso al micrófono para búsqueda por voz</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>Necesitamos acceso al reconocimiento de voz para buscar productos</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Necesitamos acceso a tus fotos para cargar imágenes de productos</string>

<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

---

## Paso 6: Verificar la Configuración

Ejecuta el siguiente comando para verificar que todo esté configurado correctamente:

```bash
flutter doctor -v
```

Deberías ver checkmarks (✓) en:
- Flutter
- Android toolchain
- Connected device (si tienes un dispositivo/emulador conectado)

---

## Paso 7: Ejecutar la Aplicación

### En Emulador Android:

1. Abrir Android Studio
2. Iniciar un emulador (AVD Manager)
3. En la terminal:

```bash
flutter run
```

### En Dispositivo Android Físico:

1. Habilitar "Opciones de desarrollador" en el dispositivo
2. Habilitar "Depuración USB"
3. Conectar el dispositivo por USB
4. En la terminal:

```bash
flutter devices  # Verificar que el dispositivo aparezca
flutter run
```

### En Simulador iOS (solo Mac):

```bash
open -a Simulator  # Abrir simulador
flutter run
```

---

## Paso 8: Probar las Funcionalidades

### 8.1 Probar escaneo de códigos

1. Tocar el botón morado flotante
2. Permitir acceso a la cámara cuando lo solicite
3. Apuntar a un código de barras

### 8.2 Probar búsqueda por voz

1. En la barra de búsqueda, tocar el ícono del micrófono
2. Permitir acceso al micrófono cuando lo solicite
3. Decir el nombre de un producto

### 8.3 Probar importación de Excel

1. Crear un archivo Excel con estas columnas:
   - Nombre | Precio | Cantidad
   - Producto 1 | 100 | 50
   - Producto 2 | 200 | 30

2. Guardar como `productos.xlsx`
3. En la app, tocar botón de importar
4. Seleccionar el archivo

---

## Solución de Problemas Comunes

### Error: "Gradle build failed"

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Error: "CocoaPods not installed" (iOS)

```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

### Error de permisos de cámara

- Android: Los permisos se solicitan automáticamente al usar la cámara
- iOS: Asegúrate de que las claves estén en Info.plist

### La app se cierra al abrir el escáner

- Verifica que mobile_scanner esté en pubspec.yaml
- En Android, verifica minSdkVersion >= 21
- Ejecuta: `flutter clean && flutter pub get`

### Reconocimiento de voz no funciona

- Requiere conexión a internet la primera vez
- En Android, verifica que Google App esté actualizada
- Prueba con otro idioma si español no funciona

---

## Compilar para Producción

### Android (APK):

```bash
flutter build apk --release
```

El APK estará en: `build/app/outputs/flutter-apk/app-release.apk`

### Android (App Bundle para Google Play):

```bash
flutter build appbundle --release
```

### iOS (solo Mac):

```bash
flutter build ios --release
```

Luego abrir Xcode para archivar y subir a App Store.

---

## Siguientes Pasos

1. **Personalizar la app:**
   - Cambiar nombre en pubspec.yaml
   - Cambiar ícono de la app
   - Modificar colores en main.dart

2. **Agregar más funcionalidades:**
   - Exportación a PDF
   - Sincronización en la nube
   - Reportes de ventas

3. **Publicar la app:**
   - Google Play Store (Android)
   - Apple App Store (iOS)

---

## Recursos Adicionales

- **Documentación Flutter:** https://flutter.dev/docs
- **Tutoriales:** https://flutter.dev/docs/cookbook
- **Paquetes:** https://pub.dev
- **Comunidad:** https://flutter.dev/community

---

¿Necesitas ayuda? Crea un issue en GitHub o contacta al desarrollador.

**¡Buena suerte con tu app! 🚀**
