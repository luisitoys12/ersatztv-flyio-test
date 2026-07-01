# 📺 ErsatzTV en Fly.io — Prueba con 3 canales + Terabox

> Repositorio de **prueba** para validar ErsatzTV corriendo en Fly.io con contenido desde Terabox (WebDAV via rclone).

---

## 📌 Arquitectura

```
Terabox (WebDAV)
    ├── /canal1  →  rclone mount →  /mnt/canal1  →  ErsatzTV Canal 1
    ├── /canal2  →  rclone mount →  /mnt/canal2  →  ErsatzTV Canal 2
    └── /canal3  →  rclone mount →  /mnt/canal3  →  ErsatzTV Canal 3 (Comerciales)

Fly.io Volume: /config (persistente)
Fly.io App URL: https://ersatztv-test.fly.dev
```

---

## 🚀 Deploy paso a paso

### 1. Prerrequisitos

```bash
# Instalar flyctl
curl -L https://fly.io/install.sh | sh

# Login
fly auth login
```

### 2. Clonar y preparar

```bash
git clone https://github.com/luisitoys12/ersatztv-flyio-test.git
cd ersatztv-flyio-test
```

### 3. Generar tu rclone.conf con Terabox

```bash
# Instala rclone localmente si no lo tienes
curl https://rclone.org/install.sh | sudo bash

# Configura Terabox
rclone config
# → n (nuevo remoto)
# → nombre: terabox
# → tipo: webdav
# → url: https://dav.terabox.com
# → vendor: other
# → usuario y contraseña de tu cuenta Terabox
```

### 4. Subir el rclone.conf como secret

```bash
# Nunca subas tu rclone.conf al repo — usa secrets de Fly.io
fly secrets set RCLONE_CONFIG="$(cat ~/.config/rclone/rclone.conf)"

# Rutas de tus carpetas en Terabox
fly secrets set TERABOX_CANAL1_PATH="/TuCarpeta/Canal1"
fly secrets set TERABOX_CANAL2_PATH="/TuCarpeta/Canal2"
fly secrets set TERABOX_CANAL3_PATH="/TuCarpeta/Comerciales"
```

### 5. Crear volumen persistente para la config

```bash
fly volumes create ersatztv_config --size 3 --region mia
```

### 6. Hacer deploy

```bash
fly launch --no-deploy   # primera vez
fly deploy
```

### 7. Abrir el panel

```bash
fly open
# o abre: https://ersatztv-test.fly.dev
```

---

## 🎬 Configurar los 3 canales en ErsatzTV

Una vez dentro del panel (`https://ersatztv-test.fly.dev:8409`):

1. **Media Sources → Local** → agrega `/mnt/canal1`, `/mnt/canal2`, `/mnt/canal3`
2. **Libraries** → escanea cada fuente
3. **Channels** → crea `Canal 1`, `Canal 2`, `Canal 3`
4. **Filler Presets** → asigna `/mnt/canal3` (comerciales) con modo Pad 15 min
5. **Schedules** → crea la programación de cada canal

### URLs de salida

| Canal | M3U | XMLTV |
|---|---|---|
| Canal 1 | `/iptv/1/m3u` | `/iptv/1/xmltv` |
| Canal 2 | `/iptv/2/m3u` | `/iptv/2/xmltv` |
| Canal 3 | `/iptv/3/m3u` | `/iptv/3/xmltv` |
| Todos | `/iptv.m3u` | `/xmltv.xml` |

---

## 🔧 Comandos útiles en Fly.io

```bash
# Ver logs en vivo
fly logs

# SSH al contenedor
fly ssh console

# Ver estado de los montajes rclone
fly ssh console -C "ls /mnt/canal1 /mnt/canal2 /mnt/canal3"

# Escalar a 0 (apagar para no gastar)
fly scale count 0

# Volver a encender
fly scale count 1
```

---

## ⚠️ Archivos que NO deben subirse al repo

```
rclone.conf          # contiene tu password
secrets.example.sh   # solo es guía, no subas con datos reales
.env                 # si lo creas
```

El `.gitignore` ya los excluye.

---

> 🧪 Este es un repo de **prueba**. Una vez validado, mover a producción con volumen más grande y región `qro` (Querétaro, la más cercana a Irapuato).
