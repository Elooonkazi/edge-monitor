FROM alpine:3
RUN apk add --no-cache curl unzip ca-certificates darkhttpd && \
    curl -fsSL -o /tmp/nezha.zip https://github.com/nezhahq/agent/releases/download/v2.3.5/nezha-agent_linux_amd64.zip && \
    mkdir -p /app && unzip -o /tmp/nezha.zip -d /app && chmod +x /app/nezha-agent && rm -f /tmp/nezha.zip && \
    echo "ok" > /app/index.html
WORKDIR /app
ENV NZ_DISABLE_AUTO_UPDATE=true
# nezha-agent (v2) reads NZ_SERVER / NZ_CLIENT_SECRET / NZ_TLS env vars automatically, no CLI flags.
# Deplexo requires the app to pass an HTTP readiness check on $PORT: darkhttpd (standalone tiny server,
# busybox httpd applet is missing in Deplexo's alpine) serves 200 on ${PORT:-3000}, agent runs in background.
CMD ["/bin/sh", "-c", "/app/nezha-agent > /tmp/agent.log 2>&1 & exec darkhttpd /app --port ${PORT:-3000}"]
