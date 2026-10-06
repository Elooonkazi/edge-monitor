FROM alpine:3
RUN apk add --no-cache curl unzip ca-certificates && curl -fsSL -o /tmp/nezha.zip https://github.com/nezhahq/agent/releases/download/v2.3.5/nezha-agent_linux_amd64.zip && mkdir -p /app && unzip -o /tmp/nezha.zip -d /app && chmod +x /app/nezha-agent && rm -f /tmp/nezha.zip
WORKDIR /app
ENV NZ_DISABLE_AUTO_UPDATE=true
ENTRYPOINT ["/bin/sh", "-c", "/app/nezha-agent -s ${NZ_SERVER} -p ${NZ_CLIENT_SECRET}"]
