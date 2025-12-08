# Guía para Publicar en TestFlight

TestFlight es la plataforma de Apple para distribuir versiones beta de tu app a testers antes de publicarla en el App Store.

## 📋 Pre-requisitos

- ✅ Cuenta de desarrollador de Apple ($99/año)
- ✅ Mac con Xcode instalado (versión más reciente recomendada)
- ✅ Certificados y perfiles de aprovisionamiento configurados
- ✅ App configurada y funcionando correctamente

---

## 🚀 Pasos para Publicar en TestFlight

### 1. Configurar el Bundle Identifier

**IMPORTANTE:** El Bundle ID debe ser único y no puede cambiarse después.

1. Abre `ios/Runner.xcworkspace` en Xcode
2. Selecciona el proyecto "Runner" en el navegador izquierdo
3. Selecciona el target "Runner"
4. Ve a la pestaña **"Signing & Capabilities"**
5. Cambia el **Bundle Identifier** a algo único:
   - Ejemplo: `com.tudominio.flagle`
   - **NO uses** `com.example.flagle` (Apple lo rechaza)
6. Asegúrate de que **"Automatically manage signing"** esté activado
7. Selecciona tu **Team** de desarrollador de Apple
8. Xcode generará automáticamente los certificados y perfiles necesarios

### 2. Verificar la Configuración de la App

#### En `ios/Runner/Info.plist`:
- `CFBundleDisplayName`: "Flagle" (nombre que verán los usuarios)
- `CFBundleShortVersionString`: Versión (ej: "1.0.0")
- `CFBundleVersion`: Número de build (ej: "1")

#### En `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
- `1.0.0` = versión visible (CFBundleShortVersionString)
- `+1` = número de build (CFBundleVersion)

**Nota:** Cada vez que subas una nueva versión a TestFlight, incrementa el número de build.

### 3. Limpiar y Preparar el Proyecto

```bash
# Navegar al directorio del proyecto
cd /Users/marcelodeleon/Developer/personales/flagle

# Limpiar el proyecto
flutter clean

# Obtener dependencias actualizadas
flutter pub get

# Verificar que no haya errores
flutter analyze
```

### 4. Generar el Build de iOS

```bash
# Generar el build de iOS (esto crea un .xcarchive)
flutter build ipa --release
```

El archivo `.ipa` se generará en: `build/ios/ipa/flagle.ipa`

**Alternativa usando Xcode directamente:**
1. Abre `ios/Runner.xcworkspace` en Xcode
2. Selecciona "Any iOS Device" o un dispositivo específico en el selector
3. Product → Archive
4. Espera a que se complete el proceso

### 5. Subir a App Store Connect

#### Opción A: Usando Xcode (Recomendado)

1. **Abrir el Organizer:**
   - En Xcode: Window → Organizer (o `Cmd + Shift + 9`)
   - O después de hacer Archive, aparecerá automáticamente

2. **Seleccionar el Archive:**
   - Verás tu build archivado
   - Verifica la información (versión, fecha, etc.)

3. **Distribuir la App:**
   - Haz clic en **"Distribute App"**
   - Selecciona **"App Store Connect"**
   - Haz clic en **"Next"**

4. **Opciones de Distribución:**
   - Selecciona **"Upload"** (no "Export")
   - Haz clic en **"Next"**

5. **Opciones de Distribución Adicionales:**
   - Deja las opciones por defecto (Include bitcode, etc.)
   - Haz clic en **"Next"**

6. **Revisar y Confirmar:**
   - Revisa la información del app
   - Haz clic en **"Upload"**
   - Espera a que termine el proceso (puede tardar varios minutos)

#### Opción B: Usando Transporter (App de Mac)

1. **Descargar Transporter:**
   - Desde el Mac App Store
   - Busca "Transporter" de Apple

2. **Subir el .ipa:**
   - Abre Transporter
   - Arrastra el archivo `flagle.ipa` desde `build/ios/ipa/`
   - Haz clic en **"Deliver"**
   - Ingresa tus credenciales de Apple ID

#### Opción C: Usando la Línea de Comandos (Avanzado)

```bash
# Instalar altool (si no está instalado)
# Viene con Xcode Command Line Tools

# Subir usando altool
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/flagle.ipa \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID
```

**Para obtener API Key:**
1. Ve a [App Store Connect](https://appstoreconnect.apple.com)
2. Users and Access → Keys
3. Crea una nueva clave con rol "App Manager" o "Admin"
4. Descarga la clave (solo se puede descargar una vez)

### 6. Configurar en App Store Connect

1. **Ir a App Store Connect:**
   - Ve a [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Inicia sesión con tu cuenta de desarrollador

2. **Crear la App (si es la primera vez):**
   - Haz clic en **"My Apps"**
   - Clic en el botón **"+"** → **"New App"**
   - Completa:
     - **Platform:** iOS
     - **Name:** Flagle
     - **Primary Language:** Español o Inglés
     - **Bundle ID:** El que configuraste en Xcode
     - **SKU:** Un identificador único (ej: "flagle-001")
   - Haz clic en **"Create"**

3. **Esperar el Procesamiento:**
   - Después de subir, Apple procesará tu build
   - Esto puede tardar de 10 minutos a varias horas
   - Recibirás un email cuando esté listo
   - Puedes ver el estado en: App Store Connect → TestFlight → Builds

4. **Completar Información de TestFlight:**
   - Ve a la sección **"TestFlight"** en App Store Connect
   - Selecciona tu build procesado
   - Completa la información requerida:
     - **What to Test:** Describe qué quieres que los testers prueben
     - **Feedback Email:** Tu email para recibir feedback

### 7. Agregar Testers

#### Opción A: Testers Internos (Hasta 100)
1. Ve a **TestFlight → Internal Testing**
2. Clic en **"+"** para agregar un grupo
3. Agrega los emails de los testers internos
4. Asigna el build a ese grupo

**Nota:** Los testers internos deben estar en tu equipo de App Store Connect.

#### Opción B: Testers Externos (Hasta 10,000)
1. Ve a **TestFlight → External Testing**
2. Clic en **"+"** para crear un grupo
3. Agrega el build procesado
4. Completa la información de la app:
   - Descripción
   - Capturas de pantalla (requeridas)
   - Información de marketing
   - Política de privacidad (si aplica)
5. Envía para revisión de Apple (puede tardar 24-48 horas)
6. Una vez aprobado, agrega los emails de los testers

### 8. Invitar Testers

1. Ve a **TestFlight → [Tu Grupo]**
2. Clic en **"Add Testers"**
3. Ingresa los emails de los testers
4. Los testers recibirán un email de invitación
5. Deben instalar la app **TestFlight** desde el App Store
6. Abrir el email y aceptar la invitación
7. Descargar tu app desde TestFlight

---

## 🔄 Actualizar una Versión Existente

Cuando quieras subir una nueva versión:

1. **Incrementar el número de build:**
   ```yaml
   # En pubspec.yaml
   version: 1.0.0+2  # Incrementa el +2 a +3, +4, etc.
   ```

2. **Generar nuevo build:**
   ```bash
   flutter clean
   flutter pub get
   flutter build ipa --release
   ```

3. **Subir a App Store Connect** (mismo proceso que antes)

4. **Asignar a grupos de TestFlight** una vez procesado

---

## ✅ Checklist Pre-TestFlight

- [ ] Bundle Identifier configurado y único
- [ ] Signing configurado correctamente en Xcode
- [ ] Versión y build number actualizados en `pubspec.yaml`
- [ ] App probada localmente en dispositivo real
- [ ] No hay errores de consola
- [ ] Ícono de la app configurado
- [ ] Build de release generado exitosamente
- [ ] Build subido a App Store Connect
- [ ] Build procesado por Apple (verificar email)
- [ ] Información de TestFlight completada
- [ ] Testers agregados

---

## 🐛 Solución de Problemas Comunes

### Error: "No signing certificate found"
- **Solución:** Ve a Xcode → Preferences → Accounts → Tu cuenta → Download Manual Profiles

### Error: "Bundle identifier is already in use"
- **Solución:** Cambia el Bundle ID a uno único que no esté en uso

### Error: "Invalid Bundle"
- **Solución:** Verifica que la versión y build number sean correctos y únicos

### Build procesándose por mucho tiempo
- **Normal:** Puede tardar hasta 24 horas en casos raros
- Verifica que no haya errores en App Store Connect

### Testers no reciben invitación
- Verifica que el email sea correcto
- Asegúrate de que el build esté asignado al grupo de testers
- Verifica que el build esté en estado "Ready to Test"

---

## 📱 Para los Testers

### Instrucciones para Testers:

1. **Instalar TestFlight:**
   - Descargar "TestFlight" desde el App Store

2. **Aceptar Invitación:**
   - Abrir el email de invitación
   - Tocar el enlace o código de redención
   - Aceptar en TestFlight

3. **Instalar la App:**
   - Abrir TestFlight
   - Tocar "Install" en tu app
   - La app aparecerá en el home screen

4. **Probar y Dar Feedback:**
   - Usar la app normalmente
   - Si encuentras bugs, usar el botón "Send Feedback" en TestFlight
   - O enviar feedback directamente al email configurado

---

## 📚 Recursos Adicionales

- [Documentación oficial de TestFlight](https://developer.apple.com/testflight/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Guía de Flutter - iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Xcode Documentation](https://developer.apple.com/documentation/xcode)

---

## ⚠️ Notas Importantes

1. **Límites de TestFlight:**
   - Testers internos: 100
   - Testers externos: 10,000
   - Builds expiran después de 90 días

2. **Versiones:**
   - Cada build debe tener un número de build único e incremental
   - No puedes reutilizar números de build

3. **Tiempo de Procesamiento:**
   - Normal: 10-30 minutos
   - Puede tardar hasta 24 horas en casos raros

4. **Revisión de Apple:**
   - Los builds para testers externos requieren revisión
   - Los builds para testers internos no requieren revisión

---

¡Buena suerte con TestFlight! 🚀

