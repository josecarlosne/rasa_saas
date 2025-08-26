# Rasa + Render (Docker) — Template listo para usar

Plantilla mínima de Rasa 3.6 pensada para desplegar en Render con Docker y conectarla a WordPress mediante `rasa-webchat`.

## Requisitos
- Python 3.10 para entrenar localmente (si deseas).
- Cuenta en Render.
- (Opcional) Dos servicios en Render si usas acciones personalizadas:
  - **rasa-core**: servidor de Rasa (este repo).
  - **rasa-actions**: servidor de acciones (mismo repo pero usando `./start_actions.sh`).

## Entrenar localmente (recomendado)
```bash
pip install -r requirements.txt
rasa train
# Se generará ./models/<timestamp>.tar.gz
```
Haz commit del archivo del modelo para evitar entrenar en Render.

## Variables de entorno útiles
- `CORS_ORIGINS`: p. ej. `https://TU-DOMINIO-WP.com`
- `AUTO_TRAIN`: si la pones en `true`, entrenará al arrancar si no hay modelo (consume CPU/RAM).

## Despliegue en Render
1. Crea un **Web Service** desde este repo marcando **Docker**.
2. Deja vacío el *Start Command* para usar el `CMD` del Dockerfile (o pon `./start.sh`).
3. (Opcional) Crea otro Web Service para **actions** con *Start Command* `./start_actions.sh` y ajusta `endpoints.yml` con la URL pública del servicio de actions.
4. Añade `CORS_ORIGINS` con tu dominio de WordPress.
5. **No uses** los Free Tiers más pequeños si ves OOM (TensorFlow consume RAM).

## Conectar a WordPress
Inserta este snippet en el footer (plugin “Insert Headers and Footers”):
```html
<script src="https://cdn.jsdelivr.net/npm/rasa-webchat@latest/lib/index.js"></script>
<script>
  window.addEventListener("load", function () {
    WebChat.default({
      title: "Asistente",
      subtitle: "¿En qué te ayudo?",
      initPayload: "/greet",
      socketUrl: "https://TU-SERVICIO-CORE.onrender.com",
      socketPath: "/socket.io/",
      customData: { language: "es" },
      storage: "session",
      embedded: false
    }, null);
  });
</script>
```

## Estructura
- `start.sh`: arranca el servidor de Rasa.
- `start_actions.sh`: arranca el servidor de acciones.
- `credentials.yml`: habilita REST y Socket.IO con CORS.
- `endpoints.yml`: URL del action server.
- `config.yml`, `domain.yml`, `data/*`: bot mínimo de ejemplo.

## Objetivo del chatbot (demo)
- Resolver saludos y despedidas y confirmar que es un asistente.
- Base para extender con intents/acciones de tu negocio.
