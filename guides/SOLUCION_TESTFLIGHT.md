# Solución de Problemas para TestFlight

## 🔴 Problemas Detectados

1. ❌ Bundle Identifier es `com.example.flagle` (Apple lo rechaza)
2. ❌ No hay certificado "iOS Distribution"
3. ❌ No hay permisos para crear perfiles de aprovisionamiento
4. ⚠️ Ícono de app es placeholder

---

## ✅ Solución Paso a Paso

### Paso 1: Abrir el Proyecto en Xcode

```bash
cd /Users/marcelodeleon/Developer/personales/flagle
open ios/Runner.xcworkspace
```

**⚠️ IMPORTANTE:** Usa `.xcworkspace`, NO `.xcodeproj`

### Paso 2: Cambiar el Bundle Identifier

1. En Xcode, en el navegador izquierdo, selecciona el proyecto **"Runner"** (el ícono azul)
2. Selecciona el target **"Runner"** (no el proyecto)
3. Ve a la pestaña **"Signing & Capabilities"**
4. En **"Bundle Identifier"**, cambia:
   - De: `com.example.flagle`
   - A: `com.marcelodeleon.flagle` (o algo único que prefieras)

**Formato recomendado:** `com.tudominio.flagle` o `com.tunombre.flagle`

### Paso 3: Configurar el Signing

En la misma pestaña "Signing & Capabilities":

1. ✅ Marca **"Automatically manage signing"**
2. En **"Team"**, selecciona tu equipo: **"Marcelo De León (Y5NN8L7KAX)"**
3. Si aparece un error, haz clic en **"Try Again"** o **"Add Account"**

**Si no tienes una cuenta de desarrollador:**
- Ve a Xcode → Preferences → Accounts
- Haz clic en el **"+"** para agregar tu Apple ID
- Inicia sesión con tu cuenta de Apple

### Paso 4: Verificar Permisos de la Cuenta

El error dice que tu equipo no tiene permisos. Necesitas:

1. **Verificar tu cuenta de desarrollador:**
   - Ve a [developer.apple.com](https://developer.apple.com)
   - Inicia sesión
   - Verifica que tengas una cuenta de desarrollador activa ($99/año)

2. **Si NO tienes cuenta de desarrollador:**
   - Debes registrarte en [developer.apple.com/programs](https://developer.apple.com/programs)
   - Cuesta $99 USD al año
   - Puede tardar 24-48 horas en activarse

3. **Si SÍ tienes cuenta pero no tienes permisos:**
   - El administrador del equipo debe darte permisos de "App Manager" o "Admin"
   - Ve a [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Users and Access → Invite Users

### Paso 5: Generar Certificados (Automático)

Si configuraste correctamente el signing en Xcode:

1. Xcode generará automáticamente los certificados necesarios
2. Si aparece un error, haz clic en **"Download Manual Profiles"**
3. O ve a: Xcode → Preferences → Accounts → Tu cuenta → Download Manual Profiles

### Paso 6: Verificar la Configuración

Antes de generar el build, verifica:

1. **Bundle Identifier:** Debe ser único (no `com.example.*`)
2. **Team:** Debe estar seleccionado
3. **Signing:** "Automatically manage signing" activado
4. **No debe haber errores** en rojo en la pestaña de Signing

### Paso 7: Generar el Build desde Xcode (Recomendado)

En lugar de usar `flutter build ipa`, usa Xcode directamente:

1. En Xcode, selecciona **"Any iOS Device"** en el selector de dispositivos (arriba)
2. Ve a: **Product → Archive**
3. Espera a que termine el proceso
4. Se abrirá automáticamente el **Organizer**
5. Selecciona tu archive y haz clic en **"Distribute App"**
6. Selecciona **"App Store Connect"**
7. Sigue el asistente

**Ventajas:**
- Xcode maneja automáticamente los certificados
- No necesitas configurar manualmente el signing
- Más fácil de depurar problemas

### Paso 8: Alternativa - Usar Flutter Build (Después de configurar Xcode)

Una vez que hayas configurado todo en Xcode:

```bash
# Limpiar
flutter clean

# Obtener dependencias
flutter pub get

# Generar build
flutter build ipa --release
```

---

## 🔧 Solución de Problemas Específicos

### Error: "No signing certificate 'iOS Distribution' found"

**Causa:** No tienes un certificado de distribución.

**Solución:**
1. Ve a Xcode → Preferences → Accounts
2. Selecciona tu cuenta
3. Selecciona tu Team
4. Haz clic en **"Download Manual Profiles"**
5. O verifica que tu cuenta de desarrollador esté activa

### Error: "Team does not have permission to create 'iOS App Store' provisioning profiles"

**Causa:** Tu cuenta no tiene los permisos necesarios.

**Soluciones:**

**Opción A: Verificar permisos en App Store Connect**
1. Ve a [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Users and Access
3. Verifica que tu usuario tenga rol "App Manager" o "Admin"

**Opción B: Si eres el dueño de la cuenta**
1. Asegúrate de que tu cuenta de desarrollador esté activa
2. Puede tardar 24-48 horas después del registro

**Opción C: Si no tienes cuenta de desarrollador**
- Debes registrarte primero en [developer.apple.com/programs](https://developer.apple.com/programs)

### Error: "Bundle identifier is already in use"

**Causa:** El Bundle ID que intentas usar ya está registrado.

**Solución:**
- Cambia el Bundle ID a algo más único
- Ejemplo: `com.marcelodeleon.flagle` o `com.tudominio.flagle`

### Warning: "App icon is set to the default placeholder"

**Solución (Opcional, pero recomendado):**
1. Prepara un ícono de 1024x1024 píxeles
2. En Xcode, ve a `ios/Runner/Assets.xcassets/AppIcon.appiconset`
3. Arrastra tu ícono a todas las resoluciones
4. O usa una herramienta como [App Icon Generator](https://www.appicon.co/)

---

## 📋 Checklist Antes de Intentar de Nuevo

- [ ] Bundle Identifier cambiado (no `com.example.*`)
- [ ] Xcode abierto con `Runner.xcworkspace`
- [ ] "Automatically manage signing" activado
- [ ] Team seleccionado correctamente
- [ ] Cuenta de desarrollador de Apple activa
- [ ] Permisos correctos en App Store Connect
- [ ] No hay errores en rojo en Xcode
- [ ] Ícono actualizado (opcional pero recomendado)

---

## 🚀 Comandos Rápidos

```bash
# Abrir en Xcode
open ios/Runner.xcworkspace

# Limpiar y preparar
flutter clean && flutter pub get

# Verificar configuración
flutter doctor
```

---

## 💡 Recomendación Final

**Usa Xcode para generar y subir el build** en lugar de la línea de comandos:

1. Es más fácil de depurar
2. Maneja automáticamente los certificados
3. Te muestra errores más claros
4. Puedes ver el proceso paso a paso

**Pasos en Xcode:**
1. Product → Archive
2. Distribute App → App Store Connect
3. Sigue el asistente

---

## 📞 Si Aún Tienes Problemas

1. **Verifica tu cuenta de desarrollador:**
   - [developer.apple.com/account](https://developer.apple.com/account)
   - Debe estar activa y pagada

2. **Verifica permisos:**
   - [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Users and Access → Tu usuario

3. **Revisa los logs de Xcode:**
   - Window → Devices and Simulators → View Device Logs

4. **Contacta soporte de Apple:**
   - Si tu cuenta está activa pero sigues teniendo problemas

---

¡Buena suerte! 🎉

