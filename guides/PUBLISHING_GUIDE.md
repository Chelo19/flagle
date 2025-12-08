# Guía de Publicación - Flagle

Esta guía te ayudará a publicar tu app Flagle en las tiendas de aplicaciones.

## 📋 Pre-requisitos

### Para iOS (App Store)
- Cuenta de desarrollador de Apple ($99/año)
- Mac con Xcode instalado
- Certificados y perfiles de aprovisionamiento configurados

### Para Android (Google Play)
- Cuenta de desarrollador de Google Play ($25 única vez)
- Keystore para firmar la app

---

## 🍎 Publicar en iOS (App Store)

### 1. Configurar el Bundle Identifier

El bundle identifier actual es `com.example.flagle`. Debes cambiarlo a uno único:

**En Xcode:**
1. Abre `ios/Runner.xcworkspace` en Xcode
2. Selecciona el proyecto "Runner" en el navegador
3. Selecciona el target "Runner"
4. Ve a la pestaña "Signing & Capabilities"
5. Cambia el Bundle Identifier a algo único como: `com.tudominio.flagle`
6. Asegúrate de que "Automatically manage signing" esté activado
7. Selecciona tu Team de desarrollador

### 2. Actualizar la descripción de la app

Edita `ios/Runner/Info.plist` y actualiza:
- `CFBundleDisplayName`: Nombre que verán los usuarios
- `CFBundleShortVersionString`: Versión (1.0.0)
- `CFBundleVersion`: Número de build (1)

### 3. Crear ícono de la app

1. Prepara un ícono de 1024x1024 píxeles
2. En Xcode, ve a `ios/Runner/Assets.xcassets/AppIcon.appiconset`
3. Agrega todas las resoluciones necesarias

### 4. Generar el build de producción

```bash
# Limpiar el proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Generar el build de iOS
flutter build ipa --release
```

El archivo `.ipa` se generará en `build/ios/ipa/`

### 5. Subir a App Store Connect

**Opción A: Usando Xcode**
1. Abre Xcode
2. Product → Archive
3. Una vez archivado, haz clic en "Distribute App"
4. Selecciona "App Store Connect"
5. Sigue el asistente

**Opción B: Usando Transporter (app de Mac)**
1. Descarga Transporter desde el Mac App Store
2. Abre Transporter
3. Arrastra el archivo `.ipa`
4. Haz clic en "Deliver"

**Opción C: Usando la línea de comandos**
```bash
xcrun altool --upload-app --type ios --file build/ios/ipa/flagle.ipa --apiKey YOUR_API_KEY --apiIssuer YOUR_ISSUER_ID
```

### 6. Configurar en App Store Connect

1. Ve a [App Store Connect](https://appstoreconnect.apple.com)
2. Crea una nueva app
3. Completa la información:
   - Nombre: Flagle
   - Idioma principal: Español/Inglés
   - Bundle ID: El que configuraste
   - SKU: Un identificador único
4. Agrega capturas de pantalla (requeridas):
   - iPhone 6.7" (1290 x 2796)
   - iPhone 6.5" (1284 x 2778)
   - iPad Pro 12.9" (2048 x 2732)
5. Completa la descripción, palabras clave, categoría, etc.
6. Configura la información de privacidad
7. Envía para revisión

---

## 🤖 Publicar en Android (Google Play)

### 1. Crear un Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Guarda la contraseña y el alias de forma segura.

### 2. Configurar la firma en Android

Crea el archivo `android/key.properties`:

```properties
storePassword=<password-del-keystore>
keyPassword=<password-de-la-key>
keyAlias=upload
storeFile=<ruta-al-keystore>
```

**⚠️ IMPORTANTE:** Agrega `android/key.properties` a `.gitignore` para no subirlo a Git.

### 3. Configurar build.gradle

Edita `android/app/build.gradle.kts` y agrega la configuración de firma (ver sección siguiente).

### 4. Actualizar el Application ID

Edita `android/app/build.gradle.kts` y cambia:
```kotlin
applicationId = "com.example.flagle"
```
a algo único como:
```kotlin
applicationId = "com.tudominio.flagle"
```

### 5. Generar el APK/AAB

```bash
# Limpiar el proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Generar App Bundle (recomendado para Play Store)
flutter build appbundle --release

# O generar APK (para testing)
flutter build apk --release
```

El archivo `.aab` estará en `build/app/outputs/bundle/release/`

### 6. Subir a Google Play Console

1. Ve a [Google Play Console](https://play.google.com/console)
2. Crea una nueva app
3. Completa la información básica:
   - Nombre de la app: Flagle
   - Idioma predeterminado
   - Tipo de app: App
   - Gratis o de pago
4. Crea una versión de producción
5. Sube el archivo `.aab`
6. Completa:
   - Descripción corta (80 caracteres)
   - Descripción completa
   - Capturas de pantalla (mínimo 2)
   - Ícono de alta resolución (512x512)
   - Imagen destacada (1024x500)
7. Completa la política de privacidad
8. Configura la clasificación de contenido
9. Envía para revisión

---

## 🔧 Configuración Adicional Recomendada

### Actualizar build.gradle.kts para Android

Agrega esto al inicio de `android/app/build.gradle.kts`:

```kotlin
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Y en la sección `android { ... }`:

```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties['keyAlias']
        keyPassword = keystoreProperties['keyPassword']
        storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword = keystoreProperties['storePassword']
    }
}
buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

### Actualizar la versión

En `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
- `1.0.0` = versión visible al usuario
- `+1` = número de build (debe incrementarse en cada release)

---

## 📱 Checklist Pre-Publicación

- [ ] Actualizar descripción en `pubspec.yaml`
- [ ] Cambiar Bundle ID / Application ID a uno único
- [ ] Crear ícono de la app (1024x1024)
- [ ] Preparar capturas de pantalla
- [ ] Probar la app en dispositivos reales
- [ ] Verificar que no haya errores de consola
- [ ] Configurar firma (Android)
- [ ] Generar build de release
- [ ] Probar el build de release
- [ ] Preparar descripción para la tienda
- [ ] Preparar política de privacidad (si aplica)
- [ ] Configurar clasificación de contenido

---

## 🚀 Comandos Útiles

```bash
# Verificar el estado de Flutter
flutter doctor

# Limpiar el proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Analizar el código
flutter analyze

# Build para iOS
flutter build ipa --release

# Build para Android (AAB)
flutter build appbundle --release

# Build para Android (APK)
flutter build apk --release

# Ver el tamaño de la app
flutter build apk --release --analyze-size
```

---

## 📚 Recursos Adicionales

- [Documentación oficial de Flutter - Deployment](https://docs.flutter.dev/deployment)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)
- [Material Design Guidelines](https://material.io/design)

---

## ⚠️ Notas Importantes

1. **Bundle ID / Application ID**: Debe ser único y no puede cambiarse después de la primera publicación
2. **Versiones**: Incrementa el número de build en cada release
3. **Privacidad**: Si tu app recopila datos, necesitas una política de privacidad
4. **Permisos**: Solo solicita los permisos que realmente necesitas
5. **Testing**: Prueba exhaustivamente antes de publicar
6. **Keystore**: Guarda el keystore de Android en un lugar seguro (si lo pierdes, no podrás actualizar la app)

---

¡Buena suerte con la publicación! 🎉

